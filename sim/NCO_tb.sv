module NCO_tb #(
    parameter int unsigned PHASE_WIDTH = 32,
    parameter int unsigned OUTPUT_WIDTH = 16,
    parameter int unsigned P = 15,
    parameter int unsigned fs = 125000000,
    parameter int N = 1000,
    parameter int M = 343597384 // we generated golden model values for this M value specifically
);

    logic clk = 1'b0;
    logic rst;
    logic en;
    logic [PHASE_WIDTH-1:0] phase_inc;
    logic [OUTPUT_WIDTH-1:0] sine;
    logic [OUTPUT_WIDTH-1:0] cosine;
    logic [OUTPUT_WIDTH-1:0] stalled_sine;
    logic [OUTPUT_WIDTH-1:0] stalled_cosine;

    logic [31:0] expected [0:N-1];
    int errors = 0;

    NCO #(
        .PHASE_WIDTH(PHASE_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .P(P)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
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
        en <= 1'b0;
        rst <= 1'b1;
        phase_inc <= '0;
        repeat (5) @(posedge clk);

        phase_inc <= M;
        @(negedge clk);
        rst <= 1'b0;
        en <= 1'b1;
        @(posedge clk);

        for (int i = 0; i < N; i++) begin
            if (($urandom % 6) == 0) begin
                //stalled_sine = sine;
                //stalled_cosine = cosine;
                en <= 1'b0;
                repeat ($urandom_range(0, 8)) @(posedge clk);
                //if (sine !== stalled_sine || cosine !== stalled_cosine) errors++;
            end
            en <= 1'b1;
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

        disable generate_clock;
    end
endmodule