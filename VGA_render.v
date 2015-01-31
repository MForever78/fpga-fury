module VGA_render(valid, hsync, vsync, x_pos, y_pos, RGB, addr_bg, vga_R, vga_G, vga_B);

    input wire valid, hsync, vsync;
    input wire [9: 0] x_pos, y_pos;
    input wire [7: 0] RGB;
    output wire [15: 0] addr_bg;
    output wire [2: 0] vga_R, vga_G;
    output wire [1: 0] vga_B;

    wire [7: 0] x_bg, y_bg;

    parameter
        LEFT = 155,
        BG_W = 330,
        BG_H = 480;

    assign x_bg = (x_pos - LEFT) / 2;
    assign y_bg = y_pos / 2;

    // 165=128+32+4+1
    assign addr_bg = {1'b0, y_bg, 7'b0000000} + {3'b000, y_bg, 5'b00000} + {6'b000000, y_bg, 2'b00} + {8'b00000000, y_bg} + {8'b00000000, x_bg};

    assign bg_on = (x_pos >= LEFT) && (x_pos < LEFT + BG_W) && (y_pos >= 0) && (y_pos < BG_H);

    assign vga_R = bg_on ? RGB[7: 5] : 3'b000;
    assign vga_G = bg_on ? RGB[4: 2] : 3'b000;
    assign vga_B = bg_on ? RGB[1: 0] : 2'b00;

endmodule
