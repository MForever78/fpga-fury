module Hero_state(clk, btn, old_state, state);

    input wire clk;
    input wire [3: 0] btn;
    output reg [1: 0] old_state, state;

    always @(posedge clk) begin
        old_state <= state;
        case (btn)
            4'b0001: begin
                state <= 2'b00;
            end
            4'b0010: begin
                state <= 2'b01;
            end
            4'b0100: begin
                state <= 2'b10;
            end
            4'b1000: begin
                state <= 2'b11;
            end
        endcase
    end

endmodule
