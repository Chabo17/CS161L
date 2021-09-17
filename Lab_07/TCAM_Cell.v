//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Alex Nguyen Chandler Bottomley
// Email: anguy258@ucr.edu cbott001@ucr.edu
// 
// Assignment name: 
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module TCAM_Cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire cell_search_bit,
    input wire cell_dont_care_bit,
    input wire cell_match_bit_in,
    output wire cell_match_bit_out
);

reg stored_bit;
	 
always @(posedge clk) begin
    if (rst) begin
        stored_bit <= 0;
    end

    if (we && !rst) begin
        stored_bit <= cell_search_bit;
    end
end

//assign cell_match_bit_out = (cell_match_bit_in && (cell_search_bit == stored_bit)) || cell_dont_care_bit ? 1 : 0;
assign cell_match_bit_out = (cell_dont_care_bit || (cell_search_bit == stored_bit)) && cell_match_bit_in;

endmodule
