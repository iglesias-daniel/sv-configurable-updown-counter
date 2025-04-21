module counter_apb_tb;

    logic pclk;
    logic presetn;
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic pwrite;
    logic psel;
    logic penable;

    logic [31:0] prdata;
    logic pready;
    logic pslverr;

    logic [31:0] value;

    localparam WIDTH = 32;
    localparam ADDRESS = 1;

    localparam ADDR_EN    = 1;
    localparam ADDR_RST   = 5;
    localparam ADDR_DIR   = 9;
    localparam ADDR_COUNT = 13;


    counter_apb_wrapper #(
        .WIDTH(WIDTH),
        .ADDRESS(ADDRESS)
    ) DUT (
        .pclk(pclk),
        .presetn(presetn),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .psel(psel),
        .penable(penable),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    task automatic write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge pclk);
            paddr = addr;
            pwdata = data;
            psel = 1;
            penable = 0;
            pwrite = 1;

            @(posedge pclk);
            penable = 1;
            @(posedge pclk);

            @(posedge pclk);
            psel = 0;
            penable = 0;
        end
    endtask

    task automatic read(input [31:0] addr, output [31:0] data);
        begin
            @(posedge pclk);
            paddr = addr;
            psel = 1;
            penable = 0;
            pwrite = 0;

            @(posedge pclk);
            penable = 1;
            @(posedge pclk);

            @(posedge pclk);
            data = prdata;
            psel = 0;
            penable = 0;
        end
    endtask

    initial pclk = 0;
    always #5 pclk = ~pclk;

    initial begin
        $dumpfile("build/counter_apb_tb.vcd");
        $dumpvars(0, counter_apb_tb);
        $display("Simulation begins");
        presetn = 0;
        #15 presetn = 1; // Reset of the device

        // Enable counter
        write(ADDR_EN,1);
        write(ADDR_RST,1);
        write(ADDR_DIR,0); //up

        #100;
        read(ADDR_COUNT,value);
        $display("Count = %0d", value);

        #100
        read(ADDR_COUNT,value);
        $display("Count = %0d", value);

        write(ADDR_DIR,1); //down

        #50
        read(ADDR_COUNT,value);
        $display("Count = %0d", value);

        $finish;
    end

endmodule