module Seven_seg(scanning, score, segment, an);

    input wire [1: 0] scanning;
    input wire [15: 0] score;
    output wire [7: 0] segment;
    output wire [3: 0] an;

    reg [3: 0] digit, anode;
    reg [7: 0] digit_seg;

    assign segment[7: 0] = digit_seg;
    assign an = anode;

    always @* begin
        anode <= 4'b1111;
        case (scanning)
            0: anode <= 4'b1110;
            1: anode <= 4'b1101;
            2: anode <= 4'b1011;
            3: anode <= 4'b0111;
        endcase
    end

    always @* begin
        case (scanning)
            0: digit <= score[3: 0];
            1: digit <= score[7: 4];
            2: digit <= score[11: 8];
            3: digit <= score[15: 12];
        endcase
    end

   always @* begin
        case (digit)
            4'b0000: digit_seg <= 8'b11000000;
            4'b0001: digit_seg <= 8'b11111001;
            4'b0010: digit_seg <= 8'b10100100;
            4'b0011: digit_seg <= 8'b10110000;
            4'b0100: digit_seg <= 8'b10011001;
            4'b0101: digit_seg <= 8'b10010010;
            4'b0110: digit_seg <= 8'b10000010;
            4'b0111: digit_seg <= 8'b11111000;
            4'b1000: digit_seg <= 8'b10000000;
            4'b1001: digit_seg <= 8'b10010000;
        endcase
    end

endmodule
