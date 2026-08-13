module NCO_tb #(
    parameter int unsigned PHASE_WIDTH = 32,
    parameter int unsigned OUTPUT_WIDTH = 16,
    parameter int unsigned P = 15,
    parameter int unsigned fs = 125000000,
    parameter int N = 1000,
    parameter int M = 1234
);

    logic clk = 1'b0;
    logic rst;
    logic [PHASE_WIDTH-1:0] phase_inc;
    logic [OUTPUT_WIDTH-1:0] sine;
    logic [OUTPUT_WIDTH-1:0] cosine;

    logic [31:0] expected [0:N-1];
    int errors = 0;

    NCO #(
        .PHASE_WIDTH(PHASE_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .P(P)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .phase_inc(phase_inc),
        .sine(sine),
        .cosine(cosine)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin
        $readmemh("nco_expected.hex", expected);
    end

    initial begin
        $timeformat(-9, 0, " ns");

        rst <= 1'b1;
        phase_inc <= '0;
        repeat (5) @(posedge clk);

        phase_inc <= M;
        @(negedge clk);
        rst <= 1'b0;
        @(posedge clk);

        for (int i = 0; i < N; i++) begin
            @(posedge clk);
            if ({sine, cosine} !== expected[i]) begin
                $error("Sample %0d: got %08x expected %08x", i, {sine, cosine}, expected[i]);
                errors++;
            end
        end

        if (errors == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL: %0d errors", errors);
        end
    end

endmodule