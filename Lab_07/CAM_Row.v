`timescale 1ns / 1ps

module CAM_Row # (parameter CAM_WIDTH = 8, CAM_TYPE = "BCAM") (
    input wire clk,
    input wire rst,
    input wire we,
    input wire[CAM_WIDTH-1:0] search_word,
    input wire[CAM_WIDTH-1:0] dont_care_mask,
    output wire row_match
    );

wire [CAM_WIDTH:0] row_result;
assign row_result[0] = 1;

genvar i;

generate
    for (i = 0; i < CAM_WIDTH; i = i + 1) begin : block
        if (CAM_TYPE == "TCAM") begin
            TCAM_Cell cam (
                .clk(clk),
                .rst(rst),
                .we(we),
                .cell_search_bit(search_word[i]),
                .cell_dont_care_bit(dont_care_mask[i]),
                .cell_match_bit_in(row_result[i]),
                .cell_match_bit_out(row_result[i+1])
            );
            
        end else if (CAM_TYPE == "STCAM") begin
            STCAM_Cell cam (
                .clk(clk),
                .rst(rst),
                .we(we),
                .cell_search_bit(search_word[i]),
                .cell_dont_care_bit(dont_care_mask[i]),
                .cell_match_bit_in(row_result[i]),
                .cell_match_bit_out(row_result[i+1])
            );

        end else begin
            BCAM_Cell cam (
                .clk(clk),
                .rst(rst),
                .we(we),
                .cell_search_bit(search_word[i]),
                .cell_dont_care_bit(dont_care_mask[i]),
                .cell_match_bit_in(row_result[i]),
                .cell_match_bit_out(row_result[i+1])
            );
        end
    end
endgenerate

assign row_match = row_result[CAM_WIDTH];

endmodule
