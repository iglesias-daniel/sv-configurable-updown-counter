module counter_apb_wrapper #(
    parameter WIDTH = 32,
    parameter ADDRESS = 0x01 // Initial address
) (
    input pclk,
    input presetn, 
    input [31:0] paddr,
    input [31:0] pwdata,
    input pwrite,
    input psel,
    input penable,
    output logic [31:0] prdata,
    output logic pready,
    output logic pslverr
);

    logic [31:0] r_en; // RW
    logic [31:0] r_rst_n; // RW
    logic [31:0] r_dir; // RW
    logic [31:0] r_count; // Only read

    localparam ADDR_EN = ADDRESS;
    localparam ADDR_RST = ADDRESS + 4;
    localparam ADDR_DIR = ADDRESS + 8;
    localparam ADDR_COUNT = ADDRESS + 12;
    localparam INVALID = 32'hDEADBEEF;

    assign pready = 1'b1;
    assign pslverr = 1'b0;

    always_ff @(posedge pclk) begin
        if (!presetn) begin
            r_dir <= 0;
            r_en <= 0;
            r_rst_n <= 0;
        end else begin
            if (penable && psel) begin
                if (pwrite) begin
                    case (paddr)
                        ADDR_EN:    r_en <= pwdata;
                        ADDR_RST:   r_rst_n <= pwdata;
                        ADDR_DIR:   r_dir <= pwdata;
                    endcase
                end 
            end
        end
    end

    always_comb begin
        if (!pwrite && penable && psel) begin
            case (paddr)
                ADDR_EN:    prdata = r_en;
                ADDR_RST:   prdata = r_rst_n;
                ADDR_DIR:   prdata = r_dir;
                ADDR_COUNT: prdata = r_count;
                default:    prdata = INVALID;
            endcase
        end
    end
    
    counter #(
        .WIDTH(WIDTH)
    ) (
        .clk(pclk),
        .en(r_en),
        .rst_n(r_rst_n),
        .dir(r_dir),
        .count(r_count)
    );
endmodule

