module Random (clk, reseed, seed_val, out);

    input clk, reseed;
    input [31: 0] seed_val;
    output wire [15: 0] out;

    reg [31: 0] state = 0;

    always @(posedge clk) begin
        if (reseed) state <= seed_val;
        else begin
            state <= state * 32'h343fd + 32'h269EC3;
        end
    end

    assign out = (state >> 16) & 16'h7fff;

endmodule
