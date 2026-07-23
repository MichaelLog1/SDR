import numpy as np
import signal_source
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

def main():
    fs = 125e6

    num_stages = 3
    decimation_factor = 625
    differential_delay = 1

    N_out = 4096
    N_guard = 64 # we will get rid of extra output samples caused by this to remove transient noise
    N_in = (N_out + N_guard) * decimation_factor
    signal_bin = 3
    # to get an exact bin placement, we need to tie the frequency to the output (analysis window) rather than the input
    f_bin = signal_bin * fs / (N_out * decimation_factor)

    signal = signal_source.sine(fs, N_in, 1, frequency=f_bin)

    y = CIC(signal, N_in, decimation_factor, differential_delay, num_stages)

    y = y[N_guard:] # get rid of transient samples
    print(len(y))

    fft_output = (2 / N_out) * np.abs(np.fft.fft(y))
    # now validate the signal
    # test gain = (R*M)^N
    print(f"Actual bin: {fft_output[signal_bin]}, Expected bin: {(decimation_factor * differential_delay) ** num_stages}")
    assert(np.isclose(fft_output[signal_bin], (decimation_factor * differential_delay) ** num_stages, rtol=1000000))

    # bin sweep
    min_error = sys.maxsize * 2 + 1
    for i in range(1, 512+1):
        print(f"Iteration: {i}")
        f_bin = i * fs / (N_out * decimation_factor)
        signal = signal_source.sine(fs, N_in, 1, frequency=f_bin)
        y = CIC(signal, N_in, decimation_factor, differential_delay, num_stages)
        y = y[N_guard:]
        fft_output = (2 / N_out) * np.abs(np.fft.fft(y))

        bin_amplitude = fft_output[i]
        expected_amplitude = np.abs(np.sin(np.pi * decimation_factor * differential_delay * f_bin / fs) / np.sin(np.pi * f_bin / fs)) ** num_stages
        print(f"Actual bin: {bin_amplitude}, Expected bin: {expected_amplitude}")
        


    return

if __name__ == '__main__':
    main()
