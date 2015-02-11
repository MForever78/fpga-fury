module VGA_selector(alive, clk_vga, clk_hero, clk_pace, data_bg, data_hero_main_0, data_hero_main_1, data_hero_up, data_hero_down, data_hero_left, data_hero_right, data_monster_up_0, data_monster_up_1, data_monster_down_0, data_monster_down_1, data_monster_left_0, data_monster_left_1, data_monster_right_0, data_monster_right_1, addr_bg, addr_hero, addr_monster, state_monsters, state_hero, x_ptr, y_ptr, pressing, RGB);

    input wire clk_vga, clk_hero, clk_pace, alive;
    input wire pressing;
    input wire [7: 0] data_bg, data_hero_main_0, data_hero_main_1, data_hero_up, data_hero_down, data_hero_left, data_hero_right, data_monster_up_0, data_monster_up_1, data_monster_down_0, data_monster_down_1, data_monster_left_0, data_monster_left_1, data_monster_right_0, data_monster_right_1;
    input wire [227: 0] state_monsters;
    input wire [1: 0] state_hero;
    input wire [9: 0] x_ptr, y_ptr;
    output wire [15: 0] addr_bg;
    output wire [8: 0] addr_hero, addr_monster;
    output reg [7: 0] RGB;

    wire [7: 0] x_bg, y_bg;
    wire [4: 0] x_hero, y_hero;
    wire bg_on, hero_main_on, hero_up_on, hero_down_on, hero_left_on, hero_right_on;
    wire monster_up_on, monster_down_on, monster_left_on, monster_right_on, monster_on;

    parameter
        TRANSPARENT = 8'b11111100,
        LEFT = 155,
        BG_W = 330,
        BG_H = 480,
        HERO_LEFT = 72,
        HERO_UP = 112,
        HERO_W = 21,
        HERO_MAIN_H = 15,
        HERO_HORI_H = 19,
        HERO_VERT_H = 16,
        MONS_W = 20,
        MONS_H = 21,
        MONSTERS = 12;

    assign x_bg = (x_ptr - LEFT) / 2;
    assign y_bg = y_ptr / 2;

    assign x_hero = x_bg - HERO_LEFT;
    assign y_hero = y_bg - HERO_UP;

    // 165=128+32+4+1
    assign addr_bg = {1'b0, y_bg, 7'b0000000} + {3'b000, y_bg, 5'b00000} + {6'b000000, y_bg, 2'b00} + {8'b00000000, y_bg} + {8'b00000000, x_bg};
    // 21=16+4+1
    assign addr_hero = {y_hero, 4'b0000} + {2'b00, y_hero, 2'b00} + {4'b0000, y_hero} + {4'b0000, x_hero};

    assign bg_on = (x_ptr >= LEFT) && (x_ptr < LEFT + BG_W) && (y_ptr >= 0) && (y_ptr < BG_H);
    assign hero_main_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_MAIN_H);
    assign hero_up_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_VERT_H);
    assign hero_down_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_VERT_H);
    assign hero_left_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_HORI_H);
    assign hero_right_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_HORI_H);

    assign monster_on = monster_up_on | monster_down_on | monster_left_on | monster_right_on;

    Monster_state_calculator monster_state_calculator(state_monsters[18: 0], state_monsters[37: 19], state_monsters[56: 38], state_monsters[75: 57], state_monsters[94: 76], state_monsters[113: 95], state_monsters[132: 114], state_monsters[151: 133], state_monsters[170: 152], state_monsters[189: 171], state_monsters[208: 190], state_monsters[227: 209], x_bg, y_bg, addr_monster, monster_up_on, monster_down_on, monster_left_on, monster_right_on);

