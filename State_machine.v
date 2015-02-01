module State_machine(clk_game, clk_move, state_hero, power, pressed, pressing, start, state_monsters);

    input wire clk_game, clk_move, power, pressed, pressing;
    input wire [1: 0] state_hero;
    output reg start;
    output wire [227: 0] state_monsters;

    parameter
        MONSTERS = 12;

    wire [1: 0] random;
    wire [15: 0] resurrect;

    reg [31: 0] cnt;
    reg [2: 0] attack;

    initial begin
        cnt = 0;
        attack = 3'b100;
        start = 0;
        state_monsters = 0;
    end

    always @(posedge clk_game) begin
        cnt <= cnt + 1;

        if (power) begin
            start <= ~start;
        end

        if (start) begin
            if (pressing && !pressed) begin
                attack <= state_hero;
            end
            else
                attack <= 3'b100;
        end
    end

    assign random = {cnt[10], cnt[12]};
    assign resurrect = {cnt[9], cnt[15], cnt[3], cnt[8]};

    genvar i;
    generate
        for (i = 0; i < MONSTERS; i = i + 1) begin
            always @(posedge clk_move) begin
                if (!state_monsters[i * 19] && resurrect[i]) begin
                    state_monsters[i * 19] <= 1'b1;
                    state_monsters[i * 19 + 2: i * 19 + 1] <= random;
                    case (random)
                        2'b00: begin
                            state_monsters[i * 19 + 10: i * 19 + 3] <= X_VERT;
                            state_monsters[i * 19 + 18: i * 19 + 11] <= Y_UP_0;
                        end
                        2'b01: begin
                            state_monsters[i * 19 + 10: i * 19 + 3] <= X_VERT;
                            state_monsters[i * 19 + 18: i * 19 + 11] <= Y_DOWN_0;
                        end
                        2'b10: begin
                            state_monsters[i * 19 + 10: i * 19 + 3] <= X_LEFT_0;
                            state_monsters[i * 19 + 18: i * 19 + 11] <= Y_HORI;
                        end
                        2'b11: begin
                            state_monsters[i * 19 + 10: i * 19 + 3] <= X_RIGHT_0;
                            state_monsters[i * 19 + 18: i * 19 + 11] <= Y_HORI;
                        end
                    endcase
                end

                if (state_monsters[i * 19] == 1) begin
                    case (state_monsters[i * 19 + 2: i * 19 + 1])
                        2'b00: begin
                            case (state_monsters[i * 19 + 18: i * 19 + 11])
                                Y_UP_0: begin
                                    state_monsters[i * 19 + 18: i * 19 + 11] <= Y_UP_1;
                                end
                                Y_UP_1: begin
                                    state_monsters[i * 19 + 18: i * 19 + 11] <= Y_UP_2;
                                end
                                Y_UP_2: begin
                                    if (attack == 2'b01)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        start <= 0;
                                end
                            endcase
                        end
                        2'b01: begin
                            case (state_monsters[i * 19 + 18: i * 19 + 11])
                                Y_DOWN_0: begin
                                    state_monsters[i * 19 + 18: i * 19 + 11] <= Y_DOWN_1;
                                end
                                Y_DOWN_1: begin
                                    state_monsters[i * 19 + 18: i * 19 + 11] <= Y_DOWN_2;
                                end
                                Y_DOWN_2: begin
                                    if (attack == 2'b00)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        start <= 0;
                                end
                            endcase
                        end
                        2'b10: begin
                            case (state_monsters[i * 19 + 10: i * 19 + 3])
                                Y_LEFT_0: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= Y_LEFT_1;
                                end
                                Y_LEFT_1: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= Y_LEFT_2;
                                end
                                Y_LEFT_2: begin
                                    if (attack == 2'b11)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        start <= 0;
                                end
                            endcase
                        end
                        2'b11: begin
                            case (state_monsters[i * 19 + 10: i * 19 + 3])
                                Y_RIGHT_0: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= Y_RIGHT_1;
                                end
                                Y_RIGHT_1: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= Y_RIGHT_2;
                                end
                                Y_RIGHT_2: begin
                                    if (attack == 2'b10)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        start <= 0;
                                end
                            endcase
                        end
                    endcase
                end
            end
        end
    endgenerate

endmodule
