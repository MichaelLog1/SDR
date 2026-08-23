module CIC#(
    parameter int unsigned STAGES = 6,
    parameter int unsigned DECIMATION_FACTOR = 625
) (
    input  logic               clk,
    input  logic               rst,
    input  logic               en,
    input  logic signed [15:0] I_in,
    input  logic signed [15:0] Q_in,
    output logic signed [15:0] I_out,
    output logic signed [15:0] Q_out,
    output logic               valid_out,
    output logic               clip_pulse
);
    // integrator stage
    logic signed [71:0] integrator_I_r [STAGES];
    logic signed [71:0] integrator_Q_r [STAGES];

    // comb stage
    logic signed [71:0] comb_I_r       [STAGES];
    logic signed [71:0] comb_delay_I_r [STAGES];
    logic signed [71:0] comb_Q_r       [STAGES];
    logic signed [71:0] comb_delay_Q_r [STAGES];
    logic signed [15:0] round_I_out;
    logic signed [15:0] round_Q_out;
    logic signed [71:0] round_I;
    logic signed [71:0] round_Q;

    // decimation logic
    logic [$clog2(DECIMATION_FACTOR)-1:0] decimation_count_r;
    logic decimation_en;

    // valid delay
    logic valid_out_r;
    logic valid_out_scaled_r;
    logic [$clog2(STAGES+1)-1:0] fill_r;
    logic filled;
    logic clip_pulse_r;

    always_ff @(posedge clk) begin
        if (rst) begin
            foreach (integrator_I_r[i]) integrator_I_r[i] <= '0;
            foreach (integrator_Q_r[i]) integrator_Q_r[i] <= '0;
            foreach (comb_I_r[i])       comb_I_r[i]       <= '0;
            foreach (comb_Q_r[i])       comb_Q_r[i]       <= '0;
            foreach (comb_delay_I_r[i]) comb_delay_I_r[i] <= '0;
            foreach (comb_delay_Q_r[i]) comb_delay_Q_r[i] <= '0;
        end else if (en) begin
            integrator_I_r[0] <= integrator_I_r[0] + I_in;
            for (int i = 1; i < STAGES; i++) begin
                integrator_I_r[i] <= integrator_I_r[i] + integrator_I_r[i-1];
            end

            integrator_Q_r[0] <= integrator_Q_r[0] + Q_in;
            for (int i = 1; i < STAGES; i++) begin
                integrator_Q_r[i] <= integrator_Q_r[i] + integrator_Q_r[i-1];
            end

            if (decimation_en) begin
                comb_I_r[0]       <= integrator_I_r[STAGES-1] - comb_delay_I_r[0];
                comb_delay_I_r[0] <= integrator_I_r[STAGES-1];
                for (int i = 1; i < STAGES; i++) begin
                    comb_I_r[i]       <= comb_I_r[i-1] - comb_delay_I_r[i];
                    comb_delay_I_r[i] <= comb_I_r[i-1];
                end

                comb_Q_r[0]       <= integrator_Q_r[STAGES-1] - comb_delay_Q_r[0];
                comb_delay_Q_r[0] <= integrator_Q_r[STAGES-1];
                for (int i = 1; i < STAGES; i++) begin
                    comb_Q_r[i]       <= comb_Q_r[i-1] - comb_delay_Q_r[i];
                    comb_delay_Q_r[i] <= comb_Q_r[i-1];
                end
            end
        end
    end

    // extra cycle for rounding and saturation
    always_ff @(posedge clk) begin
        if (rst) begin
            valid_out_scaled_r <= '0;
            round_I_out <= '0;
            round_Q_out <= '0;
            clip_pulse_r <= 1'b0;
        end else if (en) begin
            valid_out_scaled_r <= valid_out_r;
            clip_pulse_r <= 1'b0;

            round_I = (comb_I_r[STAGES-1] + (72'sd1 << 54)) >>> 55;
            if (round_I > 72'sd32767) begin
                round_I_out <= 16'sd32767;
                clip_pulse_r <= 1'b1;
            end else if (round_I < -72'sd32768) begin
                round_I_out <= -16'sd32768;
                clip_pulse_r <= 1'b1;
            end else begin
                round_I_out <= round_I[15:0];
            end

            round_Q = (comb_Q_r[STAGES-1] + (72'sd1 << 54)) >>> 55;
            if (round_Q > 72'sd32767) begin
                round_Q_out <= 16'sd32767;
                clip_pulse_r <= 1'b1;
            end else if (round_Q < -72'sd32768) begin
                round_Q_out <= -16'sd32768;
                clip_pulse_r <= 1'b1;
            end else begin
                round_Q_out <= round_Q[15:0];
            end
        end
    end

    assign I_out = round_I_out;
    assign Q_out = round_Q_out;
    assign valid_out = valid_out_scaled_r & en;
    assign clip_pulse = clip_pulse_r;

    // decimation counter
    always_ff @(posedge clk) begin
        if (rst) begin
            decimation_count_r <= '0;
        end else if (en) begin
            if (decimation_count_r == DECIMATION_FACTOR-1) begin
                decimation_count_r <= '0;
            end else begin
                decimation_count_r <= decimation_count_r + 1;
            end
        end
    end

    assign decimation_en = decimation_count_r == DECIMATION_FACTOR-1;

    // valid logic
    always_ff @(posedge clk) begin
        if (rst) begin
            fill_r <= '0;
            valid_out_r <= '0;
        end else if (en) begin
            valid_out_r <= 1'b0;

            if (decimation_en) begin
                if (!filled) fill_r <= fill_r + 1;
                else valid_out_r <= 1'b1;
            end
        end
    end

    assign filled = (fill_r == STAGES);
    
endmodule