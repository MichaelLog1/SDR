module AXI_slave (
    input  logic s_axi_aclk,
    input  logic s_axi_aresetn,

    // write inputs
    input  logic [31:0] awaddr,
    input  logic        awvalid,
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        wvalid,
    input  logic        bready,

    // read inputs
    input  logic [31:0] araddr,
    input  logic        arvalid,
    input  logic        rready,

    // write outputs
    output logic       awready,
    output logic       wready,
    output logic [1:0] bresp,
    output logic       bvalid,

    // read outputs
    output logic [31:0] rdata,
    output logic        arready,
    output logic [1:0]  rresp,
    output logic        rvalid,

    // datapath signals
    output logic [31:0] phase_inc,
    output logic        phase_inc_sync,
    output logic        enable,
    output logic        soft_reset,

    // status info
    input logic sat_s,
    input logic overflow_s
);
    localparam ID_CONSTANT = 32'hDEADBEEF;

    typedef enum logic [1:0] {
        W_ACCEPT,
        W_WRITE,
        W_RESPONSE
    } write_state_t;
    write_state_t write_state_r;

    typedef enum logic {
        R_ACCEPT,
        R_RESPONSE
    } read_state_t;
    read_state_t read_state_r;

    // register outputs
    logic        awready_r;
    logic        wready_r;
    logic [1:0]  bresp_r;
    logic        bvalid_r;
    logic [31:0] rdata_r;
    logic        arready_r;
    logic [1:0]  rresp_r;
    logic        rvalid_r;
    logic [31:0] phase_inc_r;

    // control signals
    logic aw_done_r;
    logic w_done_r;
    logic aw_hit;
    logic w_hit;
    logic phase_inc_toggle_r;

    logic [31:0] awaddr_r;
    logic [31:0] wdata_r;
    logic [1:0] status_r;
    logic [1:0] control_r;

    // write
    always_ff @(posedge s_axi_aclk) begin
        if(!s_axi_aresetn) begin
            write_state_r <= W_ACCEPT;
            awready_r <= 1'b1;
            wready_r <= 1'b1;
            aw_done_r <= 1'b0;
            w_done_r <= 1'b0;
            awaddr_r <= '0;
            bvalid_r <= 1'b0;
            control_r <= '0;
            phase_inc_r <= '0;
            bresp_r <= '0;
            wdata_r <= '0;
            phase_inc_toggle_r <= '0;
        end else begin
            phase_inc_toggle_r <= 1'b0;
            case (write_state_r)
                W_ACCEPT: begin
                    if (awvalid && awready_r) begin
                        aw_done_r <= 1'b1;
                        awready_r <= 1'b0;
                        awaddr_r <= awaddr;
                    end

                    if (wvalid && wready_r) begin
                        w_done_r <= 1'b1;
                        wready_r <= 1'b0;
                        // TODO: implement STRB
                        wdata_r <= wdata;
                    end

                    if (aw_hit && w_hit) begin
                        write_state_r <= W_WRITE;
                    end else begin
                        write_state_r <= W_ACCEPT;
                    end
                end

                W_WRITE: begin
                    write_state_r <= W_RESPONSE;
                    bvalid_r <= 1'b1;
                    bresp_r <= 2'b00;
                    case (awaddr_r[3:2])
                        2'd1: control_r   <= wdata_r[1:0];
                        2'd2: begin
                            phase_inc_r <= wdata_r;
                            phase_inc_toggle_r <= 1'b1;
                        end
                    endcase
                end

                W_RESPONSE: begin
                    write_state_r <= W_RESPONSE;
                    if (bready) begin
                        bvalid_r <= 1'b0;
                        aw_done_r <= 1'b0;
                        w_done_r <= 1'b0;
                        awready_r <= 1'b1;
                        wready_r <= 1'b1;
                        write_state_r <= W_ACCEPT;
                    end
                end
            endcase
        end
    end

    // ACCEPT state trackers
    assign aw_hit = aw_done_r || (awvalid && awready_r);
    assign w_hit = w_done_r || (wvalid && wready_r);

    assign status_r = {overflow_s, sat_s};
    assign enable = control_r[0];
    assign soft_reset = control_r[1];

    // read
    always_ff @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            read_state_r <= R_ACCEPT;
            arready_r <= 1'b1;
            rdata_r <= '0;
            rvalid_r <= 1'b0;
            rresp_r <= 2'b00;
        end else begin
            case (read_state_r)
                R_ACCEPT: begin
                    if (arvalid && arready_r) begin
                        read_state_r <= R_RESPONSE;
                        arready_r <= 1'b0;
                        rvalid_r <= 1'b1;
                        case (araddr[3:2])
                            2'd0: rdata_r <= ID_CONSTANT;
                            2'd1: rdata_r <= {30'b0, control_r};
                            2'd2: rdata_r <= phase_inc_r;
                            2'd3: rdata_r <= {30'b0, status_r};
                            default: rdata_r <= 32'b0;
                        endcase
                        rresp_r <= 2'b00;
                    end
                end

                R_RESPONSE: begin
                    read_state_r <= R_RESPONSE;
                    if (rvalid_r && rready) begin
                        read_state_r <= R_ACCEPT;
                        rvalid_r <= 1'b0;
                        arready_r <= 1'b1;
                    end
                end
            endcase
        end
    end

    // assign outputs
    assign awready = awready_r;
    assign wready = wready_r;
    assign bresp = bresp_r;
    assign bvalid = bvalid_r;
    assign rdata = rdata_r;
    assign arready = arready_r;
    assign rresp = rresp_r;
    assign rvalid = rvalid_r;
    assign phase_inc = phase_inc_r;
    assign phase_inc_sync = phase_inc_toggle_r;

    
endmodule