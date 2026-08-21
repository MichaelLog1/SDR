from numerically_controlled_oscillator import get_phase_sequence
import signal_source
import numpy as np
import helpers

def mixer(signal, sin, cos, f_desired, N, mode='convergent'):
    if len(signal) != N:
        raise ValueError("Signal must be of length N.")

    I = signal.astype(np.int32) * cos
    Q = signal.astype(np.int32) * -1 * sin

    # round off to 16 bits precision
    # product width = adc_bits + nco_bits - 1 = 16 + 16 - 1 = 31 (was 29 for a 14-bit ADC)
    I = helpers.round_by_mode(I / (2**(31 - 16)), mode)
    Q = helpers.round_by_mode(Q / (2**(31 - 16)), mode)

    I = np.clip(I, -1 * 2**(16 - 1), 2**(16 - 1) - 1)
    Q = np.clip(Q, -1 * 2**(16 - 1), 2**(16 - 1) - 1)

    return np.int16(I), np.int16(Q)

def main():
    fs = 122.88e6
    N = 2**16
    W = 32 # 32 bit accumulator word
    P = 15 # we will assume the P value we got from the NCO testing
    bits = 16

    signal_bin = 3456
    desired_bin = 5698
    f_signal = signal_bin * fs / N
    f_desired = desired_bin * fs / N

    signal = signal_source.sine(fs, N, 1, bin=signal_bin)
    sin, cos = get_phase_sequence(f_desired, fs, N, W, P, bits)

    I, Q = mixer(signal, sin, cos, f_desired, N, mode='round_half_up')

    helpers.assert_downconversion_tones(I, Q, f_signal, f_desired, fs, N)

    return

if __name__ == '__main__':
    main()
