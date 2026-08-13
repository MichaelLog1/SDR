module NCO #(
    parameter int unsigned PHASE_WIDTH = 32,
    parameter int unsigned OUTPUT_WIDTH = 16,
    parameter int unsigned P = 15
) (
    input  logic        clk,
    input  logic        rst,
    input  logic [PHASE_WIDTH-1:0] phase_inc,
    output logic [OUTPUT_WIDTH-1:0] sine,
    output logic [OUTPUT_WIDTH-1:0] cosine
);

    logic [P-1:0] address;
    logic [PHASE_WIDTH-1:0] accumulator;

    logic [OUTPUT_WIDTH*2-1:0] ram [2**P];

    assign address = accumulator[PHASE_WIDTH-1:PHASE_WIDTH-P];

    // initialize ram
    initial begin
        $readmemh("../rtl/nco_lut_p15.hex", ram);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            accumulator <= '0;
        end else begin
            accumulator <= accumulator + phase_inc;
            {sine, cosine} <= ram[address];
        end
    end
endmodule