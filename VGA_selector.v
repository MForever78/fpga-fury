module VGA_selector(clk, data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, addr14, state0, state1, x_ptr, y_ptr, RGB);

    input wire clk;
    input wire [7: 0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14;
    input wire [227: 0] state0;
    input wire [1: 0] state1;
    input wire [9: 0] x_ptr, y_ptr;
    output wire [15: 0] addr0;
    output wire [8: 0] addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9, addr10, addr11, addr12, addr13, addr14;
    output reg [7: 0] RGB;

    wire [7: 0] x_bg, y_bg;
    wire [4: 0] x_hero, y_hero;

    parameter
        LEFT = 155,
        BG_W = 330,
        BG_H = 480,
        HERO_LEFT = 72,
        HERO_UP = 112,
        HERO_W = 21,
        HERO_H  = 15,
        MONS_W = 20,
        MONS_H = 15;

    assign x_bg = (x_ptr - LEFT) / 2;
    assign y_bg = y_ptr / 2;

    assign x_hero = x_bg - HERO_LEFT;
    assign y_hero = y_bg - HERO_UP;

    // 165=128+32+4+1
    assign addr0 = {1'b0, y_bg, 7'b0000000} + {3'b000, y_bg, 5'b00000} + {6'b000000, y_bg, 2'b00} + {8'b00000000, y_bg} + {8'b00000000, x_bg};
    // 21=16+4+1
    assign addr1 = {y_hero, 4'b0000} + {2'b00, y_hero, 2'b00} + {4'b0000, y_hero} + {4'b0000, x_hero};

    assign bg_on = (x_ptr >= LEFT) && (x_ptr < LEFT + BG_W) && (y_ptr >= 0) && (y_ptr < BG_H);
    assign hero_on = (x_bg >= HERO_LEFT) && (x_bg < HERO_LEFT + HERO_W) && (y_bg >= HERO_UP) && (y_bg < HERO_UP + HERO_H);

    always @(posedge clk) begin
        if (bg_on) begin
            // 8'b11111100 is the background
            if (hero_on && data1 != 8'b11111100) begin
                RGB <= data1;  
            end
            else
                RGB <= data0;
        end
        else
            RGB <= 8'b0;
    end

endmodule
