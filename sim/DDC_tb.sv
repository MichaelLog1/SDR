module DDC_tb #(
    parameter int unsigned NCO_PHASE_WIDTH = 32,
    parameter int unsigned NCO_OUTPUT_WIDTH = 16,
    parameter int unsigned NCO_P = 15,
    parameter int unsigned MIXER_ADC_WIDTH = 14,
    parameter int unsigned MIXER_OUTPUT_WIDTH = 16,
    parameter int unsigned CIC_STAGES = 6,
    parameter int unsigned CIC_DECIMATION_FACTOR = 625,
    parameter int unsigned FIR_TAPS = 282,
    parameter int unsigned FIR_TAP_WIDTH = 16,
    parameter int unsigned N = (2048 + 256 + 8) * 2500
);

    localparam int M = 349525333;
    localparam OUTPUT_CAPTURE = 2048 + 256;

    logic clk = 1'b0;
    logic rst;
    logic en;
    logic [MIXER_ADC_WIDTH-1:0] adc;
    logic [NCO_PHASE_WIDTH-1:0] phase_inc;
    logic phase_valid;
    logic [15:0] I_out;
    logic [15:0] Q_out;
    logic valid_out;
    logic sat_s;

    logic [MIXER_ADC_WIDTH-1:0] stimulus [0:N-1];

    DDC #(
        .NCO_PHASE_WIDTH(NCO_PHASE_WIDTH),
        .NCO_OUTPUT_WIDTH(NCO_OUTPUT_WIDTH),
        .NCO_P(NCO_P),
        .MIXER_ADC_WIDTH(MIXER_ADC_WIDTH),
        .MIXER_OUTPUT_WIDTH(MIXER_OUTPUT_WIDTH),
        .CIC_STAGES(CIC_STAGES),
        .CIC_DECIMATION_FACTOR(CIC_DECIMATION_FACTOR),
        .FIR_TAPS(FIR_TAPS),
        .FIR_TAP_WIDTH(FIR_TAP_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .en(en),
        .adc(adc),
        .phase_inc(phase_inc),
        .phase_valid(phase_valid),
        .I_out(I_out),
        .Q_out(Q_out),
        .valid_out(valid_out),
        .sat_s(sat_s)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin
        $readmemh("adc_stimulus.hex", stimulus);
    end

    initial begin : driver
        adc <= '0;
        en <= 1'b0;
        phase_inc <= '0;
        rst <= 1'b1;
        repeat (5) @(posedge clk);

        @(negedge clk);
        rst <= 1'b0;
        phase_inc <= M;
        phase_valid <= 1'b1;
        en <= 1'b1;


        for (int i = 0; i < N; i++) begin
            adc <= stimulus[i];
            @(posedge clk);
        end
    end

    initial begin : scoreboard
        int fd = $fopen("ddc_output.hex", "w");
        @(negedge rst);

        for (int i = 0; i < OUTPUT_CAPTURE; i++) begin
            do @(posedge clk); while (!valid_out);
            $fdisplay(fd, "%08h", {I_out, Q_out});
        end

        $fclose(fd);
        $display("captured %0d samples", OUTPUT_CAPTURE);
        disable generate_clock;
    end
    
endmodule