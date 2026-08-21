module top #(
    parameter int unsigned NCO_PHASE_WIDTH = 32,
    parameter int unsigned NCO_OUTPUT_WIDTH = 16,
    parameter int unsigned NCO_P = 15,
    parameter int unsigned MIXER_ADC_WIDTH = 16,
    parameter int unsigned MIXER_OUTPUT_WIDTH = 16,
    parameter int unsigned CIC_STAGES = 6,
    parameter int unsigned CIC_DECIMATION_FACTOR = 625,
    parameter int unsigned FIR_TAPS = 282,
    parameter int unsigned FIR_TAP_WIDTH = 16,
    parameter int unsigned N = (2048 + 256 + 8) * 2500
) (
    input logic s_axi_aclk,
    input logic s_axi_aresetn,
    input logic adc_clk,
    input logic adc_rst,

    // AXI slave
    input  logic [31:0] s_axi_awaddr,
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    input  logic [31:0] s_axi_wdata,
    input  logic [3:0]  s_axi_wstrb,
    input  logic        s_axi_wvalid,
    output logic        s_axi_wready,
    output logic [1:0]  s_axi_bresp,
    output logic        s_axi_bvalid,
    input  logic        s_axi_bready,
    input  logic [31:0] s_axi_araddr,
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    output logic [31:0] s_axi_rdata,
    output logic [1:0]  s_axi_rresp,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready,

    input logic [MIXER_ADC_WIDTH-1:0] adc,

    output logic [31:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic m_axis_tlast
);

    logic phase_inc_sync;
    logic [31:0] phase_inc;
    logic [15:0] I_out;
    logic [15:0] Q_out;
    logic DDC_valid_out;
    logic streaming_s;
    logic sat_s;

    // handshake
    typedef enum logic [1:0] {
        SRC_READY,
        SRC_WAIT_FOR_ACK,
        SRC_RESET_ACK
    } state_src_t;
    state_src_t state_src_r;

    typedef enum logic [1:0] {
        DEST_READY,
        DEST_SEND_ACK,
        DEST_RESET_ACK
    } state_dest_t;
    state_dest_t state_dest_r;

    logic [1:0] send_src_in_dst_r;
    logic [1:0] ack_dest_in_src_r;
    logic send_src_r;
    logic ack;
    logic ack_dest_r;
    logic rcv;

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
    ) DUT_DDC (
        .clk(adc_clk),
        .rst(adc_rst),
        .adc(adc),
        .phase_inc(phase_inc),
        .phase_valid(rcv),
        .I_out(I_out),
        .Q_out(Q_out),
        .valid_out(DDC_valid_out),
        .streaming_s(streaming_s),
        .sat_s(sat_s)
    );

    AXI_slave DUT_AXI (
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .awaddr(s_axi_awaddr),
        .awvalid(s_axi_awvalid),
        .wdata(s_axi_wdata),
        .wstrb(s_axi_wstrb),
        .wvalid(s_axi_wvalid),
        .bready(s_axi_bready),
        .araddr(s_axi_araddr),
        .arvalid(s_axi_arvalid),
        .rready(s_axi_rready),
        .awready(s_axi_awready),
        .wready(s_axi_wready),
        .bresp(s_axi_bresp),
        .bvalid(s_axi_bvalid),
        .rdata(s_axi_rdata),
        .arready(s_axi_arready),
        .rresp(s_axi_rresp),
        .rvalid(s_axi_rvalid),
        .phase_inc(phase_inc),
        .phase_inc_sync(phase_inc_sync),
        .enable(),
        .soft_reset(),
        .streaming_s(streaming_s),
        .sat_s(sat_s)
    );

    AXI_adapter DUT_ADAPTER (
        .clk(adc_clk),
        .rst(adc_rst),
        .I_in(I_out),
        .Q_in(Q_out),
        .valid_in(DDC_valid_out),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast),
        .overflow_sticky()
    );

    // src
    always_ff @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            state_src_r <= SRC_READY;
            send_src_r <= '0;
            ack <= 1'b0;
        end else begin
            // dual flop
            ack_dest_in_src_r[1] <= ack_dest_r;
            ack_dest_in_src_r[0] <= ack_dest_in_src_r[1];

            ack <= 1'b0;

            case (state_src_r)
                SRC_READY: begin
                    if (phase_inc_sync) begin
                        send_src_r <= 1'b1;
                        state_src_r <= SRC_WAIT_FOR_ACK;
                    end
                end

                SRC_WAIT_FOR_ACK: begin
                    if (ack_dest_in_src_r[0]) begin
                        send_src_r <= 1'b0;
                        state_src_r <= SRC_RESET_ACK;
                    end
                end

                SRC_RESET_ACK: begin
                    if (!ack_dest_in_src_r[0]) begin
                        ack <= 1'b1;
                        state_src_r <= SRC_READY;
                    end
                end
            endcase
        end
    end

    // dest
    always_ff @(posedge adc_clk) begin
        if (adc_rst) begin
            state_dest_r <= DEST_READY;
            ack_dest_r <= 1'b0;
            rcv <= 1'b0;
        end else begin
            send_src_in_dst_r[1] <= send_src_r;
            send_src_in_dst_r[0] <= send_src_in_dst_r[1];

            rcv <= 1'b0;

            case (state_dest_r)
                DEST_READY: begin
                    if (send_src_in_dst_r[0]) begin
                        rcv <= 1'b1;
                        state_dest_r <= DEST_SEND_ACK;
                    end
                end

                DEST_SEND_ACK: begin
                    ack_dest_r <= 1'b1;
                    state_dest_r <= DEST_RESET_ACK;
                end

                DEST_RESET_ACK: begin
                    if (!send_src_in_dst_r[0]) begin
                        ack_dest_r <= 1'b0;
                        state_dest_r <= DEST_READY;
                    end
                end
            endcase
        end
    end
    
endmodule