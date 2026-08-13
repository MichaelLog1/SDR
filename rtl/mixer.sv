module mixer #(
    parameter int unsigned ADC_WIDTH = 14,
    parameter int unsigned NCO_WIDTH = 16,
    parameter int unsigned OUTPUT_WIDTH = 16
) (
    input  logic                           clk,
    input  logic                           rst,
    input  logic signed [ADC_WIDTH-1:0]    adc,
    input  logic signed [NCO_WIDTH-1:0]    sine,
    input  logic signed [NCO_WIDTH-1:0]    cosine,
    output logic        [OUTPUT_WIDTH-1:0] I,
    output logic        [OUTPUT_WIDTH-1:0] Q
);

    localparam PIPELINE_DEPTH = 3;

    logic signed [NCO_WIDTH*2-1:0] I_product_r;
    logic signed [NCO_WIDTH*2-1:0] Q_product_r;
    logic signed [16:0] I_round_r;
    logic signed [16:0] Q_round_r;
    logic signed [OUTPUT_WIDTH-1:0] I_saturate_r;
    logic signed [OUTPUT_WIDTH-1:0] Q_saturate_r;

    always_ff @(posedge clk) begin
        if (rst) begin
            I_product_r <= '0;
            Q_product_r <= '0;
            I_round_r <= '0;
            Q_round_r <= '0;
            I_saturate_r <= '0;
            Q_saturate_r <= '0;
        end else begin
            // product stage
            I_product_r <= cosine * adc;
            Q_product_r <= sine * adc * -1;
            // round stage
            I_round_r <= (I_product_r + 13'd4096) >>> 13;
            Q_round_r <= (Q_product_r + 13'd4096) >>> 13;
            // saturation stage
            if      (I_round_r > 17'sd32767)  I_saturate_r <= 16'sd32767;
            else if (I_round_r < -17'sd32768) I_saturate_r <= -16'sd32768;
            else                              I_saturate_r <= I_round_r[15:0];

            if      (Q_round_r > 17'sd32767)  Q_saturate_r <= 16'sd32767;
            else if (Q_round_r < -17'sd32768) Q_saturate_r <= -16'sd32768;
            else                              Q_saturate_r <= Q_round_r[15:0];
        end
    end

    assign I = I_saturate_r;
    assign Q = Q_saturate_r;

endmodule