//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Chandler Bottomley
// Email: cbott001@ucr.edu
// 
// Assignment name: 
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
// Chandler Bottomeley
//=========================================================================

`timescale 1ns / 1ps

//  Constant definitions 

module myalu # ( parameter NUMBITS = 16 ) (
    input wire clk, 
    input wire reset ,  
    input  wire[NUMBITS-1:0] A, 
    input  wire[NUMBITS-1:0] B, 
    input wire [2:0]opcode, 
    output reg [NUMBITS-1:0] result,  
    output reg carryout ,
    output reg overflow , 
    output reg zero  );

// ------------------------------
// Insert your solution below
// ------------------------------ 

always@(*) begin

	case(opcode)
		3'b000: //unsigned add
		begin 
			result = A+B;
			overflow = 'd0;
			{carryout,result} = {1'b0,A} + {1'b0,B};
		end
		
		3'b001: //signed add
		begin
			result = $signed(A) + $signed(B);
			carryout = 'd0;
			overflow = 1'b0;
			if(($signed(A) < 0) && ($signed(B) <0) && ($signed(result) >= 0)) begin
				overflow = 1'b1;
			end
			else if(($signed(A) >= 0) && ($signed(B) >= 0) && ($signed(result) < 0)) begin
				overflow = 1'b1;
			end
		end
		
		3'b010: //unsigned subtract 
		begin 
			result = A - B;
			{carryout, result} = {1'b0, A} - {1'b0, B};
			carryout = 'd0;
			overflow = 1'b0;
			if( result > A) begin
			overflow = 1'b1;
			end
		end
		
		3'b011: //signed subtract 
		begin 
			result = $signed(A) - $signed(B);
			carryout = 'd0;
			overflow = 1'b0;
			if(($signed(A) >= 0) && ($signed(B) <0) && ($signed(result) < 0)) begin
				overflow = 1'b1;
			end
			else if(($signed(A) < 0) && ($signed(B) >= 0) && ($signed(result) >= 0)) begin
				overflow = 1'b1;
			end
		end
		
		3'b100: //bit wise AND 
		begin 
			result = A&B;
			overflow = 'd0;
			carryout = 'd0;
		end
		
		3'b101: //bit wise OR 
		begin 
			result = A|B;
			overflow = 'd0;
			carryout = 'd0;
		end
		
		3'b110: //bit wise XOR 
		begin 
			result = A^B;
			overflow = 'd0;
			carryout = 'd0;
		end
		
		3'b111: //Divide A by 2
		begin 
			result = A >> 1;
			overflow = 'd0;
			carryout = 'd0;
		end
		
		
	endcase
	
	if(result == {NUMBITS{1'b0}}) begin 
		zero <= 1'b1;
	end
	else begin
		zero <= 1'b0;
	end
	
	end

endmodule
