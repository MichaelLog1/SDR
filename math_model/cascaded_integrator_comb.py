import numpy as np
import signal_source

def integrator(x, N):
    y = np.zeros(N)
    y[0] = x[0]
    for n in range(1, N):    
        y[n] = y[n-1] + x[n]

    return y

def comb(x, N, M):
    y = np.zeros(N)
    for i in range(0, M):
        y[i] = x[i]

    for i in range(M, N):
        y[i] = x[i] - x[i-M]

    return y

def CIC(signal, N, R, M, num_stages):

    # integrate
    integrator_stage_output = np.zeros((num_stages, N))
    for i in range(0, num_stages):
        if i == 0:
            integrator_stage_output[i] = integrator(signal, N)
        else:
            integrator_stage_output[i] = integrator(integrator_stage_output[i-1], N)

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

    return

if __name__ == '__main__':
    main()
