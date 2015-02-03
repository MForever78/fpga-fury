module Monster_state_calculator(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, x_bg, y_bg, addr_monster, monster_up_on, monster_down_on, monster_left_on, monster_right_on);

    input wire [18: 0] m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11;
    input wire [7: 0] x_bg, y_bg;
    output wire [8: 0] addr_monster;
    output wire monster_up_on, monster_down_on, monster_left_on, monster_right_on;

    parameter
        MONS_W = 20,
        MONS_H = 21,
        MONSTERS = 12;

    wire [11: 0] monster;
    wire [7: 0] x_monster, y_monster;
    wire [11: 0] addr;

    assign monster[0] = m0[0] && (x_bg >= m0[10: 3]) && (x_bg < m0[10: 3] + MONS_W) && (y_bg >= m0[18: 11]) && (y_bg < m0[18: 11] + MONS_H);
    assign monster[1] = m1[0] && (x_bg >= m1[10: 3]) && (x_bg < m1[10: 3] + MONS_W) && (y_bg >= m1[18: 11]) && (y_bg < m1[18: 11] + MONS_H);
    assign monster[2] = m2[0] && (x_bg >= m2[10: 3]) && (x_bg < m2[10: 3] + MONS_W) && (y_bg >= m2[18: 11]) && (y_bg < m2[18: 11] + MONS_H);
    assign monster[3] = m3[0] && (x_bg >= m3[10: 3]) && (x_bg < m3[10: 3] + MONS_W) && (y_bg >= m3[18: 11]) && (y_bg < m3[18: 11] + MONS_H);
    assign monster[4] = m4[0] && (x_bg >= m4[10: 3]) && (x_bg < m4[10: 3] + MONS_W) && (y_bg >= m4[18: 11]) && (y_bg < m4[18: 11] + MONS_H);
    assign monster[5] = m5[0] && (x_bg >= m5[10: 3]) && (x_bg < m5[10: 3] + MONS_W) && (y_bg >= m5[18: 11]) && (y_bg < m5[18: 11] + MONS_H);
    assign monster[6] = m6[0] && (x_bg >= m6[10: 3]) && (x_bg < m6[10: 3] + MONS_W) && (y_bg >= m6[18: 11]) && (y_bg < m6[18: 11] + MONS_H);
    assign monster[7] = m7[0] && (x_bg >= m7[10: 3]) && (x_bg < m7[10: 3] + MONS_W) && (y_bg >= m7[18: 11]) && (y_bg < m7[18: 11] + MONS_H);
    assign monster[8] = m8[0] && (x_bg >= m8[10: 3]) && (x_bg < m8[10: 3] + MONS_W) && (y_bg >= m8[18: 11]) && (y_bg < m8[18: 11] + MONS_H);
    assign monster[9] = m9[0] && (x_bg >= m9[10: 3]) && (x_bg < m9[10: 3] + MONS_W) && (y_bg >= m9[18: 11]) && (y_bg < m9[18: 11] + MONS_H);
    assign monster[10] = m10[0] && (x_bg >= m10[10: 3]) && (x_bg < m10[10: 3] + MONS_W) && (y_bg >= m10[18: 11]) && (y_bg < m10[18: 11] + MONS_H);
    assign monster[11] = m11[0] && (x_bg >= m11[10: 3]) && (x_bg < m11[10: 3] + MONS_W) && (y_bg >= m11[18: 11]) && (y_bg < m11[18: 11] + MONS_H);

    assign monster_up_on = (m0[2: 1] == 2'b00 && monster[0]) || (m1[2: 1] == 2'b00 && monster[1]) || (m2[2: 1] == 2'b00 && monster[2]) || (m3[2: 1] == 2'b00 && monster[3]) || (m4[2: 1] == 2'b00 && monster[4]) || (m5[2: 1] == 2'b00 && monster[5]) || (m6[2: 1] == 2'b00 && monster[6]) || (m7[2: 1] == 2'b00 && monster[7]) || (m8[2: 1] == 2'b00 && monster[8]) || (m9[2: 1] == 2'b00 && monster[9]) || (m10[2: 1] == 2'b00 && monster[10]) || (m11[2: 1] == 2'b00 && monster[11]);
    assign monster_down_on = (m0[2: 1] == 2'b01 && monster[0]) || (m1[2: 1] == 2'b01 && monster[1]) || (m2[2: 1] == 2'b01 && monster[2]) || (m3[2: 1] == 2'b01 && monster[3]) || (m4[2: 1] == 2'b01 && monster[4]) || (m5[2: 1] == 2'b01 && monster[5]) || (m6[2: 1] == 2'b01 && monster[6]) || (m7[2: 1] == 2'b01 && monster[7]) || (m8[2: 1] == 2'b01 && monster[8]) || (m9[2: 1] == 2'b01 && monster[9]) || (m10[2: 1] == 2'b01 && monster[10]) || (m11[2: 1] == 2'b01 && monster[11]);
    assign monster_left_on = (m0[2: 1] == 2'b10 && monster[0]) || (m1[2: 1] == 2'b10 && monster[1]) || (m2[2: 1] == 2'b10 && monster[2]) || (m3[2: 1] == 2'b10 && monster[3]) || (m4[2: 1] == 2'b10 && monster[4]) || (m5[2: 1] == 2'b10 && monster[5]) || (m6[2: 1] == 2'b10 && monster[6]) || (m7[2: 1] == 2'b10 && monster[7]) || (m8[2: 1] == 2'b10 && monster[8]) || (m9[2: 1] == 2'b10 && monster[9]) || (m10[2: 1] == 2'b10 && monster[10]) || (m11[2: 1] == 2'b10 && monster[11]);
    assign monster_right_on = (m0[2: 1] == 2'b11 && monster[0]) || (m1[2: 1] == 2'b11 && monster[1]) || (m2[2: 1] == 2'b11 && monster[2]) || (m3[2: 1] == 2'b11 && monster[3]) || (m4[2: 1] == 2'b11 && monster[4]) || (m5[2: 1] == 2'b11 && monster[5]) || (m6[2: 1] == 2'b11 && monster[6]) || (m7[2: 1] == 2'b11 && monster[7]) || (m8[2: 1] == 2'b11 && monster[8]) || (m9[2: 1] == 2'b11 && monster[9]) || (m10[2: 1] == 2'b11 && monster[10]) || (m11[2: 1] == 2'b11 && monster[11]);

    assign x_monster = ({8{monster[0]}} & (x_bg - m0[10: 3])) |
        ({8{monster[1]}} & (x_bg - m1[10: 3])) |
        ({8{monster[2]}} & (x_bg - m2[10: 3])) |
        ({8{monster[3]}} & (x_bg - m3[10: 3])) |
        ({8{monster[4]}} & (x_bg - m4[10: 3])) |
        ({8{monster[5]}} & (x_bg - m5[10: 3])) |
        ({8{monster[6]}} & (x_bg - m6[10: 3])) |
        ({8{monster[7]}} & (x_bg - m7[10: 3])) |
        ({8{monster[8]}} & (x_bg - m8[10: 3])) |
        ({8{monster[9]}} & (x_bg - m9[10: 3])) |
        ({8{monster[10]}} & (x_bg - m10[10: 3])) |
        ({8{monster[11]}} & (x_bg - m11[10: 3]));
    assign y_monster = ({8{monster[0]}} & (y_bg - m0[18: 11])) |
        ({8{monster[1]}} & (y_bg - m1[18: 11])) |
        ({8{monster[2]}} & (y_bg - m2[18: 11])) |
        ({8{monster[3]}} & (y_bg - m3[18: 11])) |
        ({8{monster[4]}} & (y_bg - m4[18: 11])) |
        ({8{monster[5]}} & (y_bg - m5[18: 11])) |
        ({8{monster[6]}} & (y_bg - m6[18: 11])) |
        ({8{monster[7]}} & (y_bg - m7[18: 11])) |
        ({8{monster[8]}} & (y_bg - m8[18: 11])) |
        ({8{monster[9]}} & (y_bg - m9[18: 11])) |
        ({8{monster[10]}} & (y_bg - m10[18: 11])) |
        ({8{monster[11]}} & (y_bg - m11[18: 11]));

    assign addr = {y_monster, 4'b0000} + {2'b00, y_monster, 2'b00} + {4'b0000, x_monster};
    assign addr_monster = addr[8: 0];

endmodule
