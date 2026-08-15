from numerically_controlled_oscillator import initialize_lookup_table
import numpy as np

def NCO(phase_inc, N_in, write_artifacts=True):
    # W=32, P given
    W = 32
    P = 15

    sin, cos = initialize_lookup_table(W, P, 16)     # int16, your existing fn
    idx  = (np.arange(N_in) * phase_inc) % (2**W)               # same recurrence as HW accumulator
    addr = idx >> (W - P)  
    
    if (write_artifacts):
        with open("nco_expected.hex", "w") as fh:
            for a in addr:
                word = ((int(sin[a]) & 0xFFFF) << 16) | (int(cos[a]) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    return sin[addr], cos[addr]

if __name__ == "__main__":
    NCO(343597384, 1000)
