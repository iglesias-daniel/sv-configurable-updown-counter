module counter_tb;

    localparam WIDTH = 8;

    logic clk, en, rst_n, dir;
    logic [WIDTH-1:0] count;

    counter #(
        .WIDTH(WIDTH)
    ) DUT (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .dir(dir),
        .count(count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/counter_tb.vcd");
        $dumpvars(0, counter_tb);
        $display("Simulation begins");
        rst_n = 0;
        en = 0;
        dir = 0;
        #15 rst_n = 1;
        #10 en = 1;
        #100 en = 0;
        #20 dir = 1;
        #20 en = 1;
        #100 dir = 0;
        #100;
        $finish;
    end

endmodule