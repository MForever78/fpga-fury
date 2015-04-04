module Score_counter(alive, score_pulse, score);

    input wire alive;
    input wire [11: 0] score_pulse;
    output reg [15: 0] score;

    wire pulse;

    initial score = 0;

    assign pulse = |score_pulse;

    always @(posedge pulse or negedge alive) begin
        if (!alive) begin
            score <= 0;
        end else begin
            if (score[3: 0] == 9) begin
                score[3: 0] <= 0;
                if (score[7: 4] == 9) begin
                    score[7: 4] <= 0;
                    if (score[11: 8] == 9) begin
                        score[11: 8] <= 0;
                        if (score[15: 12] == 9)
                            score[15: 12] <= 0;
                        else
                            score[15: 12] <= score[15: 12] + 1;
                    end else
                        score[11: 8] <= score[11: 8] + 1;
                end else
                    score[7: 4] <= score[7: 4] + 1;
            end else
                score[3: 0] <= score[3: 0] + 1;
        end
    end

endmodule
