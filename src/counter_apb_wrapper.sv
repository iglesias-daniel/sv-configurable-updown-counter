module counter_apb_wrapper #(
    parameter WIDTH = 32, // Count size
    parameter ADDRESS = 1 // Initial address
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

    // Registers
    logic [31:0] r_en; // RW
    logic [31:0] r_rst_n; // RW
    logic [31:0] r_dir; // RW
    logic [31:0] r_count; // R

    // Address
    localparam ADDR_EN = ADDRESS;
    localparam ADDR_RST = ADDRESS + 4;
    localparam ADDR_DIR = ADDRESS + 8;
    localparam ADDR_COUNT = ADDRESS + 12;

    localparam INVALID = 32'hDEADBEEF;

    assign pready = 1'b1; // Count is always ready
    assign pslverr = 1'b0; // Not error are consider

    // Update or reset register
    always_ff @(posedge pclk) begin
        if (!presetn) begin
            r_dir <= 0;
            r_en <= 0;
            r_rst_n <= 0;
        end else begin
            if (penable && psel) begin // Only if en and sel are valid, you can write
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

    // Read register
    always_comb begin
        prdata = INVALID; // Avoid that prdata remains without value
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
    ) COUNTER (
        .clk(pclk),
        .en(r_en[0]),
        .rst_n(r_rst_n[0]),
        .dir(r_dir[0]),
        .count(r_count)
    );
endmodule

