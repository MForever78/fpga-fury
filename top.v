`timescale 1ns / 1ps
module top(clk_100MHz, btn, power, sw, segment, vsync, hsync, vga_R, vga_B, vga_G, Led, an);

    input wire clk_100MHz, power;
    input wire [3: 0] btn;
    input wire [7: 0] sw;
    output wire [7: 0] segment;
    output wire vsync, hsync;
    output wire [2: 0] vga_R, vga_G;
    output wire [1: 0] vga_B;
    output wire [7: 0] Led;
    output wire [3: 0] an;

    parameter
        MONSTERS = 12;

    wire clk_vga, valid, pressing, pressed, alive, toggle, power_stable;
    wire [1: 0] scanning;
    wire [3: 0] btn_stable;
    wire [MONSTERS - 1: 0] score_pulse;
    wire [15: 0] score;
    wire [9: 0] x_ptr, y_ptr;
    wire [7: 0] RGB, data_bg, data_hero_main_0, data_hero_main_1, data_hero_up, data_hero_down, data_hero_left, data_hero_right, data_monster_up_0, data_monster_up_1, data_monster_down_0, data_monster_down_1, data_monster_left_0, data_monster_left_1, data_monster_right_0, data_monster_right_1;
    wire [15: 0] addr_bg;
    wire [8: 0] addr_hero, addr_monster;
    wire [1: 0] state_hero, state_hero_old;
    wire [227: 0] state_monsters;

    assign pressing = ^btn_stable;
    assign Led = {6'b0000000, alive};

    Debouncer deboncer(
        .clk(clk_100MHz),
        .btn(btn),
        .btn_stable(btn_stable),
        .power(power),
        .power_stable(power_stable)
    );

    // Generate several game ralated clocks:
    // clk_pace: used for determining the animation of charactors
    // clk_game: high frequency, used for main state clock
    // clk_move: low frequency, used for determining game speed
    Clock_div clock_div(
        .clk(clk_100MHz),
        .clk_pace(clk_pace),
        .clk_game(clk_game),
        .clk_move(clk_move),
        .clk_vga(clk_vga),
        .clk_seg(scanning)
    );

    Score_counter(
        .alive(alive),
        .score_pulse(score_pulse),
        .score(score)
    );

    Seven_seg seven_seg(
        .scanning(scanning),
        .score(score),
        .segment(segment),
        .an(an)
    );

    // Main state maintainer
    State_machine state_machine(
        .clk_game(clk_game),
        .clk_move(clk_move),
        .state_hero(state_hero),
        .power(power_stable),
        .pressing(pressing),
        .alive(alive),
        .toggle(toggle),
        .state_monsters(state_monsters),
        .score_pulse(score_pulse)
    );

    // Generate hero state asynchronously
    Hero_state hero_state(
        .clk(clk_game),
        .btn(btn_stable),
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
        alive,
        clk_vga,
        clk_pace,
        clk_game,
        data_bg,
        data_hero_main_0,
        data_hero_main_1,
        data_hero_up,
        data_hero_down,
        data_hero_left,
        data_hero_right,
        data_monster_up_0,
        data_monster_up_1,
        data_monster_down_0,
        data_monster_down_1,
        data_monster_left_0,
        data_monster_left_1,
        data_monster_right_0,
        data_monster_right_1,
        addr_bg,
        addr_hero,
        addr_monster,
        state_monsters,
        state_hero,
        x_ptr,
        y_ptr,
        pressing,
        RGB
    );

    // Draw given color to VGA
    VGA_render render(valid, RGB, vga_R, vga_G, vga_B);

    // Background IP core
    BG bg(.clka(clk_vga), .addra(addr_bg), .douta(data_bg));

    // Hero related IP cores
    Hero_main_0 hero_main_0(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_main_0));
    Hero_main_1 hero_main_1(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_main_1));
    Hero_up hero_up(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_up));
    Hero_down hero_down(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_down));
    Hero_left hero_left(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_left));
    Hero_right hero_right(.clka(clk_vga), .addra(addr_hero), .douta(data_hero_right));

    // Monster related IP cores
    Monster_up_0 monster_up_0(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_up_0));
    Monster_up_1 monster_up_1(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_up_1));
    Monster_down_0 monster_down_0(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_down_0));
    Monster_down_1 monster_down_1(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_down_1));
    Monster_left_0 monster_left_0(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_left_0));
    Monster_left_1 monster_left_1(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_left_1));
    Monster_right_0 monster_right_0(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_right_0));
    Monster_right_1 monster_right_1(.clka(clk_vga), .addra(addr_monster), .douta(data_monster_right_1));

endmodule
