module FIR_tb #(
    parameter int unsigned TAPS = 282,
    parameter int unsigned TAP_WIDTH = 16,
    parameter int unsigned DECIMATION_FACTOR = 4,
    parameter int unsigned N = 4000
);

    logic clk = 1'b0;
    logic rst;

    logic [15:0] I_in;
    logic [15:0] Q_in;
    logic valid_in;
    logic [15:0] I_out;
    logic [15:0] Q_out;
    logic valid_out;

    logic [31:0] stimulus [0:N-1];
    logic [31:0] model [0:N-1];

    int errors = 0;

    FIR #(
        .TAPS(TAPS),
        .TAP_WIDTH(TAP_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .I_in(I_in),
        .Q_in(Q_in),
        .valid_in(valid_in),
        .I_out(I_out),
        .Q_out(Q_out),
        .valid_out(valid_out)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin
        $readmemh("fir_stimulus.hex", stimulus);
        $readmemh("fir_expected.hex", model);
    end

    initial begin : driver

        I_in <= '0;
        Q_in <= '0;
        valid_in <= '0;
        rst <= 1'b1;
        repeat (5) @(posedge clk);

        @(negedge clk);
        rst <= 1'b0;

        for (int i = 0; i < N; i++) begin
            I_in <= stimulus[i][31:16];
            Q_in <= stimulus[i][15:0];
            valid_in <= 1'b1;
            @(posedge clk);
            valid_in <= 1'b0;

            repeat (300 + ($urandom % 200)) @(posedge clk); // need to remain IDLE for at least the time it takes to MAC, plus some extra randomly
        end
    end

    initial begin : scoreboard
        @(negedge rst);

        for (int i = 0; i < (N / DECIMATION_FACTOR); i++) begin
            do @(posedge clk); while (!valid_out);
            if ({I_out, Q_out} !== model[i]) errors++;
        end

        if (errors == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL: %0d errors", errors);
        end

        disable generate_clock;
    end

endmodule