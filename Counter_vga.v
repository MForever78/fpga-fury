module Counter_vga(clk, clk_vga);

    input clk;
    output reg clk_vga;

    reg [1: 0] cnt = 0;

    always @(posedge clk) begin
        if (cnt == 2'b11) begin
            cnt <= 0;
            clk_vga <= 1'b1;
        end
        else begin
            cnt <= cnt + 1;
            clk_vga <= 1'b0;
        end
    end

endmodule
