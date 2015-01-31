`timescale 1ns / 1ps
module top(clk_100MHz, btn, sw, segment, vsync, hsync, vga_R, vga_B, vga_G);

    input wire clk_100MHz;
    input wire [3: 0] btn;
    input wire [7: 0] sw;
    output wire [7: 0] segment;
    output wire vsync, hsync;
    output wire [2: 0] vga_R, vga_G;
    output wire [1: 0] vga_B;

    wire clk_vga, valid;
    wire [9: 0] x_pos, y_pos;
    wire [7: 0] RGB;
    wire [15: 0] addr_bg;

    Counter_vga c1(clk_100MHz, clk_vga);
    VGA_generator generator(clk_vga, hsync, vsync, x_pos, y_pos, valid);
    VGA_render render(valid, hsync, vsync, x_pos, y_pos, RGB, addr_bg, vga_R, vga_G, vga_B);

    BG bg(.clka(clk_vga), .addra(addr_bg), .douta(RGB));

endmodule
