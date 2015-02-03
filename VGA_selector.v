module VGA_selector(start, clk, clk0, clk1, data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, addr14, state0, state1, x_ptr, y_ptr, pressing, RGB);

    input wire clk, clk0, clk1, start;
    input wire pressing;
    input wire [7: 0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14;
    input wire [227: 0] state0;
    input wire [1: 0] state1;
    input wire [9: 0] x_ptr, y_ptr;
    output wire [15: 0] addr0;
    output wire [8: 0] addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, addr14;
    output reg [7: 0] RGB;

    wire [7: 0] x_bg, y_bg;
    wire [4: 0] x_hero, y_hero;
    wire [8: 0] addr_monster;
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
    assign addr0 = {1'b0, y_bg, 7'b0000000} + {3'b000, y_bg, 5'b00000} + {6'b000000, y_bg, 2'b00} + {8'b00000000, y_bg} + {8'b00000000, x_bg};
    // 21=16+4+1
    assign addr1 = {y_hero, 4'b0000} + {2'b00, y_hero, 2'b00} + {4'b0000, y_hero} + {4'b0000, x_hero};
    assign addr2 = addr1;
    assign addr3 = addr1;
    assign addr4 = addr1;
    assign addr5 = addr1;
    assign addr6 = addr1;
    assign addr7 = addr_monster;
    assign addr8 = addr_monster;
    assign addr9 = addr_monster;
    assign addr10 = addr_monster;
    assign addr11 = addr_monster;
    assign addr12 = addr_monster;
    assign addr13 = addr_monster;
    assign addr14 = addr_monster;


    assign bg_on = (x_ptr >= LEFT) && (x_ptr < LEFT + BG_W) && (y_ptr >= 0) && (y_ptr < BG_H);
    assign hero_main_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_MAIN_H);
    assign hero_up_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_VERT_H);
    assign hero_down_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_VERT_H);
    assign hero_left_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_HORI_H);
    assign hero_right_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_HORI_H);

    assign monster_on = monster_up_on | monster_down_on | monster_left_on | monster_right_on;

    Monster_state_calculator monster_state_calculator(state0[18: 0], state0[37: 19], state0[56: 38], state0[75: 57], state0[94: 76], state0[113: 95], state0[132: 114], state0[151: 133], state0[170: 152], state0[189: 171], state0[208: 190], state0[227: 209], x_bg, y_bg, addr_monster, monster_up_on, monster_down_on, monster_left_on, monster_right_on);

//    genvar i;
//    generate
//        for (i = 0; i < MONSTERS; i = i + 1) begin
//            always @* begin
//                if (state0[i * 19] && (x_bg >= state0[i * 19 + 10: i * 19 + 3]) && (x_bg < state0[i * 19 + 10: i * 19 + 3] + MONS_W) && (y_bg >= state0[i * 19 + 18: i * 19 + 11]) && (y_bg < state0[i * 19 + 18: i * 19 + 11] + MONS_H)) begin
//                    x_monster <= x_bg - state0[i * 19 + 10: i * 19 + 3];
//                    y_monster <= y_bg - state0[i * 19 + 18: i * 19 + 11];
//                    addr_monster <= {y_monster, 4'b0000} + {2'b00, y_monster, 2'b00} + {4'b0000, x_monster};
//                    case (state0[i * 19 + 2: i * 19 + 1])
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

    always @(posedge clk) begin
        if (bg_on) begin
            if (start && monster_on) begin
                if (monster_up_on && clk0 && data7 != TRANSPARENT) begin
                    RGB <= data7;
                end
                else if (monster_up_on && !clk0 && data8 != TRANSPARENT) begin
                    RGB <= data8;
                end
                else if (monster_down_on && clk0 && data9 != TRANSPARENT) begin
                    RGB <= data9;
                end
                else if (monster_down_on && !clk0 && data10 != TRANSPARENT) begin
                    RGB <= data10;
                end
                else if (monster_left_on && clk0 && data11 != TRANSPARENT) begin
                    RGB <= data11;
                end
                else if (monster_left_on && !clk0 && data12 != TRANSPARENT) begin
                    RGB <= data12;
                end
                else if (monster_right_on && clk0 && data13 != TRANSPARENT) begin
                    RGB <= data13;
                end
                else if (monster_right_on && !clk0 && data14 != TRANSPARENT) begin
                    RGB <= data14;
                end
                else
                    RGB <= data0;
            end
            else if (pressing) begin
                case (state1)
                    2'b00: begin
                        if (hero_up_on && data3 != TRANSPARENT)
                            RGB <= data3;
                        else
                            RGB <= data0;
                    end
                    2'b01: begin
                        if (hero_down_on && data4 != TRANSPARENT)
                            RGB <= data4;
                        else
                            RGB <= data0;
                    end
                    2'b10: begin
                        if (hero_left_on && data5 != TRANSPARENT)
                            RGB <= data5;
                        else
                            RGB <= data0;
                    end
                    2'b11: begin
                        if (hero_right_on && data6 != TRANSPARENT)
                            RGB <= data6;
                        else
                            RGB <= data0;
                    end
                endcase
            end
            else if (hero_main_on && clk0 && data1 != TRANSPARENT)
                RGB <= data1;
            else if (hero_main_on && !clk0 && data2 != TRANSPARENT)
                RGB <= data2;
            else
                RGB <= data0;
        end
        else
            RGB <= 8'b0;
    end

endmodule
