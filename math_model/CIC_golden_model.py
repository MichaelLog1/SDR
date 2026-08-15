import numpy as np

# constants
STAGES = 6
DECIMATION_FACTOR = 625

def wrap(x, W=72):
    x &= (1 << W)-1      # keep low W bits
    if x & (1 << (W-1)): # if sign bit is asserted
        x -= (1 << W)
    return x

def saturate_16(v):
        return max(-32768, min(32767, v))

def CIC(I_in, Q_in, write_artifacts=True):
    integrator_I = [0]*STAGES
    integrator_Q = [0]*STAGES
    comb_I = [0]*STAGES
    comb_Q = [0]*STAGES
    comb_delay_I = [0]*STAGES
    comb_delay_Q = [0]*STAGES
    count = 0

    outputs_I = []
    outputs_Q = []

    # write stimulus
    if (write_artifacts):
        with open("cic_stimulus.hex", "w") as fh:
            for i, q in zip(I_in, Q_in):
                word = ((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    # replicating DUT datapath
    for n in range(len(I_in)):
        new_integrator_I = integrator_I[:]
        new_integrator_Q = integrator_Q[:]
        new_integrator_I[0] = wrap(integrator_I[0] + int(I_in[n]))
        new_integrator_Q[0] = wrap(integrator_Q[0] + int(Q_in[n]))
        for i in range(1, STAGES):
            new_integrator_I[i] = wrap(integrator_I[i] + integrator_I[i-1])
            new_integrator_Q[i] = wrap(integrator_Q[i] + integrator_Q[i-1])

        en = (count == DECIMATION_FACTOR-1)
        if en:
            din_I = integrator_I[STAGES-1]
            din_Q = integrator_Q[STAGES-1]
            new_comb_I = comb_I[:]
            new_comb_Q = comb_Q[:]
            new_comb_delay_I = comb_delay_I[:]
            new_comb_delay_Q = comb_delay_Q[:]
            new_comb_I[0] = wrap(din_I - comb_delay_I[0])
            new_comb_Q[0] = wrap(din_Q - comb_delay_Q[0])
            new_comb_delay_I[0] = din_I
            new_comb_delay_Q[0] = din_Q
            for i in range(1, STAGES):
                new_comb_I[i] = wrap(comb_I[i-1] - comb_delay_I[i])
                new_comb_Q[i] = wrap(comb_Q[i-1] - comb_delay_Q[i])
                new_comb_delay_I[i] = comb_I[i-1]
                new_comb_delay_Q[i] = comb_Q[i-1]

            comb_I, comb_delay_I = new_comb_I, new_comb_delay_I
            comb_Q, comb_delay_Q = new_comb_Q, new_comb_delay_Q
            outputs_I.append(saturate_16((comb_I[STAGES-1] + (1 << 54)) >> 55))
            outputs_Q.append(saturate_16((comb_Q[STAGES-1] + (1 << 54)) >> 55))
        
        integrator_I = new_integrator_I
        integrator_Q = new_integrator_Q
        count = (count+1) % DECIMATION_FACTOR

    outputs_I = outputs_I[STAGES:]
    outputs_Q = outputs_Q[STAGES:]

    # write outputs
    if (write_artifacts):
        with open("cic_expected.hex", "w") as fh:
            for i, q in zip(outputs_I, outputs_Q):
                word = ((int(i) & 0xFFFF) << 16) | (int(q) & 0xFFFF)
                fh.write(f"{word:08x}\n")

    return outputs_I, outputs_Q

if __name__ == "__main__":
    seed = 10
    rng = np.random.default_rng(seed)
    
    N = 100000

    # randomize inputs
    I_in = rng.integers(-32768, 32768, N, dtype=np.int16)
    Q_in = rng.integers(-32768, 32768, N, dtype=np.int16)

    CIC(I_in, Q_in)
