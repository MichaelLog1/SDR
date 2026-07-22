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
    N = 2**16
    signal_bin = 3456
    num_stages = 3
    decimation_factor = 625
    differential_delay = 1

    signal = signal_source.sine(fs, N, 1, bin=signal_bin)

    y = CIC(signal, N, decimation_factor, differential_delay, num_stages)

    return

if __name__ == '__main__':
    main()
