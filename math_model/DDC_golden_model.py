from signal_source import sine
from NCO_golden_model import NCO
from mixer_golden_model import mixer
from CIC_golden_model import CIC
from FIR_golden_model import FIR
import matplotlib.pyplot as plt
import numpy as np


def DDC():
    fs      = 125e6
    R       = 2500
    fs_out  = fs / R
    N_out   = 2**11
    bin_out = 400
    
    f_lo_target = 10e6
    phase_inc = round(f_lo_target / fs * 2**32)
    f_lo_actual = phase_inc / 2**32 * fs
    f_bb = bin_out * fs_out / N_out
    f_rf = f_lo_actual + f_bb

    guard = 256
    N_in = (N_out + guard + 8) * R

    # input values
    adc = sine(fs, N_in, 0.9, frequency=f_rf)

    # write stimulus
    with open("adc_stimulus.hex", "w") as fh:
        for x in adc:
            fh.write(f"{int(x) & 0x3FFF:04x}\n")

    print("Beginning NCO...")
    sin, cos = NCO(phase_inc, N_in, write_artifacts=False)
    print("Beginning mixer...")
    I, Q = mixer(adc, sin, cos, write_artifacts=False)
    print("Beginning CIC...")
    I, Q = CIC(I, Q, write_artifacts=False)
    print("Beginning FIT...")
    I, Q = FIR(I, Q, write_artifacts=False)
    print("Finished.")

    # write expected (TODO)

    # fft analysis
    I = np.array(I[guard:guard+N_out])
    Q = np.array(Q[guard:guard+N_out])

    complex_signal = I + 1j*Q
    fft_output = np.fft.fft(complex_signal)

    plt.plot(20*np.log10(np.abs(fft_output)))
    plt.show()




if __name__ == "__main__":
    DDC()