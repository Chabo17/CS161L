//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Alex Nguyen Chandler Bottomley
// Email: anguy258@ucr.edu cbott001@ucr.edu
// 
// Assignment name: Lab 3 - Datapath Control Units
// Lab section: 021
// TA: Sakib Malek
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module lab03_tb;

	// Inputs
	reg [5:0] instr_op;
	reg [5:0] instruction_5_0;

	// Outputs
	wire reg_dst;
	wire branch;
	wire mem_read;
	wire mem_to_reg;
	wire [1:0] alu_op;
	wire mem_write;
	wire alu_src;
	wire reg_write;
	wire [3:0] alu_out;

	// Instantiate the Unit Under Test (UUT)
	controlUnit uut (
		.instr_op(instr_op), 
		.reg_dst(reg_dst), 
		.branch(branch), 
		.mem_read(mem_read), 
		.mem_to_reg(mem_to_reg), 
		.alu_op(alu_op), 
		.mem_write(mem_write), 
		.alu_src(alu_src), 
		.reg_write(reg_write)
	);
	
	aluControlUnit aluctrl (
		.alu_op(alu_op),
		.instruction_5_0(instruction_5_0),
		.alu_out(alu_out)
	);
	
	initial begin
		// Initialize Inputs
		instr_op = 6'b000000;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		// Testing Load Word (lw)
		instr_op = 6'b100011;
		instruction_5_0 = 6'bxxxxxx;
		
		#100	// Wait for inputs
		
		$display("Testing Load Word:");
		
		if (reg_dst != 1'b0) $display("reg_dst FAIL");
		if (alu_src != 1'b1) $display("alu_src FAIL");
		if (mem_to_reg != 1'b1) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b1) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b00) $display("alu_op FAIL");
		if (alu_out != 4'b0010) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing Store Word (sw)
		instr_op = 6'b101011;
		instruction_5_0 = 6'bxxxxxx;
		
		#100	// Wait for inputs
		
		$display("Testing Store Word:");
		
		if (alu_src != 1'b1) $display("alu_src FAIL");
		if (reg_write != 1'b0) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b1) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b00) $display("alu_op FAIL");
		if (alu_out != 4'b0010) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing Branch Equal (beq)
		instr_op = 6'b000100;
		instruction_5_0 = 6'bxxxxxx;
		
		#100	// Wait for inputs
		
		$display("Testing Branch Equal:");
		
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (reg_write != 1'b0) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b1) $display("branch FAIL");
		if (alu_op != 2'b01) $display("alu_op FAIL");
		if (alu_out != 4'b0110) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (add)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx0000;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (add):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b0010) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (sub)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx0010;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (sub):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b0110) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (AND)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx0100;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (AND):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b0000) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (OR)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx0101;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (OR):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b0001) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (NOR)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx0111;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (NOR):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b1100) $display("alu_out FAIL");
		
		#100 // Wait for outputs before loading in new input
		
		// Testing R-Format (SLT)
		instr_op = 6'b000000;
		instruction_5_0 = 6'bxx1010;
		
		#100	// Wait for inputs
		
		$display("Testing R-Format (SLT):");
		
		if (reg_dst != 1'b1) $display("reg_dst FAIL");
		if (alu_src != 1'b0) $display("alu_src FAIL");
		if (mem_to_reg != 1'b0) $display("mem_to_reg FAIL");
		if (reg_write != 1'b1) $display("reg_write FAIL");
		if (mem_read != 1'b0) $display("mem_read FAIL");
		if (mem_write != 1'b0) $display("mem_write FAIL");
		if (branch != 1'b0) $display("branch FAIL");
		if (alu_op != 2'b1x) $display("alu_op FAIL");
		
		if (alu_out != 4'b0111) $display("alu_out FAIL");
		
	end
      
endmodule