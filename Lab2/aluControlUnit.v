//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Chandler Bottomley Alex Nguyen 
// Email: cbott001@ucr.edu anguy258@ucr.eduu
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

module aluControlUnit  (
    input wire [1:0] alu_op , 
    input wire [5:0] instruction_5_0 , 
    output reg [3:0] alu_out  
    );

// ------------------------------
// Insert your solution below
// ------------------------------ 
always @(*)begin
	case(alu_op) 
	
	2'b00: alu_out = 4'b0010;//LW + SW
	2'b01: alu_out = 4'b0110;// Branch equal
	2'b11: alu_out = 4'b0110;// Branch equal
	
	2'b10: 
		case(instruction_5_0) 
			6'b100000 : alu_out = 4'b0010;//add
			6'b100001 : alu_out = 4'b0010;//addu
			6'b100010 : alu_out = 4'b0110;//sub
			6'b100100 : alu_out = 4'b0000;//AND
			6'b100101 : alu_out = 4'b0001;//OR
			6'b100111 : alu_out = 4'b1100;//NOR
			6'b101010 : alu_out = 4'b0111;//set on less than
			
		endcase
	endcase
	end
endmodule

