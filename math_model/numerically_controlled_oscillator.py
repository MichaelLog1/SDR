# Numerically Controlled Oscillator in software. We use this to determine what
# value of P we will use in the DUT. We need to keep the error introduced
# by the sine/cosine lookup table below 70-80 dBs (default error introduced
# by our ADC)
# From testing, P should be 15, perhaps 14 will be fine.

import numpy as np
from helpers import SFDR, quantize
import sys

# W - accumulator width
# P - lookup table bit width

# TODO: Quantize the lookup table elements
# Currently this is a float implementation, we will need to implement this in fixed point before we impleemnt.

def initialize_lookup_table(W, P, bits):
    if P > W:
        raise ValueError("P must be less than W.")

    lookup_table_sin = np.sin(2 * np.pi * np.arange(0, 2**P) / 2**P)
    lookup_table_cos = np.cos(2 * np.pi * np.arange(0, 2**P) / 2**P)

    return quantize(lookup_table_sin, bits), quantize(lookup_table_cos, bits)

def get_phase_sequence(f_desired, fs, N, W, P, bits):
    sin, cos = initialize_lookup_table(W, P, bits)

    M = round(f_desired * (2**W)/fs)

    indices = (np.arange(0, N) * M) % (2**W)
    indices_truncated = indices >> (W-P)

    return sin[indices_truncated], cos[indices_truncated]

def main():
    W = 32 # we will keep the accumulator word to 32 bits

    # this test will sweep value of P
    P_start = 12
    P_end = 16
    fs = 125e6
    N_fft = 2**16

    bits = 16

    # sanity test on the desired frequenct math
    bin_range = np.arange(1, N_fft//2)
    rng = np.random.default_rng()
    bins = rng.choice(bin_range, size=10000, replace=False)
    f_desireds = bins * fs / N_fft

    # sweep values of P and get SFDR values to see how clean our signal gets across all bins
    for P in range(P_start, P_end+1):
        min_sfdr = sys.maxsize * 2 + 1
        worst_bin = -1
        worst_frequency = -1
        for i, f_desired in enumerate(f_desireds):
            sin, cos = get_phase_sequence(f_desired, fs, N_fft, W, P, bits)
            sfdr = SFDR(cos, bins[i])
            if sfdr < min_sfdr:
                min_sfdr = sfdr
                worst_bin = bins[i]
                worst_frequency = f_desired


        print(f"Worst case SFDR for P={P}: Bin={worst_bin}, Frequency={worst_frequency} SFDR={min_sfdr}")

    return

if __name__ == "__main__":
    main()