module Debouncer(clk, btn, btn_stable, power, power_stable);

    input wire clk, power;
    input wire [3: 0] btn;
    output wire [3: 0] btn_stable;
    output wire power_stable;

    wire [4: 0] btns;
    reg [31: 0] cnt;
    reg [4: 0] btns_temp;
    reg [4: 0] btns_stable;

    assign btns = {power, btn};
    assign btn_stable = btns_stable[3: 0];
    assign power_stable = btns_stable[4];

    always @(posedge clk) begin
        btns_temp <= btns;
        if (btns != btns_temp) begin
            cnt <= 0;
        end else begin
            if (cnt == 233333) begin
                btns_stable <= btns;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule
