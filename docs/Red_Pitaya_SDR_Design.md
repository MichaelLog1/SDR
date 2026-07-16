# Red Pitaya SDR Receiver — Design Document & NumPy Model Plan

Owner: Michilly. All RTL and model code is to be written by me; Claude provides guidance only.

## Project statement

A verified, direct-sampling HF receiver on the Red Pitaya, built from my own IP, with
measured performance that matches the design math.

Explicit non-goals: maximizing Fmax (the DDC needs exactly 125 MHz and no more),
copying existing Red Pitaya SDR code (reference architectures may be studied for
sanity-checking only).

Project priorities, in order:
1. End-to-end functionality: antenna in, audio out, through my own fabric design.
2. Verification rigor: golden-model-driven testbenches, measured results matching theory
   (SNR through the chain, NCO spur levels vs. predicted, filter response vs. designed).
3. One quantified engineering tradeoff articulated with numbers (resource vs. performance,
   e.g. NCO table size vs. spur floor).

Stretch features (only after the base works): multiple simultaneous receivers from one ADC
stream, fabric-computed wideband FFT waterfall, automated decoding (WWV time code, FT8).

## Hardware context

- Red Pitaya: Zynq-7010/7020 (ARM + fabric), dual 125 MSps 14-bit ADC, dual 125 MSps DAC.
- Direct-sampling receiver: no analog mixing; honest coverage ~0–50 MHz (first Nyquist
  zone, staying below 62.5 MHz). Covers all of HF: shortwave broadcast, amateur bands, WWV.
- The board's analog front end handles anti-alias filtering ahead of the ADC.

## Architecture — functional blocks

Signal path (FPGA fabric, runs at 125 MHz):
1. **ADC interface** — pin-level capture, clocking, presents signed 14-bit samples as a
   valid-qualified stream. Pin-level portions exist in reference designs; the deliverable
   is a clean handoff into my own datapath.
2. **NCO** — phase accumulator + sine/cosine lookup. Phase-increment word = tuning control.
   Design decisions: accumulator width, table depth, phase truncation, dithering,
   quarter-wave symmetry (table shrinks to 2^(P-2) entries).
3. **Complex mixer** — two multipliers + rounding stage. Multiplies real ADC stream by
   NCO cos/sin to produce I and Q at baseband.
4. **CIC decimator** (one per channel) — N integrators, decimate-by-R, N combs.
   Multiplier-free. Owns bit-growth math and (optionally) Hogenauer register pruning.
5. **FIR compensator** — inverse-sinc^N passband correction, real stopband rejection,
   final decimate-by-4. Coefficients 18-bit signed (DSP48E1 native 25x18).
6. **AXI-Stream + DMA transport** — packs I/Q into 32-bit {I,Q} words, DMA to DDR.
   Includes packing format, backpressure handling, overflow detection.

Control plane:
7. **AXI4-Lite control/status registers** — tuning word, decimation settings, enables,
   status. Makes the radio tunable at runtime.

Software:
8. **ARM streaming daemon** (Linux userspace) — configures DMA, reads buffers, ships IQ
   over TCP/UDP; small control API (set frequency, set rate). Plan: speak an existing SDR
   protocol first so standard SDR software works as the client for free.
9. **PC client** — demodulation, waterfall, audio. Own demodulators are a later software
   phase (AM = magnitude of I/Q; SSB = frequency shift + filter; FM = phase differentiation).

Build order: NCO → mixer → CIC → FIR (all verified in simulation against golden models
before hardware) → control registers → transport → software.

## Proposed spec (numbers to be confirmed/adjusted by the NumPy model)

