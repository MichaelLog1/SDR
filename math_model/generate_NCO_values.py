from numerically_controlled_oscillator import initialize_lookup_table

def main():
    W = 32
    P = 15

    sin, cos = initialize_lookup_table(W, P, 16)      # int16 arrays, length 2**P
    with open(f"nco_lut_p{P}.hex", "w") as fh:
        for s, c in zip(sin, cos):
            word = ((int(s) & 0xFFFF) << 16) | (int(c) & 0xFFFF)
            fh.write(f"{word:08x}\n")

if __name__ == "__main__":
    main()
