module Clock_div(clk, clk_hero, clk_game, clk_move);

    input wire clk;
    output wire clk_hero, clk_game, clk_move;

    reg [31: 0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    assign clk_hero = cnt[25];
    assign clk_game = cnt[15];
    assign clk_move = cnt[25];

endmodule