| Boundary | Rate | Width / format | Set by |
|---|---|---|---|
| ADC → mixer | 125 MSps | 14-bit signed | hardware |
| NCO → mixer | 125 MSps | 16-bit sin/cos; 32-bit accumulator; P-bit table address (P = 12–14 TBD) | spur budget |
| Mixer → CIC | 125 MSps | 16-bit I, 16-bit Q (rounded from 29) | rounding analysis |
| CIC internal | — | up to ~54-bit full width, or pruned schedule (TBD) | Hogenauer math |
| CIC → FIR | 200 kSps | e.g. 18-bit rounded (TBD) | noise budget |
| FIR → pack | 50 kSps | 16-bit I / 16-bit Q | output spec |
| Pack → DMA | 50 k words/s | 32-bit {I,Q} | bus format |

Key spec choices and rationale:
- **Output**: 50 kHz complex IQ. Total decimation R_total = 2500 (must divide 125 MHz by
  an integer; 192 kHz does not and is rejected). Window is wide enough for AM (~10 kHz)
  and SSB (~3 kHz) with margin.
- **Decimation split**: CIC R = 625, FIR decimate-by-4. CIC = cheap crude worker at full
  rate (no multipliers); FIR = precise finisher at low rate that corrects CIC droop.
- **CIC stages**: N = 3 or 4, undecided — settled by alias-rejection calculation
  (see Experiment E1). More stages = deeper suppression at fold-over frequencies but more
  droop and more bit growth. This is a permanent-damage decision: aliased energy in the
  passband can never be removed downstream.
- **Performance philosophy / noise budget**: the 14-bit ADC's noise floor and SFDR
  (~70–80 dB neighborhood) form the budget. Every artifact I introduce (NCO spurs, CIC
  aliases, rounding noise, filter ripple) must sit below that floor, so the finished radio
  is ADC-limited, never arithmetic-limited. No overprovisioning either — every width must
  be justified.
- **Flatness target**: composite CIC×FIR passband response flat within ±0.1 dB across the
  50 kHz passband (measured, not eyeballed).

Design equations in play:
- NCO frequency resolution: f_res = f_clk / 2^A. A = 32 → 0.029 Hz steps; matches one
  32-bit AXI4-Lite register.
- NCO phase-truncation spurs: worst case ≈ -6.02·P dBc for P table-address bits.
  P = 12–14 → -72 to -84 dBc. Each extra bit buys ~6 dB. Dithering smears residual
  discrete spurs into noise.
- Signed multiply growth: m-bit × n-bit → m+n-1 significant bits (14×16 = 29 at mixer).
- CIC bit growth: B_out = B_in + N·log2(R·M). With B_in=16, N=4, R=625, M=1:
  growth ≈ 38 bits → ~54-bit first integrator. Hogenauer pruning shaves per-stage widths
  with provably bounded added noise.
- Rounding: plain truncation biases one direction → DC spike at 0 Hz (center of the tuned
  station). Convergent rounding removes the bias. Rounding mode is an explicit,
  documented decision at every width reduction.

## NumPy golden model — plan

Purpose: answer every signal-quality question in the spec by experiment before any RTL.
The model does NOT answer resource/timing questions (BRAM counts, Fmax, pruning savings) —
those come from Vivado later and cannot invalidate the signal design.

Structure — one function per hardware block, mirroring the block diagram 1:1 (this is what
makes it a golden model: each RTL module gets a NumPy twin for testbench comparison):

1. `signal_source` — synthetic antenna: 2–3 tones at known frequencies/amplitudes (one
   strong, one ~60 dB weaker for ghost-hunting), plus white noise scaled to the 14-bit
   quantization floor; quantized to 14-bit integers. Use short records (memory: seconds at
   125 MHz is hundreds of megasamples); FFT length sets how deep the spectrum floor is
   visible.
2. `nco` — modeled STRUCTURALLY: integer phase accumulator + table lookup, never
   np.cos(2*pi*f*t). Imperfections come from the structure. Parameters: accumulator width,
   table address bits P, table amplitude bits, dither on/off.
3. `mixer` — multiply + parameterized rounding (truncate / round-half-up / convergent),
   switchable as an experiment.
4. `cic` — literal N integrators, decimate-by-R, N combs; integer arithmetic; explicit
   register widths. Not scipy.signal.decimate (may be used only to cross-check
   correctness).
