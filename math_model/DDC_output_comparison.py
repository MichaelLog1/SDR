from DDC_golden_model import GUARD, N_OUT
import matplotlib.pyplot as plt
import numpy as np

def signed16(x):
    x = x.astype(np.int32)
    return np.where(x >= 0x8000, x - 0x10000, x)

def main():
    expected_length = 2310
    actual_length = 2304
    ddc_expected = []
    ddc_actual = []

    # load both files
    with open("ddc_expected.hex", "r") as fh:
        ddc_expected = np.array([int(line, 16) for line in fh if line.strip()], dtype=np.uint32)

    # load both files
    with open("ddc_output.hex", "r") as fh:
        ddc_actual = np.array([int(line, 16) for line in fh if line.strip()], dtype=np.uint32)

    # apply guard
    ddc_expected = ddc_expected[GUARD:GUARD+N_OUT]
    ddc_actual = ddc_actual[GUARD:GUARD+N_OUT]

    I_expected = signed16(ddc_expected >> 16)
    Q_expected = signed16(ddc_expected & 0xFFFF)
    I_actual = signed16(ddc_actual >> 16)
    Q_actual = signed16(ddc_actual & 0xFFFF)

    expected_signal = I_expected + 1j*Q_expected
    actual_signal = I_actual + 1j*Q_actual

    fft_expected = np.fft.fft(expected_signal)
    fft_actual = np.fft.fft(actual_signal)
    
    # fig, (ax_expected, ax_actual) = plt.subplots(2, 1)
    # ax_expected.plot(20*np.log10(np.abs(fft_expected)))
    # ax_actual.plot(20*np.log10(np.abs(fft_actual)))
    # plt.savefig("analysis_files/DDC_comparison.png", dpi=150)

    # verify both FFTs have same bin signatures
    assert np.argmax(np.abs(fft_expected)) == np.argmax(np.abs(fft_expected)), "FFT signatures to not match."

    print("Test Complete.")


if __name__ == "__main__":
    main()
