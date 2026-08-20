module AXI_adapter_tb #(
    parameter int unsigned N = 100000
);

    logic clk = 1'b0;
    logic rst;
    logic [15:0] I_in;
    logic [15:0] Q_in;
    logic valid_in;
    logic [31:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;
    logic m_axis_tlast;
    logic overflow_sticky;

    logic [31:0] expected [$];

    event ready_to_fill;
    event fill_done;

    AXI_adapter DUT (
        .clk(clk),
        .rst(rst),
        .I_in(I_in),
        .Q_in(Q_in),
        .valid_in(valid_in),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast),
        .overflow_sticky(overflow_sticky)
    );

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin : driver
        rst <= 1'b1;
        repeat (5) @(posedge clk);

        @(negedge clk);
        rst <= 1'b0;

        for (int i = 0; i < N; i++) begin
            I_in <= i;
            Q_in <= ~i;
            valid_in <= 1'b1;
            @(posedge clk);
            valid_in <= 1'b0;
            expected.push_back({i[15:0], ~(i[15:0])});
            if (i != N-1) repeat ($urandom_range(0, 1000)) @(posedge clk); // random spacing
        end

        @(ready_to_fill);
        for (int i = 0; i < DUT.FIFO_DEPTH + 50; i++) begin
            I_in <= i;
            Q_in <= i;
            valid_in <= 1'b1;
            @(posedge clk);
        end
        valid_in <= 1'b0;
        ->fill_done;
    end

    initial begin : scoreboard
        int unsigned beat_count = 0;
        @(negedge rst);

        for (int i = 0; i < N; i++) begin
            do begin
                m_axis_tready <= ($urandom_range(0, 3) != 0);
                @(posedge clk); 
            end while (!(m_axis_tvalid && m_axis_tready));
            
            assert (m_axis_tdata === expected.pop_front()) else $error("tdata mismatch for beat %0d", i);
            assert (m_axis_tlast === (beat_count == DUT.PACKET_LEN - 1)) else $error("tlast wrong for beat %0d", i);
            beat_count = (beat_count == DUT.PACKET_LEN - 1) ? 0 : beat_count + 1;
        end

        assert (expected.size() == 0) else $error("leftover samples");
        assert (overflow_sticky === 1'b0);

        // overflow test
        m_axis_tready <= 1'b0;
        @(posedge clk);
        -> ready_to_fill;
        @(fill_done);
        @(posedge clk);
        assert (overflow_sticky == 1'b1);

        $display("Tests complete.");
        disable generate_clock;
    end
endmodule