5. `fir` — coefficients from scipy.signal (firwin2/remez shaped as inverse-sinc^N
   compensator), quantized to 18 bits, apply + decimate by 4.
6. Analysis helpers (BUILD FIRST, validate on a pure sine with known SNR):
   windowed-FFT spectrum plot in dB; SNR measurement.

Cross-cutting rule: a single explicit `quantize(x, bits, mode)` function used at every
width reduction. Each call site corresponds to exactly one rounding point in the RTL, so
model-vs-testbench comparison is exact, not approximate.

Construction order: analysis helpers → signal source → float NCO/mixer (checkpoint: test
tone lands at the correct output frequency) → float CIC → float FIR (checkpoint: flat
composite response) → fixed-point conversion pass stage by stage, running experiments
along the way.

## Experiments mapped to open decisions

- **E1 — CIC stage count (N = 3 vs 4)**: evaluate the CIC magnitude response formula at
  the fold-over frequencies (frequencies that alias into the passband after decimation by
  625); plot both N. Confirm by simulation: place a tone exactly at a fold-over frequency,
  measure ghost level in the output. Formula must predict measurement. Decides N.
- **E2 — NCO table size**: run the chain with P = 8, 10, 12, 14; spectrum-plot each; ghosts
  of the strong tone sink ~12 dB per step until buried in the noise floor. The plot where
  they disappear is the spec justification. Then toggle dithering; watch discrete spurs
  smear to hiss. Decides P and dithering. (This is the designated documented tradeoff:
  BRAM vs. spur floor.)
- **E3 — Rounding mode**: truncate at the mixer → observe 0 Hz spike in output spectrum;
  switch to convergent → spike gone. Two plots, decision documented.
- **E4 — Bit widths (the big one)**: full chain in float = reference SNR. Convert to fixed
  point stage by stage, measuring output SNR after each conversion. Any stage that drops
  SNR noticeably is under-provisioned. Iterate until fixed-point output is within a
  fraction of a dB of float. The final width table falls out with a measurement behind
  every row.
- **E5 — Flatness**: plot composite CIC×FIR response across the 50 kHz passband; measure
  peak-to-peak ripple vs ±0.1 dB target; adjust FIR design until pass.
- **E6 (optional, for intuition)** — deliberately break things in the float model: 6-bit
  NCO table (watch ghost stations appear), truncation (watch the DC spike grow). See each
  failure mode once so every spec number feels earned.

Decisions 1 (output rate), 2 (decimation split), 5 (accumulator width) are settled by
arithmetic and confirmed incidentally.

## Verification approach (carries into RTL phase)

- Self-checking testbenches driven by the NumPy golden model (UVM background applies).
- Every RTL module compared against its NumPy twin; quantize() call sites map 1:1 to RTL
  rounding points.
- Evidence for the write-up: measured SNR through the chain, NCO spur levels vs. -6.02·P
  prediction, composite filter response vs. design, E1–E5 plots.

## Reading list

- Lyons, *Understanding Digital Signal Processing* — primary text; quadrature signals
  chapter essential; mixing, decimation, CIC coverage at the right depth.
- Hogenauer (1981), "An Economical Class of Digital Filters for Decimation and
  Interpolation" — canonical bit-growth/pruning reference.
- Youngblood, "A Software-Defined Radio for the Masses" (QEX series, free online) —
  radio-side intuition.
- Pavel Demin's Red Pitaya SDR projects — block diagrams / register maps for architecture
  sanity checks only (no code copying).
- Xilinx DDS and CIC compiler product guides — parameter tradeoff documentation (table
  sizes, dithering, differential delay), even though all IP is written from scratch.

## Current status

- Board on hand. Spec drafted above (numbers marked TBD pending model experiments).
- Next action: build the NumPy model — analysis helpers and signal source first, then
  float NCO/mixer to the "test tone lands where it should" checkpoint.