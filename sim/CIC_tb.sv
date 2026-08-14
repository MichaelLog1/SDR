module CIC_tb #(
    parameter int unsigned STAGES = 6,
    parameter int unsigned DECIMATION_FACTOR = 625,
    parameter int unsigned N = 100000
);

    logic clk = 1'b0;
    logic rst;

    logic [15:0] I_in;
    logic [15:0] Q_in;
    logic [71:0] I_out;
    logic [71:0] Q_out;
    logic valid_out;

    logic [31:0] stimulus [0:N-1];
    logic [143:0] model [0:N-1];

    int errors = 0;

    CIC #(
        .STAGES(STAGES),
        .DECIMATION_FACTOR(DECIMATION_FACTOR)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .I_in(I_in),
        .Q_in(Q_in),
        .I_out(I_out),
        .Q_out(Q_out),
        .valid_out(valid_out)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin
        $readmemh("cic_stimulus.hex", stimulus);
        $readmemh("cic_expected.hex", model);
    end

    initial begin : driver

        I_in <= '0;
        Q_in <= '0;
        rst <= 1'b1;
        repeat (5) @(posedge clk);

        @(negedge clk);
        rst <= 1'b0;

        for (int i = 0; i < N; i++) begin
            I_in <= stimulus[i][31:16];
            Q_in <= stimulus[i][15:0];
            @(posedge clk);
        end
    end

    initial begin : scoreboard
        @(negedge rst);

        for (int i = 0; i < ((N / DECIMATION_FACTOR)-STAGES); i++) begin
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