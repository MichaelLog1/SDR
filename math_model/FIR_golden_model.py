import numpy as np
import scipy.signal as sc

# constants
TAPS = 282
DECIMATION_FACTOR = 4
fs = 125e6
CIC_NUM_STAGES = 6
CIC_DECIMATION_FACTOR = 625
CIC_DIFFERENTIAL_DELAY = 1

def saturate_16(v):
        return max(-32768, min(32767, v))


def FIR(I_in, Q_in, write_artifacts=True):
    # generate quantized taps
    freq_step = 100
    freq = np.linspace(0, 100000, freq_step, endpoint=True)

    # determine gain regions

    freq_region_1 = freq <= 25000
    freq_region_2 = (freq > 25000) & (freq <= 75000)
    freq_region_3 = freq > 75000

    gain_region_1 = 1 / (np.sinc(freq[freq_region_1] * CIC_DIFFERENTIAL_DELAY * CIC_DECIMATION_FACTOR / fs) / np.sinc(freq[freq_region_1] / fs)) ** CIC_NUM_STAGES
    gain_region_2 = np.linspace(gain_region_1[-1], 0, len(freq[freq_region_2]))
    gain_region_3 = np.zeros(len(freq[freq_region_3]))
    gain = np.concatenate((gain_region_1, gain_region_2, gain_region_3))

    taps = sc.firwin2(TAPS, freq, gain, fs=200000)

    # quantize
    C = [int(round(t * 2**15)) for t in taps]

    # write taps
    if (write_artifacts):
        with open("fir_taps.hex", "w") as fh:
            for c in C:
                fh.write(f"{c & 0xFFFF:04x}\n")

    # write stimulus
    if (write_artifacts):
        with open("fir_stimulus.hex", "w") as fh:
            for i, q in zip(I_in, Q_in):
                word = ((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    I_out = []
    Q_out = []

    for n in range (len(I_in)):
        if (n + 1) % DECIMATION_FACTOR == 0:
            accumulator_I = accumulator_Q = 0
            for k in range(TAPS):
                s_I = int(I_in[n-k]) if n-k >=0 else 0
                s_Q = int(Q_in[n-k]) if n-k >=0 else 0
                accumulator_I += s_I * C[k]
                accumulator_Q += s_Q * C[k]
            I_out.append(saturate_16((accumulator_I + (1 << 14)) >> 15))
            Q_out.append(saturate_16((accumulator_Q + (1 << 14)) >> 15))

    # write golden model
    if (write_artifacts):
        with open("fir_expected.hex", "w") as fh:
            for i, q in zip(I_out, Q_out):
                word = ((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    return I_out, Q_out

if __name__ == "__main__":
    seed = 10
    rng = np.random.default_rng(seed)
    
    N = 4000

    # randomize inputs
    I_in = rng.integers(-32768, 32768, N, dtype=np.int16)
    Q_in = rng.integers(-32768, 32768, N, dtype=np.int16)

    FIR(I_in, Q_in)
