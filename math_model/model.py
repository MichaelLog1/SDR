import numpy as np

# Red Pitaya ACD samples at 125 Msps
fs = 125e6
# Number of FFT bins
N = 2**16

# We will test with a frequency that exactly matches a bin
f = 3 * fs/N

x = []

for n in range(0, N):
    x[n] = np.sin(2 * np.pi * f * n / fs)

