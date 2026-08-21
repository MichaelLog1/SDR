from signal_source import sine
from NCO_golden_model import NCO
from mixer_golden_model import mixer
from CIC_golden_model import CIC
from FIR_golden_model import FIR
import matplotlib.pyplot as plt
import numpy as np

GUARD = 256
FS      = 122.88e6
R       = 2500
FS_OUT  = FS / R
N_OUT   = 2**11
BIN_OUT = 400
N_IN = (N_OUT + GUARD + 8) * R

def DDC(write_artifacts=True):
    
    
    f_lo_target = 10e6
    phase_inc = round(f_lo_target / FS * 2**32)
    f_lo_actual = phase_inc / 2**32 * FS
    f_bb = BIN_OUT * FS_OUT / N_OUT
    f_rf = f_lo_actual + f_bb

    

    # input values
    adc = sine(FS, N_IN, 0.9, frequency=f_rf)

    # write stimulus
    with open("adc_stimulus.hex", "w") as fh:
        for x in adc:
            fh.write(f"{int(x) & 0xFFFF:04x}\n")

    print("Beginning NCO...")
    sin, cos = NCO(phase_inc, N_IN, write_artifacts=False)
    print("Beginning mixer...")
    I, Q = mixer(adc, sin, cos, write_artifacts=False)
    print("Beginning CIC...")
    I, Q = CIC(I, Q, write_artifacts=False)
    print("Beginning FIT...")
    I, Q = FIR(I, Q, write_artifacts=False)
    print("Finished.")

    # write expected
    if (write_artifacts):
        with open("ddc_expected.hex", "w") as fh:
            for i, q in zip(I, Q):
                word = ((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    # fft analysis
    I = np.array(I[GUARD:GUARD+N_OUT])
    Q = np.array(Q[GUARD:GUARD+N_OUT])

    complex_signal = I + 1j*Q
    fft_output = np.fft.fft(complex_signal)

    plt.plot(20*np.log10(np.abs(fft_output)))
    plt.show()




if __name__ == "__main__":
    DDC()