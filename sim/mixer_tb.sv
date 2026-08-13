module mixer_tb #(
    parameter int unsigned ADC_WIDTH = 14,
    parameter int unsigned NCO_WIDTH = 16,
    parameter int unsigned OUTPUT_WIDTH = 16,
    parameter int unsigned N = 1000 // in sync with golden model script
);

    logic clk = 1'b0;
    logic rst;

    logic [ADC_WIDTH-1:0] adc;
    logic [NCO_WIDTH-1:0] sine;
    logic [NCO_WIDTH-1:0] cosine;
    logic [OUTPUT_WIDTH-1:0] I;
    logic [OUTPUT_WIDTH-1:0] Q;

    logic [45:0] stimulus [0:N-1];
    logic [31:0] model [0:N-1];

    int errors = 0;

    mailbox #(logic [31:0]) driver_mailbox = new();

    mixer #(
        .ADC_WIDTH(ADC_WIDTH),
        .NCO_WIDTH(NCO_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .adc(adc),
        .sine(sine),
        .cosine(cosine),
        .I(I),
        .Q(Q)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin
        $readmemh("mixer_stimulus.hex", stimulus);
        $readmemh("mixer_expected.hex", model)
    end

    initial begin : driver

        rst <= 1'b1;
        repeat (5) @(posedge clk);

        @(negedge clk);
        rst <= 1'b0;

        for (int i = 0; i < N; i++) begin
            @(posedge clk);
            adc <= stimulus[i][45:32];
            sine <= stimulus[i][31:16];
            cosine <= stimulus[i][15:0];
            driver_mailbox.put(model[i])
        end
    end

    initial begin : scoreboard
        logic [31:0] expected;
        @(negedge rst);
        repeat (PIPELINE_DEPTH) @(posedge clk);

        for (int i = 0; i < N; i++) begin
            @(posedge clk);
            driver_mailbox.get(expected);
            if ({I, Q} !== exp) errors++;
        end

        if (errors == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL: %0d errors", errors);
        end

        disable generate_clock;
    end

endmodule