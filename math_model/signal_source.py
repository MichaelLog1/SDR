# functions to generate a sinusoid or inject noise/spurs into our signal

import numpy as np
from helpers import quantize

ADC_BITS = 32

def raw_sine(fs, N, amplitude, frequency = None, bin = None):
    if frequency == None and bin == None:
        raise ValueError("Frequency or bin must be specified.")

    # if we specify a bin, place the frequency in that bin
    if bin != None:
        frequency = bin * fs/N

    return amplitude * np.sin(2 * np.pi * frequency * np.arange(0, N) / fs)

def sine(fs, N, amplitude, frequency = None, bin = None):
    return quantize(raw_sine(fs, N, amplitude, frequency, bin), ADC_BITS)

def noisy_sine(fs, N, amplitude, sigma, frequency = None, bin = None):
    return quantize(raw_sine(fs, N, amplitude, frequency, bin) + np.random.normal(0, sigma, N), ADC_BITS)

def spurious_signal(fs, N, amplitude, amplitude_spur, frequency = None, bin = None, frequency_spur = None, bin_spur = None):
    return quantize(raw_sine(fs, N, amplitude, frequency, bin) + raw_sine(fs, N, amplitude_spur, frequency_spur, bin_spur), ADC_BITS)

def main():
    return

if __name__ == '__main__':
    main()

