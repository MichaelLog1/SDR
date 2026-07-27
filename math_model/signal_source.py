# functions to generate a sinusoid or inject noise/spurs into our signal

import numpy as np
from helpers import quantize

ADC_BITS = 32

def sine(fs, N, amplitude, frequency = None, bin = None):
    if frequency == None and bin == None:
        raise ValueError("Frequency or bin must be specified.")

    # if we specify a bin, place the frequency in that bin
    if bin != None:
        frequency = bin * fs/N

    return quantize(amplitude * np.sin(2 * np.pi * frequency * np.arange(0, N) / fs), ADC_BITS)

# need to somehow allow this to be quantized. broken right now
def noisy_sine(fs, N, amplitude, sigma, frequency = None, bin = None):
    return sine(fs, N, amplitude, frequency, bin) + np.random.normal(0, sigma, N)

def spurious_signal(fs, N, amplitude, amplitude_spur, frequency = None, bin = None, frequency_spur = None, bin_spur = None):
    return sine(fs, N, amplitude, frequency, bin) + sine(fs, N, amplitude_spur, frequency_spur, bin_spur)

def main():
    return

if __name__ == '__main__':
    main()

