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

module controlUnit  (
    input wire [5:0]  instr_op , 
    output reg reg_dst      ,   
    output reg  branch    ,     
    output reg  mem_read ,  
    output reg  mem_to_reg  ,
    output reg [1:0]  alu_op  ,        
    output reg  mem_write  , 
    output reg  alu_src     ,    
    output reg  reg_write   
    );

// ------------------------------
// Insert your solution below
// ------------------------------ 

always@(*) begin

case(instr_op)
	6'b000000://Rformat
	begin
		reg_dst = 1'b1;
		alu_src = 1'b0;
		mem_to_reg = 1'b0;
		reg_write = 1'b1;
		mem_read = 1'b0;
		mem_write = 1'b0;
		branch = 1'b0;
		alu_op = 2'b10;
	end
		
	6'b100011://lw
	begin
		reg_dst = 1'b0;
		alu_src = 1'b1;
		mem_to_reg = 1'b1;
		reg_write = 1'b1;
		mem_read = 1'b1;
		mem_write = 1'b0;
		branch = 1'b0;
		alu_op = 2'b00;
	end
	
	6'b101011://sw
	begin
		//reg_dist = 1'b0;
		alu_src = 1'b1;
		//mem_to_reg = 1'b0;
		reg_write = 1'b0;
		mem_read = 1'b0;
		mem_write = 1'b1;
		branch = 1'b0;
		alu_op = 2'b00;
	end
	
	6'b000100://beq
	begin
		//reg_dist = 1'b1;
		alu_src = 1'b0;
		//mem_to_reg = 1'b0;
		reg_write = 1'b0;
		mem_read = 1'b0;
		mem_write = 1'b0;
		branch = 1'b1;
		alu_op = 2'b01;
	end
	
	6'b001000://addi
	begin
		reg_dst = 1'b1;
		alu_src = 1'b1;
		mem_to_reg = 1'b0;
		reg_write = 1'b1;
		mem_read = 1'b0;
		mem_write = 1'b0;
		branch = 1'b0;
		alu_op = 2'b10;
	end
	endcase
	end
endmodule
