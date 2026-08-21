module AXI_adapter #(
    parameter int unsigned PACKET_LEN_EXP = 10,
    parameter int unsigned FIFO_DEPTH_EXP = 5
) (
    input logic clk,
    input logic rst,
    input logic [15:0] I_in,
    input logic [15:0] Q_in,
    input logic valid_in,

    output logic [31:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic m_axis_tlast,

    // status bit for FIFO overflows
    output logic overflow_sticky
);
    // keep powers of two to simplify overflow logic on counters
    localparam PACKET_LEN = 2**PACKET_LEN_EXP;
    localparam FIFO_DEPTH = 2**FIFO_DEPTH_EXP;

    logic [31:0] packed_signal;
    logic [$clog2(PACKET_LEN)-1:0] packet_count_r;
    logic overflow_sticky_r;

    // FIFO
    logic [31:0] fifo [FIFO_DEPTH];
    logic [$clog2(FIFO_DEPTH)-1:0] read_ptr;
    logic [$clog2(FIFO_DEPTH)-1:0] write_ptr;
    logic wr_en;
    logic rd_en;
    logic full;
    logic empty;
    
    assign packed_signal = {I_in, Q_in};
    assign wr_en = valid_in && !full;
    assign rd_en = m_axis_tvalid && m_axis_tready;
    assign full = (write_ptr + 1'b1) == read_ptr;
    assign empty = read_ptr == write_ptr;

    always_ff @(posedge clk) begin
        if (rst) begin
            read_ptr <= '0;
            write_ptr <= '0;
            packet_count_r <= '0;
            overflow_sticky_r <= 1'b0;
        end else begin

            if (wr_en) begin
                write_ptr <= write_ptr + 1;
                fifo[write_ptr] <= packed_signal;
            end

            if (rd_en) begin
                read_ptr <= read_ptr + 1;
                packet_count_r <= packet_count_r + 1;
            end      

            // sticky bit logic   
            if (valid_in && full) overflow_sticky_r <= 1'b1;   
        end
    end

    // assign outputs
    assign m_axis_tdata = fifo[read_ptr];
    assign m_axis_tvalid = !empty;
    assign m_axis_tlast = (packet_count_r == PACKET_LEN - 1);
    assign overflow_sticky = overflow_sticky_r;
endmodule