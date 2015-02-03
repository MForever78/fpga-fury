module State_machine(clk_game, clk_move, state_hero, power, pressing, start, state_monsters, toggle);

    input wire clk_game, clk_move, power, pressing;
    input wire [1: 0] state_hero;
    output reg start, toggle;
    output reg [227: 0] state_monsters;

    parameter
        MONSTERS = 12,
        Y_DOWN_0 = 47,
        Y_DOWN_1 = 67,
        Y_DOWN_2 = 87,
        Y_UP_0 = 167,
        Y_UP_1 = 147,
        Y_UP_2 = 127,
        Y_HORI = 105,
        X_VERT = 73,
        X_LEFT_0 = 131,
        X_LEFT_1 = 111,
        X_LEFT_2 = 91,
        X_RIGHT_0 = 14,
        X_RIGHT_1 = 34,
        X_RIGHT_2 = 54;

    wire [1: 0] random;
    wire [15: 0] resurrect;

    reg [31: 0] cnt;
    reg [2: 0] attack;
    reg [11: 0] die;
    reg pressed;

    initial begin
        cnt = 0;
        attack = 3'b100;
        start = 0;
        state_monsters = 0;
        toggle = 0;
        die = 0;
    end

    always @(posedge power) begin
        toggle <= ~toggle;
    end

    always @(posedge clk_game) begin
        cnt <= cnt + 1;
        start <= ~(|die) & toggle;
        pressed <= pressing;

        if (start) begin
            if (pressing) begin
                attack <= {1'b0, state_hero};
            end
            else
                attack <= 3'b100;
        end

    end

    assign random = {cnt[13], cnt[12]};
    assign resurrect = {cnt[9], cnt[15], cnt[3], cnt[8]};

    genvar i;
    generate
        for (i = 0; i < MONSTERS; i = i + 1) begin
            always @(posedge clk_move) begin
                if (!start) begin
                    state_monsters[i * 19 + 18: i * 19] <= 0;
                end
                die[i] = 0;
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
                                    if (attack == 3'b001)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        die[i] = 1;
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
                                    if (attack == 3'b000)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        die[i] = 1;
                                end
                            endcase
                        end
                        2'b10: begin
                            case (state_monsters[i * 19 + 10: i * 19 + 3])
                                X_LEFT_0: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= X_LEFT_1;
                                end
                                X_LEFT_1: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= X_LEFT_2;
                                end
                                X_LEFT_2: begin
                                    if (attack == 3'b011)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        die[i] = 1;
                                end
                            endcase
                        end
                        2'b11: begin
                            case (state_monsters[i * 19 + 10: i * 19 + 3])
                                X_RIGHT_0: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= X_RIGHT_1;
                                end
                                X_RIGHT_1: begin
                                    state_monsters[i * 19 + 10: i * 19 + 3] <= X_RIGHT_2;
                                end
                                X_RIGHT_2: begin
                                    if (attack == 3'b010)
                                        state_monsters[i * 19] <= 0;
                                    else
                                        die[i] = 1;
                                end
                            endcase
                        end
                    endcase
                end
            end
        end
    endgenerate

endmodule
