module FIR #(
    parameter int unsigned TAPS = 282,
    parameter int unsigned TAP_WIDTH = 16
) (
    input logic clk,
    input logic rst,
    input logic en,
    input logic [15:0] I_in,
    input logic [15:0] Q_in,
    input logic valid_in,
    output logic [15:0] I_out,
    output logic [15:0] Q_out,
    output logic valid_out,
    output logic clip_pulse
);

    typedef enum logic [1:0] {
        IDLE,
        MAC,
        DRAIN,
        EMIT
    } state_t;

    state_t state_r;

    logic [15:0] ram_I [TAPS];
    logic [15:0] ram_Q [TAPS];
    logic [TAP_WIDTH-1:0] coefficients [TAPS];

    logic [$clog2(TAPS)-1:0] write_ptr_r;
    logic [$clog2(TAPS)-1:0] read_ptr_r;
    logic [$clog2(TAPS)-1:0] tap_counter_r;

    logic [1:0] trigger_count_r;
    logic signed [40:0] accumulator_I_r;
    logic signed [40:0] accumulator_Q_r;
    logic signed [40:0] round_I;
    logic signed [40:0] round_Q;

    logic signed [15:0] sample_I_r;
    logic signed [15:0] sample_Q_r;
    logic signed [15:0] tap_r;

    logic accumulate_en_r;
    logic issuing_r;
    logic first_r;
    logic start_mac_r;

    logic signed [15:0] I_out_r;
    logic signed [15:0] Q_out_r;
    logic valid_out_r;
    logic clip_pulse_r;
 
    initial begin
        $readmemh("fir_taps.mem", coefficients);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state_r <= IDLE;
            read_ptr_r <= '0;
            tap_counter_r <= '0;
            valid_out_r <= '0;
            issuing_r <= '0;
            clip_pulse_r <= 1'b0;
        end else if (en) begin
            first_r <= 1'b0;
            valid_out_r <= 1'b0;
            clip_pulse_r <= 1'b0;
            case (state_r)
                IDLE: begin
                    state_r <= IDLE;
                    if (start_mac_r) begin
                        state_r <= MAC;
                        tap_counter_r <= '0;
                        issuing_r <= 1'b1;
                        if (write_ptr_r == 0) begin
                            read_ptr_r <= TAPS - 1;
                        end else begin
                            read_ptr_r <= write_ptr_r - 1;
                        end
                    end
                end

                MAC: begin
                    state_r <= MAC;
                    tap_counter_r <= tap_counter_r + 1;

                    if (tap_counter_r == 0) begin
                        first_r <= 1'b1;
                    end

                    if (read_ptr_r == 0) begin
                        read_ptr_r <= TAPS - 1;
                    end else begin
                        read_ptr_r <= read_ptr_r - 1;
                    end

                    if (tap_counter_r == TAPS - 1) begin
                        state_r <= DRAIN;
                        issuing_r <= 1'b0;
                    end
                end

                DRAIN: begin
                    state_r <= DRAIN;
                    if (accumulate_en_r == 1'b0) begin
                        state_r <= EMIT;
                    end
                end

                EMIT: begin
                    state_r <= IDLE;
                    valid_out_r <= 1'b1;

                    round_I = (accumulator_I_r + 41'sd16384) >>> 15;
                    if (round_I > 41'sd32767) begin
                        I_out_r <= 16'sd32767;
                        clip_pulse_r <= 1'b1;
                    end else if (round_I < -41'sd32768) begin
                        I_out_r <= -16'sd32768;
                        clip_pulse_r <= 1'b1;
                    end else begin
                        I_out_r <= round_I[15:0];
                    end

                    round_Q = (accumulator_Q_r + 41'sd16384) >>> 15;
                    if (round_Q > 41'sd32767) begin
                        Q_out_r <= 16'sd32767;
                        clip_pulse_r <= 1'b1;
                    end else if (round_Q < -41'sd32768) begin
                        Q_out_r <= -16'sd32768;
                        clip_pulse_r <= 1'b1;
                    end else begin
                        Q_out_r <= round_Q[15:0];
                    end
                end
            endcase
        end
    end

    assign I_out = I_out_r;
    assign Q_out = Q_out_r;
    assign valid_out = valid_out_r  & en;
    assign clip_pulse = clip_pulse_r;

    // MAC datapath
    always_ff @(posedge clk) begin
        if (rst) begin
            sample_I_r <= '0;
            sample_Q_r <= '0;
            tap_r <= '0;
            accumulate_en_r <= '0;
            accumulator_I_r <= '0;
            accumulator_Q_r <= '0;
        end else if (en) begin
            // accumulate pipeline
            sample_I_r <= ram_I[read_ptr_r];
            sample_Q_r <= ram_Q[read_ptr_r];
            tap_r <= coefficients[tap_counter_r];
            accumulate_en_r <= issuing_r;
            if (accumulate_en_r) begin
                if (first_r) begin
                    accumulator_I_r <= $signed(sample_I_r) * $signed(tap_r);
                    accumulator_Q_r <= $signed(sample_Q_r) * $signed(tap_r);
                end else begin
                    accumulator_I_r <= accumulator_I_r + $signed(sample_I_r) * $signed(tap_r);
                    accumulator_Q_r <= accumulator_Q_r + $signed(sample_Q_r) * $signed(tap_r);
                end
            end
        end
    end

    // write to ram every cycle
    always_ff @(posedge clk) begin
        if (rst) begin
            write_ptr_r <= '0;
            trigger_count_r <= '0;
            start_mac_r <= '0;
        end else if (en) begin
            start_mac_r <= 1'b0;
            if (valid_in) begin
                trigger_count_r <= trigger_count_r + 1;
                if (trigger_count_r == 3) begin
                    start_mac_r <= 1'b1;
                end

                ram_I[write_ptr_r] <= I_in;
                ram_Q[write_ptr_r] <= Q_in;
                if (write_ptr_r == TAPS-1) begin
                    write_ptr_r <= '0;
                end else begin
                    write_ptr_r <= write_ptr_r + 1;
                end
            end
        end
    end
endmodule