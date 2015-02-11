module Clock_div(clk, clk_pace, clk_game, clk_move, clk_vga);

    input wire clk;
    output wire clk_pace, clk_game, clk_move, clk_vga;

    reg [31: 0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    assign clk_pace = cnt[25];
    assign clk_game = cnt[15];
    assign clk_move = cnt[25];
    assign clk_vga = cnt[1];

endmodule
