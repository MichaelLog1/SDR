module DDC #(
    parameter int unsigned NCO_PHASE_WIDTH = 32,
    parameter int unsigned NCO_OUTPUT_WIDTH = 16,
    parameter int unsigned NCO_P = 15,
    parameter int unsigned MIXER_ADC_WIDTH = 16,
    parameter int unsigned MIXER_OUTPUT_WIDTH = 16,
    parameter int unsigned CIC_STAGES = 6,
    parameter int unsigned CIC_DECIMATION_FACTOR = 625,
    parameter int unsigned FIR_TAPS = 282,
    parameter int unsigned FIR_TAP_WIDTH = 16
) (
    input  logic                       clk,
    input  logic                       rst,
    input  logic [MIXER_ADC_WIDTH-1:0] adc,
    input  logic [NCO_PHASE_WIDTH-1:0] phase_inc,
    input  logic                       phase_valid,
    output logic [15:0]                I_out,
    output logic [15:0]                Q_out,
    output logic                       valid_out,
    output logic                       streaming_s,
    output logic                       sat_s
);

    logic [NCO_OUTPUT_WIDTH-1:0] NCO_sine;
    logic [NCO_OUTPUT_WIDTH-1:0] NCO_cosine;
    logic [MIXER_OUTPUT_WIDTH-1:0] mixer_I_out;
    logic [MIXER_OUTPUT_WIDTH-1:0] mixer_Q_out;
    logic [15:0] CIC_I_out;
    logic [15:0] CIC_Q_out;
    logic CIC_valid_out;

    logic [NCO_PHASE_WIDTH-1:0] phase_inc_r;

    logic [1:0] debug_count;

    NCO #(
        .PHASE_WIDTH(NCO_PHASE_WIDTH),
        .OUTPUT_WIDTH(NCO_OUTPUT_WIDTH),
        .P(NCO_P)
    ) DUT_NCO (
        .clk(clk),
        .rst(rst),
        .phase_inc(phase_inc_r),
        .sine(NCO_sine),
        .cosine(NCO_cosine)
    );

    mixer #(
        .ADC_WIDTH(MIXER_ADC_WIDTH),
        .NCO_WIDTH(NCO_OUTPUT_WIDTH),
        .OUTPUT_WIDTH(MIXER_OUTPUT_WIDTH)
    ) DUT_MIXER (
        .clk(clk),
        .rst(rst),
        .adc(adc),
        .sine(NCO_sine),
        .cosine(NCO_cosine),
        .I(mixer_I_out),
        .Q(mixer_Q_out)
    );

    CIC #(
        .STAGES(CIC_STAGES),
        .DECIMATION_FACTOR(CIC_DECIMATION_FACTOR)
    ) DUT_CIC (
        .clk(clk),
        .rst(rst),
        .I_in(mixer_I_out),
        .Q_in(mixer_Q_out),
        .I_out(CIC_I_out),
        .Q_out(CIC_Q_out),
        .valid_out(CIC_valid_out)
    );

    FIR #(
        .TAPS(FIR_TAPS),
        .TAP_WIDTH(FIR_TAP_WIDTH)
    ) DUT_FIR (
        .clk(clk),
        .rst(rst),
        .I_in(CIC_I_out),
        .Q_in(CIC_Q_out),
        .valid_in(CIC_valid_out),
        .I_out(I_out),
        .Q_out(Q_out),
        .valid_out(valid_out)
    );

    // capture synchronized values;
    always_ff @(posedge clk) begin
        if (rst) begin
            phase_inc_r <= '0;
        end else begin
            if (phase_valid) phase_inc_r <= phase_inc;
        end
    end

    // DEBUG
    always_ff @(posedge clk) begin
        debug_count <= debug_count + 1;
    end
    
    assign {streaming_s, sat_s} = debug_count;

endmodule