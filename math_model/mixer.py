from numerically_controlled_oscillator import get_phase_sequence
import signal_source
import numpy as np
import helpers

def mixer(signal, f_desired, fs, N, W, P):
    if len(signal) != N:
        raise ValueError("Signal must be of length N.")

    sin, cos = get_phase_sequence(f_desired, fs, N, W, P)

    I = signal * cos
    Q = signal * -1 * sin

    return I, Q

def main():
    fs = 125e6
    N = 2**16
    W = 32 # 32 bit accumulator word
    P = 15 # we will assume the P value we got from the NCO testing

    signal_bin = 3456
    desired_bin = 5698
    f_signal = signal_bin * fs / N
    f_desired = desired_bin * fs / N

    signal = signal_source.sine(fs, N, 2, bin=signal_bin)
    I, Q = mixer(signal, f_desired, fs, N, W, P)

    helpers.assert_downconversion_tones(I, Q, f_signal, f_desired, fs, N)

    return

if __name__ == '__main__':
    main()
