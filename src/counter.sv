module counter #(
    parameter WIDTH = 8
) (
    input clk, en, rst_n, dir,
    output logic [WIDTH-1:0] count
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            count <= 0;
        end else begin 
            if (en) begin
                if (!dir) begin
                    count <= count + 1;
                end else begin
                    count <= count - 1;
                end
            end
        end
    end

endmodule