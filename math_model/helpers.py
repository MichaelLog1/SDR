import numpy as np

# Red Pitaya ACD samples at 125 Msps
fs = 125e6
# Number of FFT bins
N = 2**16

# We will test with a frequency that exactly matches a bin
f = 3 * fs/N

f_spur = 700 * fs/N

def power_spectrum(signal):
    fft_output = np.fft.rfft(signal)
    
    for i in range(0, int(len(signal)/2) + 1):
        if i == 0:
            continue
        else:
            fft_output[i] = 10 * np.log10(np.abs(fft_output[i]) ** 2)

    return fft_output


# to test signal noise ratio, we will inject noise at a known per-sample
# standard deviation. The average power of this is sigma squared.
def SNR(signal, signal_bin):
    signal_power = 0
    noise_floor = 0

    fft_output = np.fft.rfft(signal)

    for i in range(0, int(len(signal)/2) + 1):
        if i == 0:
            continue
        elif i == signal_bin:
            signal_power += np.abs(fft_output[i]) ** 2
        else:
            noise_floor += np.abs(fft_output[i]) ** 2

    return 10 * np.log10(signal_power / noise_floor)

def SFDR(signal, signal_bin):
    signal_amplitude = 0
    spur_amplitude = 0

    fft_output = np.fft.rfft(signal)

    for i in range(0, int(len(signal)/2) + 1):
        if i == 0:
            continue
        elif i == signal_bin:
            signal_amplitude += np.abs(fft_output[i])
        else:
            spur_amplitude = max(spur_amplitude, np.abs(fft_output[i]))

    return 20 * np.log10(signal_amplitude / spur_amplitude)


def main():

    A_signal = 1
    A_spur = 0.3
    sigma = 3
    snr_tolerance_sigma = 2

    # allows tests to pass always
    np.random.seed(550)

    x = np.zeros(N)
    spur = np.zeros(N)

    for n in range(0, N):
        x[n] = A_signal*np.sin(2 * np.pi * f * n / fs)

    # noisy signal
    noise = np.random.normal(0, sigma, N)

    # spurious signal
    for n in range(0, N):
        spur[n] =  A_spur * np.sin(2 * np.pi * f_spur * n / fs)

    x_noise = x + noise
    x_spur = x + spur

    expected_snr = 10*np.log10(((A_signal**2)/2)/(sigma**2))
    expected_sfdr = 20*np.log10(A_signal/A_spur)

    # tolerance values, tweakable
    snr_tolerance = snr_tolerance_sigma * (10 / np.log(10)) * np.sqrt(2 / N)
    sfdr_tolerance = 0.0001

    assert(abs(SNR(x_noise, 3) - expected_snr) < snr_tolerance)
    assert(abs(SFDR(x_spur, 3) - expected_sfdr) < sfdr_tolerance)
    print(f"Signal Noise Ratio - Actual: {SNR(x_noise, 3)}, Expected: {expected_snr}")
    print(f"Spurious Free Dynamic Range - Actual: {SFDR(x_spur, 3)}, Expected: {expected_sfdr}")

if __name__ == '__main__':
    main()