//    genvar i;
//    generate
//        for (i = 0; i < MONSTERS; i = i + 1) begin
//            always @* begin
//                if (state_monsters[i * 19] && (x_bg >= state_monsters[i * 19 + 10: i * 19 + 3]) && (x_bg < state_monsters[i * 19 + 10: i * 19 + 3] + MONS_W) && (y_bg >= state_monsters[i * 19 + 18: i * 19 + 11]) && (y_bg < state_monsters[i * 19 + 18: i * 19 + 11] + MONS_H)) begin
//                    x_monster <= x_bg - state_monsters[i * 19 + 10: i * 19 + 3];
//                    y_monster <= y_bg - state_monsters[i * 19 + 18: i * 19 + 11];
//                    addr_monster <= {y_monster, 4'b0000} + {2'b00, y_monster, 2'b00} + {4'b0000, x_monster};
//                    case (state_monsters[i * 19 + 2: i * 19 + 1])
//                        2'b00: begin
//                            monster_up_on <= 1;
//                            monster_down_on <= 0;
//                            monster_left_on <= 0;
//                            monster_right_on <= 0;
//                        end
//                        2'b01: begin
//                            monster_up_on <= 0;
//                            monster_down_on <= 1;
//                            monster_left_on <= 0;
//                            monster_right_on <= 0;
//                        end
//                        2'b10: begin
//                            monster_up_on <= 0;
//                            monster_down_on <= 0;
//                            monster_left_on <= 1;
//                            monster_right_on <= 0;
//                        end
//                        2'b11: begin
//                            monster_up_on <= 0;
//                            monster_down_on <= 0;
//                            monster_left_on <= 0;
//                            monster_right_on <= 1;
//                        end
//                    endcase
//                end
//            end
//        end
//    endgenerate

    always @(posedge clk_vga) begin
        if (bg_on) begin
            if (alive && monster_on) begin
                if (monster_up_on && clk_hero && data_monster_up_0 != TRANSPARENT) begin
                    RGB <= data_monster_up_0;
                end
                else if (monster_up_on && !clk_hero && data_monster_up_1 != TRANSPARENT) begin
                    RGB <= data_monster_up_1;
                end
                else if (monster_down_on && clk_hero && data_monster_down_0 != TRANSPARENT) begin
                    RGB <= data_monster_down_0;
                end
                else if (monster_down_on && !clk_hero && data_monster_down_1 != TRANSPARENT) begin
                    RGB <= data_monster_down_1;
                end
                else if (monster_left_on && clk_hero && data_monster_left_0 != TRANSPARENT) begin
                    RGB <= data_monster_left_0;
                end
                else if (monster_left_on && !clk_hero && data_monster_left_1 != TRANSPARENT) begin
                    RGB <= data_monster_left_1;
                end
                else if (monster_right_on && clk_hero && data_monster_right_0 != TRANSPARENT) begin
                    RGB <= data_monster_right_0;
                end
                else if (monster_right_on && !clk_hero && data_monster_right_1 != TRANSPARENT) begin
                    RGB <= data_monster_right_1;
                end
                else
                    RGB <= data_bg;
            end
            else if (pressing) begin
                case (state_hero)
                    2'b00: begin
                        if (hero_up_on && data_hero_up != TRANSPARENT)
                            RGB <= data_hero_up;
                        else
                            RGB <= data_bg;
                    end
                    2'b01: begin
                        if (hero_down_on && data_hero_down != TRANSPARENT)
                            RGB <= data_hero_down;
                        else
                            RGB <= data_bg;
                    end
                    2'b10: begin
                        if (hero_left_on && data_hero_left != TRANSPARENT)
                            RGB <= data_hero_left;
                        else
                            RGB <= data_bg;
                    end
                    2'b11: begin
                        if (hero_right_on && data_hero_right != TRANSPARENT)
                            RGB <= data_hero_right;
                        else
                            RGB <= data_bg;
                    end
                endcase
            end
            else if (hero_main_on && clk_hero && data_hero_main_0 != TRANSPARENT)
                RGB <= data_hero_main_0;
            else if (hero_main_on && !clk_hero && data_hero_main_1 != TRANSPARENT)
                RGB <= data_hero_main_1;
            else
                RGB <= data_bg;
        end
        else
            RGB <= 8'b0;
    end

endmodule
