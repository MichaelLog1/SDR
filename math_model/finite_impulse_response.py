# passband - +-25kHz
# transition band - 25kHz to 75kHzok 

import scipy.signal as sc
import numpy as np
import matplotlib.pyplot as plt
import cascaded_integrator_comb as CIC
import signal_source

def FIR(signal, taps, decimation_factor):
    # y = np.zeros(len(signal) // decimation_factor)
    # for i in range(0, len(signal), decimation_factor):
    #     sum = 0
    #     for j in range(0, len(taps)):
    #         signal_index = i - j
    #         if signal_index >= 0:
    #             sum += signal[signal_index] * taps[j]
    #     y[i // decimation_factor] = sum
    result = np.convolve(signal, taps, mode='same')
    return result[::4]

def main():
    fs = 125e6
    CIC_num_stages = 6
    CIC_decimation_factor = 625
    CIC_differential_delay = 1
    FIR_decimation_factor = 4

    num_taps = 140

    N_out = 2**7
    bin = 3045
    f_bin = bin * fs / (N_out * CIC_decimation_factor * FIR_decimation_factor)
    FIR_guard = int(np.ceil((num_taps - 1) / FIR_decimation_factor))
    N_in = (N_out + FIR_guard) * FIR_decimation_factor * CIC_decimation_factor

    freq_step = 100
    freq = np.linspace(0, 100000, freq_step, endpoint=True)
    
    freq_region_1 = freq <= 25000
    freq_region_2 = (freq > 25000) & (freq <= 75000)
    freq_region_3 = freq > 75000

    gain_region_1 = 1 / (np.sinc(freq[freq_region_1] * CIC_differential_delay * CIC_decimation_factor / fs) / np.sinc(freq[freq_region_1] / fs)) ** CIC_num_stages
    gain_region_2 = np.linspace(gain_region_1[-1], 0, len(freq[freq_region_2]))
    gain_region_3 = np.zeros(len(freq[freq_region_3]))

    gain = np.concatenate((gain_region_1, gain_region_2, gain_region_3))
    # gain_dB = 20 * np.log10(gain / ((CIC_decimation_factor * CIC_differential_delay) ** CIC_num_stages))
    # plt.plot(freq, gain_dB)
    # plt.show()

    taps = sc.firwin2(num_taps, freq, gain, fs=200000)    
    w, h = sc.freqz(taps, fs=200000)
    CIC_amplitude_dB = 20*np.log10((np.sinc(w * CIC_differential_delay * CIC_decimation_factor / fs) / np.sinc(w / fs)) ** CIC_num_stages)

    dB_FIR = CIC_amplitude_dB + 20*np.log10(np.abs(h))

    # plt.plot(w, dB_plot)
    # plt.show()
    # plt.savefig("plot.png")
    passband_region = w <= 25000
    print(f"Passband Flatness: {max(dB_FIR[passband_region]) - min(dB_FIR[passband_region])}")

    # put CIC and FIR together
    signal = signal_source.sine(fs, N_in, 1, frequency=f_bin)
    CIC_output = CIC.CIC(signal, N_in, CIC_decimation_factor, CIC_differential_delay, CIC_num_stages)
    FIR_output = FIR(CIC_output, taps, FIR_decimation_factor)
    FIR_output = FIR_output[FIR_guard:]

    fft_output = (2 / len(FIR_output)) * np.abs(np.fft.fft(FIR_output))

    plt.plot(np.arange(0, len(fft_output)), fft_output)
    #plt.show()
    plt.savefig("FIR.png")

    # actual sweep
    first_null = 1 * fs / (CIC_differential_delay * CIC_decimation_factor)
    second_null = 2 * fs / (CIC_differential_delay * CIC_decimation_factor)
    bin_spacing = fs / (N_out * CIC_decimation_factor * FIR_decimation_factor)
    f_range = np.arange(first_null, second_null, bin_spacing)

    print(f"Expected sweep iterations: {len(f_range)}")
    sweep_db = np.zeros(len(f_range))
    for i, f in enumerate(f_range):
        print(f"Sweep Iteration: {i}")
        signal = signal_source.sine(fs, N_in, 1, frequency=f)
        CIC_output = CIC.CIC(signal, N_in, CIC_decimation_factor, CIC_differential_delay, CIC_num_stages)
        FIR_output = FIR(CIC_output, taps, FIR_decimation_factor)
        FIR_output = FIR_output[FIR_guard:]
        fft_output = (2 / N_out) * np.abs(np.fft.fft(FIR_output))
        
        max_amplitude = np.max(fft_output)
        
        sweep_db[i] = 20 * np.log10(max_amplitude / ((CIC_decimation_factor * CIC_differential_delay) ** CIC_num_stages))

        print(f"Logging maximums: Max Amplitude: {max_amplitude}")
        
    print(f"Max Droop between first two Nulls: {max(sweep_db)}")


if __name__ == "__main__":
    main()
