import numpy as np
import signal_source
import matplotlib.pyplot as plt
import sys

def integrator(x):
    return np.cumsum(x)

def comb(x, N, M):

    return x - np.concatenate((np.zeros(M), x[:-1*M]))

def CIC(signal, N, R, M, num_stages):

    # integrate
    integrator_stage_output = np.zeros((num_stages, N))
    for i in range(0, num_stages):
        if i == 0:
            integrator_stage_output[i] = integrator(signal)
        else:
            integrator_stage_output[i] = integrator(integrator_stage_output[i-1])

    # decimate
    decimator_stage_output = np.zeros(N // R)
    for i in range(0, N // R):
        decimator_stage_output[i] = integrator_stage_output[num_stages-1][i * R]

    # comb
    comb_stage_output = np.zeros((num_stages, N // R))
    for i in range(0, num_stages):
            if i == 0:
                comb_stage_output[i] = comb(decimator_stage_output, N // R, M)
            else:
                comb_stage_output[i] = comb(comb_stage_output[i-1], N // R, M)

    return comb_stage_output[num_stages-1]

def main(args):
    fs = 125e6

    num_stages = 3
    decimation_factor = 625
    differential_delay = 1

    N_out = 4096
    N_guard = 64 # we will get rid of extra output samples caused by this to remove transient noise
    N_in = (N_out + N_guard) * decimation_factor
    
    if "--droop" in args:
        # bin sweep
        max_error = 0
        droop_dB = np.zeros(512)
        for i in range(1, 512+1):
            # print(f"Iteration: {i}")
            f_bin = i * fs / (N_out * decimation_factor)
            signal = signal_source.sine(fs, N_in, 1, frequency=f_bin)
            y = CIC(signal, N_in, decimation_factor, differential_delay, num_stages)
            y = y[N_guard:]
            fft_output = (2 / N_out) * np.abs(np.fft.fft(y))
        
            # make sure the amplitude is what we expect within reason
            assert np.isclose(fft_output[i], (decimation_factor * differential_delay) ** num_stages, rtol=1e-1), f"Actual: {fft_output[i]}, Expected: {(decimation_factor * differential_delay) ** num_stages}"

            # calculate error in amplitude
            actual_amplitude = fft_output[i]
            expected_amplitude = np.abs(np.sin(np.pi * decimation_factor * differential_delay * f_bin / fs) / np.sin(np.pi * f_bin / fs)) ** num_stages
            error = (actual_amplitude - expected_amplitude) / expected_amplitude
            max_error = max(max_error, abs(error))

            droop_dB[i - 1] = 20 * np.log10(actual_amplitude / ((decimation_factor * differential_delay) ** num_stages))

        # report max error
        print(f"Max Error: {max_error}")
        print(f"Min Droop: {min(droop_dB)}")

        # plot droop
        # plt.plot(range(1, 513), droop_dB)
        # plt.show()

    if "--null" in args:
        # Now we will check for null values in correct places
        # nulls occur for all f where f = k * fs / (R * M)
        max_k = 50
        min_threshold = 1e-4
        for i in range(1, max_k+1):
            f_bin = i * fs / (differential_delay * decimation_factor)
            signal = signal_source.sine(fs, N_in, 1, frequency=f_bin)
            y = CIC(signal, N_in, decimation_factor, differential_delay, num_stages)
            y = y[N_guard:]
            fft_output = (2 / N_out) * np.abs(np.fft.fft(y))
            assert fft_output[0] / ((decimation_factor * differential_delay) **num_stages) < min_threshold, f"Amplitude: {fft_output[0] / ((decimation_factor * differential_delay) **num_stages)} > {min_threshold}"

        # now we will sweep values between the first and second
        first_null = 1 * fs / (differential_delay * decimation_factor)
        second_null = 2 * fs / (differential_delay * decimation_factor)
        bin_spacing = fs / (N_out * decimation_factor)
        f_range = np.arange(first_null, second_null, bin_spacing)
        
        print(f"Expected sweep iterations: {len(f_range)}")

        sweep_db = np.zeros(len(f_range))
        for i, f in enumerate(f_range):
            print(f"Sweep Iteration: {i}")
            signal = signal_source.sine(fs, N_in, 1, frequency=f)
            y = CIC(signal, N_in, decimation_factor, differential_delay, num_stages)
            y = y[N_guard:]
            fft_output = (2 / N_out) * np.abs(np.fft.fft(y))
            max_amplitude = np.max(np.concatenate((fft_output[1:N_out//2], fft_output[1+N_out//2:])))
            #max_bin = np.argmax(np.concatenate((fft_output[1:N_out//2], fft_output[1+N_out//2:])))
            sweep_db[i] = 20 * np.log10(max_amplitude / ((decimation_factor * differential_delay) ** num_stages))

            print(f"Logging maximums: Max Amplitude: {max_amplitude}")
            
        print(f"Max Droop between first two Nulls: {max(sweep_db)}")

        


    return

if __name__ == '__main__':
    main(sys.argv)
