module DDC_tb #(
    parameter int unsigned NCO_PHASE_WIDTH = 32,
    parameter int unsigned NCO_OUTPUT_WIDTH = 16,
    parameter int unsigned NCO_P = 15,
    parameter int unsigned MIXER_ADC_WIDTH = 14,
    parameter int unsigned MIXER_OUTPUT_WIDTH = 16,
    parameter int unsigned CIC_STAGES = 6,
    parameter int unsigned CIC_DECIMATION_FACTOR = 625,
    parameter int unsigned FIR_TAPS = 282,
    parameter int unsigned FIR_TAP_WIDTH = 16
) (
    ports
);
    
endmodule