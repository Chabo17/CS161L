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

module aluControlUnit (
    input  wire [1:0] alu_op, 
    input  wire [5:0] instruction_5_0, 
    output wire [3:0] alu_out
    );
	 
reg t_alu_out = 4'b0111;

always @(*)begin
	case(alu_op) 
	
	2'b00: begin t_alu_out = 4'b0010; end//LW + SW
	2'b01: begin t_alu_out = 4'b0110; end// Branch equal
	2'b11: begin t_alu_out = 4'b0110; end// Branch equal
	
	2'b10: 
		case(instruction_5_0) 
			6'b100000 : begin  t_alu_out = 4'b0010; end//add
			6'b100001 : begin t_alu_out = 4'b0010; end//addu
			6'b100010 : begin t_alu_out = 4'b0110; end//sub
			6'b100100 : begin t_alu_out = 4'b0000; end//AND
			6'b100101 : begin t_alu_out = 4'b0001; end//OR
			6'b100111 : begin t_alu_out = 4'b1100; end//NOR
			6'b101010 : begin t_alu_out = 4'b0111; end//set on less than
			
		endcase
	endcase
	
end 
	
assign alu_out = t_alu_out;

endmodule
