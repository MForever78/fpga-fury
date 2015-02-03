`timescale 1ns / 1ps
module top(clk_100MHz, btn, power, sw, segment, vsync, hsync, vga_R, vga_B, vga_G, Led);

    input wire clk_100MHz, power;
    input wire [3: 0] btn;
    input wire [7: 0] sw;
    output wire [7: 0] segment;
    output wire vsync, hsync;
    output wire [2: 0] vga_R, vga_G;
    output wire [1: 0] vga_B;
    output wire [7: 0] Led;

    wire clk_vga, valid, pressing, pressed, start, toggle;
    wire [9: 0] x_ptr, y_ptr;
    wire [7: 0] RGB, data_bg, data_hero_main_0, data_hero_main_1, data_hero_up, data_hero_down, data_hero_left, data_hero_right, data_monster_up_0, data_monster_up_1, data_monster_down_0, data_monster_down_1, data_monster_left_0, data_monster_left_1, data_monster_right_0, data_monster_right_1;
    wire [15: 0] addr_bg;
    wire [8: 0] addr_hero_main_0, addr_hero_main_1, addr_hero_up, addr_hero_down, addr_hero_left, addr_hero_right, addr_monster_up_0, addr_monster_up_1, addr_monster_down_0, addr_monster_down_1, addr_monster_left_0, addr_monster_left_1, addr_monster_right_0, addr_monster_right_1;
    wire [1: 0] state_hero, state_hero_old;
    wire [227: 0] state_monsters;

    assign pressing = ^btn;
    assign Led = {6'b000000, start, toggle};

    // Generate vga clock
    Counter_vga c1(
        .clk(clk_100MHz),
        .clk_vga(clk_vga)
    );

    // Generate several game ralated clocks:
    // clk_hero: used for determining the animation of charactors
    // clk_game: high frequency, used for main state clock
    // clk_move: low frequency, used for determining game speed
    Clock_div c2(
        .clk(clk_100MHz),
        .clk_hero(clk_hero),
        .clk_game(clk_game),
        .clk_move(clk_move)
    );

    // Main state maintainer
    State_machine state_machine(
        .clk_game(clk_game),
        .clk_move(clk_move),
        .state_hero(state_hero),
        .power(power),
        .pressing(pressing),
        .start(start),
        .toggle(toggle),
        .state_monsters(state_monsters)
    );

    // Generate hero state asynchronously
    Hero_state hero_state(
        .clk(clk_game),
        .btn(btn),
        .old_state(state_hero_old),
        .state(state_hero)
    );

    // Generate VGA hsync and vsync:
    // x_ptr / y_ptr: current coordinate
    // valid: if current coordinate in the visiable area
    VGA_generator generator(
        .clk(clk_vga),
        .hsync(hsync),
        .vsync(vsync),
        .x_ptr(x_ptr),
        .y_ptr(y_ptr),
        .valid(valid)
    );

    // Determine which color should draw now
    VGA_selector selector(
        .start(start),
        .clk(clk_vga),
        .clk0(clk_hero),
        .clk1(clk_game),
        .data0(data_bg),
        .data1(data_hero_main_0),
        .data2(data_hero_main_1),
        .data3(data_hero_up),
        .data4(data_hero_down),
        .data5(data_hero_left),
        .data6(data_hero_right),
        .data7(data_monster_up_0),
        .data8(data_monster_up_1),
        .data9(data_monster_down_0),
        .data10(data_monster_down_1),
        .data11(data_monster_left_0),
        .data12(data_monster_left_1),
        .data13(data_monster_right_0),
        .data14(data_monster_right_1),
        .addr0(addr_bg),
        .addr1(addr_hero_main_0),
        .addr2(addr_hero_main_1),
        .addr3(addr_hero_up),
        .addr4(addr_hero_down),
        .addr5(addr_hero_left),
        .addr6(addr_hero_right),
        .addr7(addr_monster_up_0),
        .addr8(addr_monster_up_1),
        .addr9(addr_monster_down_0),
        .addr10(addr_monster_down_1),
        .addr11(addr_monster_left_0),
        .addr12(addr_monster_left_1),
        .addr13(addr_monster_right_0),
        .addr14(addr_monster_right_1),
        .state0(state_monsters),
        .state1(state_hero),
        .x_ptr(x_ptr),
        .y_ptr(y_ptr),
        .pressing(pressing),
        .RGB(RGB)
    );

    // Draw given color to VGA
    VGA_render render(valid, RGB, vga_R, vga_G, vga_B);

    // Background IP core
    BG bg(.clka(clk_vga), .addra(addr_bg), .douta(data_bg));

    // Hero related IP cores
    Hero_main_0 hero_main_0(.clka(clk_vga), .addra(addr_hero_main_0), .douta(data_hero_main_0));
    Hero_main_1 hero_main_1(.clka(clk_vga), .addra(addr_hero_main_1), .douta(data_hero_main_1));
    Hero_up hero_up(.clka(clk_vga), .addra(addr_hero_up), .douta(data_hero_up));
    Hero_down hero_down(.clka(clk_vga), .addra(addr_hero_down), .douta(data_hero_down));
    Hero_left hero_left(.clka(clk_vga), .addra(addr_hero_left), .douta(data_hero_left));
    Hero_right hero_right(.clka(clk_vga), .addra(addr_hero_right), .douta(data_hero_right));

    // Monster related IP cores
    Monster_up_0 monster_up_0(.clka(clk_vga), .addra(addr_monster_up_0), .douta(data_monster_up_0));
    Monster_up_1 monster_up_1(.clka(clk_vga), .addra(addr_monster_up_1), .douta(data_monster_up_1));
    Monster_down_0 monster_down_0(.clka(clk_vga), .addra(addr_monster_down_0), .douta(data_monster_down_0));
    Monster_down_1 monster_down_1(.clka(clk_vga), .addra(addr_monster_down_1), .douta(data_monster_down_1));
    Monster_left_0 monster_left_0(.clka(clk_vga), .addra(addr_monster_left_0), .douta(data_monster_left_0));
    Monster_left_1 monster_left_1(.clka(clk_vga), .addra(addr_monster_left_1), .douta(data_monster_left_1));
    Monster_right_0 monster_right_0(.clka(clk_vga), .addra(addr_monster_right_0), .douta(data_monster_right_0));
    Monster_right_1 monster_right_1(.clka(clk_vga), .addra(addr_monster_right_1), .douta(data_monster_right_1));

endmodule
