module AXI_slave_tb;

    localparam ID_CONSTANT = 32'hDEADBEEF;

    logic s_axi_aclk = 1'b0;
    logic s_axi_aresetn = 1'b1;

    // write inputs
    logic [31:0] awaddr;
    logic        awvalid;
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        wvalid;
    logic        bready;

    // read inputs
    logic [31:0] araddr;
    logic        arvalid;
    logic        rready;

    // write outputs
    logic       awready;
    logic       wready;
    logic [1:0] bresp;
    logic       bvalid;

    // read outputs
    logic [31:0] rdata;
    logic        arready;
    logic [1:0]  rresp;
    logic        rvalid;

    // datapath signals
    logic [31:0] phase_inc;
    logic        enable;
    logic        soft_reset;

    // status info
    logic streaming_s;
    logic sat_s;

    
    logic [31:0] d;


    AXI_slave DUT (
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .awaddr(awaddr),
        .awvalid(awvalid),
        .wdata(wdata),
        .wstrb(wstrb),
        .wvalid(wvalid),
        .bready(bready),
        .araddr(araddr),
        .arvalid(arvalid),
        .rready(rready),
        .awready(awready),
        .wready(wready),
        .bresp(bresp),
        .bvalid(bvalid),
        .rdata(rdata),
        .arready(arready),
        .rresp(rresp),
        .rvalid(rvalid),
        .phase_inc(phase_inc),
        .enable(enable),
        .soft_reset(soft_reset),
        .streaming_s(streaming_s),
        .sat_s(sat_s)
    );

    initial begin : generate_clock
        forever #5 s_axi_aclk <= ~s_axi_aclk;
    end

    task automatic axi_read(input logic [31:0] addr, output logic [31:0] data);
        // present address
        araddr <= addr;
        arvalid <= 1'b1;
        do @(posedge s_axi_aclk); while (!arready);
        arvalid <= 1'b0;

        // response
        repeat ($urandom_range(0, 15)) @(posedge s_axi_aclk); // wait some number of cycles
        rready <= 1'b1;
        do @(posedge s_axi_aclk); while (!rvalid);
        data = rdata;
        if (rresp !== 2'b00) $error("read response not OKAY: %b @ 0x%0h", rresp, addr);
        rready <= 1'b0;
    endtask

    task automatic axi_write(input logic [31:0] addr, input logic [31:0] data);
        // present address and data
        awaddr <= addr;
        wdata <= data;
        fork
            begin
                repeat ($urandom_range(0, 15)) @(posedge s_axi_aclk);
                awvalid <= 1'b1;
                do @(posedge s_axi_aclk); while (!awready);
                awvalid <= 1'b0;
            end
            begin
                repeat ($urandom_range(0, 15)) @(posedge s_axi_aclk);
                wvalid <= 1'b1;
                do @(posedge s_axi_aclk); while (!wready);
                wvalid <= 1'b0;
            end
        join

        // response
        repeat ($urandom_range(0, 15)) @(posedge s_axi_aclk); // wait some number of cycles
        bready <= 1'b1;
        do @(posedge s_axi_aclk); while (!bvalid);
        if (bresp !== 2'b00) $error("write response not OKAY: %b @ 0x%0h : 0x%0h", bresp, addr, data);
        bready<= 1'b0;
    endtask

    initial begin : driver
        s_axi_aresetn <= 1'b0;
        repeat (5) @(posedge s_axi_aclk);

        @(negedge s_axi_aclk);
        s_axi_aresetn <= 1'b1;

        wstrb <= 4'hF;

        axi_read(32'h0000, d);
        assert (d === ID_CONSTANT);

        axi_write(32'h0008, 32'h12345678);
        axi_read (32'h0008, d);
        assert(d === 32'h1234_5678);
        assert(phase_inc === 32'h12345678);

        // CONTROL bits reach the outputs
        axi_write(32'h0004, 32'h3);
        assert(enable === 1'b1 && soft_reset === 1'b1);

        // RO registers ignore writes
        axi_write(32'h0000, 32'hFFFFFFFF);
        axi_read (32'h0000, d);
        assert(d === 32'hDEADBEEF);

        // STATUS reflects the inputs
        streaming_s <= 1'b1;
        sat_s <= 1'b0;
        @(posedge s_axi_aclk);
        axi_read(32'h000C, d);
        assert(d[1:0] === 2'b10);

        $display("Tests complete.");
        disable generate_clock;
    end    
endmodule