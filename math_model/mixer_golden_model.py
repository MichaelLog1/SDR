from helpers import round_by_mode
import numpy as np


def complex_multiply(adc, sine, cosine, mode='round_half_up'):
    I = adc.astype(np.int32) * cosine
    Q = adc.astype(np.int32) * -1 * sine

    # round off to 16 bits precision
    I = round_by_mode(I / (2**(31 - 16)), mode)
    Q = round_by_mode(Q / (2**(31 - 16)), mode)

    I = np.clip(I, -1 * 2**(16 - 1), 2**(16 - 1) - 1)
    Q = np.clip(Q, -1 * 2**(16 - 1), 2**(16 - 1) - 1)

    return np.int16(I), np.int16(Q)


def mixer(adc, sin, cos, write_artifacts=True):
    assert len(adc) == len(sin) == len(cos), f"Mixer length error."

    if (write_artifacts):
        with open("mixer_stimulus.hex", "w") as fh:
            for a, s, c in zip(adc, sin, cos):
                fh.write(f"{((int(a) & 0xFFFF) << 32) | ((int(s) & 0xFFFF) << 16) | (int(c) & 0xFFFF):012x}\n")

    I, Q = complex_multiply(adc, sin, cos)

    if (write_artifacts):
        with open("mixer_expected.hex", "w") as fh:
            for i, q in zip(I, Q):
                fh.write(f"{((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF):08x}\n")

    return I, Q


if __name__ == "__main__":
    seed = 10
    rng = np.random.default_rng(seed)

    N = 1000

    # generate random inputs
    adc = rng.integers(-32768, 32768, N, dtype=np.int16)
    sin = rng.integers(-32768, 32768, N, dtype=np.int16)
    cos = rng.integers(-32768, 32768, N, dtype=np.int16)

    mixer(adc, sin, cos)
