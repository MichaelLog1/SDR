from numerically_controlled_oscillator import initialize_lookup_table
import numpy as np

def main():
    # W=32, P, M, N given
    W = 32
    P = 15
    M = 1234
    N = 1000

    sin, cos = initialize_lookup_table(W, P, 16)     # int16, your existing fn
    idx  = (np.arange(N) * M) % (2**W)               # same recurrence as HW accumulator
    addr = idx >> (W - P)                            # same top-P-bit tap
    with open("nco_expected.hex", "w") as fh:
        for a in addr:
            word = ((int(sin[a]) & 0xFFFF) << 16) | (int(cos[a]) & 0xFFFF)
            fh.write(f"{word:08x}\n")

if __name__ == "__main__":
    main()
