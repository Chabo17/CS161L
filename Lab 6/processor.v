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
`include "cpu_constant_library.v"

module processor #(parameter WORD_SIZE=32,MEM_FILE="initlab5.coe") (
    input clk,
    input rst,   
	 // Debug signals 
    output reg [WORD_SIZE-1:0] prog_count, 
    output reg [5:0] instr_opcode,
    output reg [4:0] reg1_addr,
    output reg [WORD_SIZE-1:0] reg1_data,
    output reg [4:0] reg2_addr,
    output reg [WORD_SIZE-1:0] reg2_data,
    output reg [4:0] write_reg_addr,
    output reg [WORD_SIZE-1:0] write_reg_data 
);

// ----------------------------------------------
// Insert solution below here
// ----------------------------------------------

wire [WORD_SIZE-1:0] pc_in, pc_out, pc_add_4, instr, read_data1, read_data2, mem_data, reg_write_data, pc_offset, alusrc_mux, alu_result, branch_addr, imme;
wire [4:0] write_reg, write_reg1, write_reg2;
wire [1:0] alu_op;
wire [3:0] alu_out;
wire reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, zero;

//IFID
wire [31:0] IFID_instr, IFID_pc_add_4;

//IDEX
wire IDEX_mem_to_reg, IDEX_reg_write, IDEX_branch, IDEX_mem_write, IDEX_mem_read, IDEX_alu_src, IDEX_reg_dst;
wire [31:0] IDEX_pc_add_4, IDEX_read_data1, IDEX_read_data2, IDEX_imme;
wire [4:0] IDEX_write_reg1, IDEX_write_reg2;
wire [1:0] IDEX_alu_op;

//EXMEM
wire EXMEM_mem_to_reg, EXMEM_reg_write, EXMEM_branch, EXMEM_mem_write, EXMEM_mem_read, EXMEM_zero;
wire [31:0] EXMEM_read_data2, EXMEM_alu_result, EXMEM_branch_addr;
wire [4:0] EXMEM_write_reg;

//MEMWB
wire MEMWB_mem_to_reg, MEMWB_reg_write;
wire [31:0] MEMWB_mem_data, MEMWB_alu_result;
wire [4:0] MEMWB_write_reg;

assign write_reg1 = instr[20:16];
assign write_reg2 = instr[15:11];
assign imme = {{16{IFID_instr[15]}}, IFID_instr[15:0]};
assign branch_zero = EXMEM_zero & EXMEM_branch;

gen_register PC(
    .clk(clk),
    .rst(rst),
    .write_en(1'b1),
    .data_in(pc_in),
    .data_out(pc_out)
);

cpumemory #(.FILENAME(MEM_FILE)) instr_mem_data_mem(
    .clk(clk),
    .rst(rst),
    .instr_read_address(pc_out[9:2]),
    .instr_instruction(instr),
    .data_mem_write(EXMEM_mem_write),
    .data_address(EXMEM_alu_result[7:0]),
    .data_write_data(EXMEM_read_data2),
    .data_read_data(mem_data)
);

assign pc_add_4 = pc_out + 4;
// alu pc_add(
//     .alu_control_in(`ALU_ADD),
//     .channel_a_in(pc_out),
//     .channel_b_in(4),
//     .alu_result_out(pc_add_4)
// );

control_unit control_unit(
    .instr_op(IFID_instr[31:26]),
    .reg_dst(reg_dst),
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write)
);

mux_2_1 #(.WORD_SIZE(5)) mux_reg_dst(
    .select_in(IDEX_reg_dst),
    .datain1(IDEX_write_reg1),
    .datain2(IDEX_write_reg2),
    .data_out(write_reg)
);

cpu_registers Register(
    .clk(clk),
    .rst(rst),
    .reg_write(MEMWB_reg_write),
    .read_register_1(IFID_instr[25:21]),
    .read_register_2(IFID_instr[20:16]),
    .write_register(MEMWB_write_reg[4:0]),
    .write_data(reg_write_data),
    .read_data_1(read_data1),
    .read_data_2(read_data2)
);

mux_2_1 mux_alusrc(
    .select_in(IDEX_alu_src),
    .datain1(IDEX_read_data2),
    .datain2(IDEX_imme),
    .data_out(alusrc_mux)
);

alu_control alu_control(
    .alu_op(IDEX_alu_op),
    .instruction_5_0(IDEX_imme[5:0]),
    .alu_out(alu_out)
);

alu alu(
    .alu_control_in(alu_out),
    .channel_a_in(IDEX_read_data1),
    .channel_b_in(alusrc_mux),
    .zero_out(zero),
    .alu_result_out(alu_result)
);

alu alu_branch(
    .alu_control_in(`ALU_ADD),
    .channel_a_in(IDEX_pc_add_4),
    .channel_b_in(IDEX_imme),
    .alu_result_out(branch_addr)
);

mux_2_1 mux_branch(
    .select_in(branch_zero),
    .datain1(pc_add_4),
    .datain2(EXMEM_branch_addr),
    .data_out(pc_in)
);

mux_2_1 mux_to_reg(
    .select_in(MEMWB_mem_to_reg),
    .datain1(MEMWB_alu_result),
    .datain2(MEMWB_mem_data),
    .data_out(reg_write_data)
);

//IFID
gen_register #(.WORD_SIZE(32)) ifid_pc_add_4(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(pc_add_4), .data_out(IFID_pc_add_4));
gen_register #(.WORD_SIZE(32)) ifid_instr(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(instr), .data_out(IFID_instr));

//IDEX
gen_register #(.WORD_SIZE(1)) idex_branch(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(branch), .data_out(IDEX_branch));

gen_register #(.WORD_SIZE(1)) idex_mem_to_reg(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(mem_to_reg), .data_out(IDEX_mem_to_reg));
gen_register #(.WORD_SIZE(1)) idex_reg_write(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(reg_write), .data_out(IDEX_reg_write));
gen_register #(.WORD_SIZE(1)) idex_mem_write(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(mem_write), .data_out(IDEX_mem_write));
gen_register #(.WORD_SIZE(1)) idex_mem_read(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(mem_read), .data_out(IDEX_mem_read));
gen_register #(.WORD_SIZE(1)) idex_alu_src(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(alu_src), .data_out(IDEX_alu_src));
gen_register #(.WORD_SIZE(2)) idex_alu_op(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(alu_op), .data_out(IDEX_alu_op));
gen_register #(.WORD_SIZE(1)) idex_reg_dst(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(reg_dst), .data_out(IDEX_reg_dst));
gen_register #(.WORD_SIZE(32)) idex_pc_add_4(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IFID_pc_add_4), .data_out(IDEX_pc_add_4));
gen_register #(.WORD_SIZE(32)) idex_read_data1(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(read_data1), .data_out(IDEX_read_data1));
gen_register #(.WORD_SIZE(32)) idex_read_data2(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(read_data2), .data_out(IDEX_read_data2));
gen_register #(.WORD_SIZE(32)) idex_imme(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(imme), .data_out(IDEX_imme));
gen_register #(.WORD_SIZE(5)) idex_write_reg1(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IFID_instr[20:16]), .data_out(IDEX_write_reg1));
gen_register #(.WORD_SIZE(5)) idex_write_reg2(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IFID_instr[15:11]), .data_out(IDEX_write_reg2));

//EXMEM
gen_register #(.WORD_SIZE(1)) exmem_branch(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_branch), .data_out(EXMEM_branch));

gen_register #(.WORD_SIZE(1)) exmem_mem_to_reg(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_mem_to_reg), .data_out(EXMEM_mem_to_reg));
gen_register #(.WORD_SIZE(1)) exmem_reg_write(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_reg_write), .data_out(EXMEM_reg_write));
gen_register #(.WORD_SIZE(1)) exmem_mem_write(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_mem_write), .data_out(EXMEM_mem_write));
gen_register #(.WORD_SIZE(1)) exmem_mem_read(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_mem_read), .data_out(EXMEM_mem_read));
gen_register #(.WORD_SIZE(1)) exmem_zero(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(zero), .data_out(EXMEM_zero));
gen_register #(.WORD_SIZE(5)) exmem_write_reg(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(write_reg), .data_out(EXMEM_write_reg));
gen_register #(.WORD_SIZE(32)) exmem_read_data2(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(IDEX_read_data2), .data_out(EXMEM_read_data2));
gen_register #(.WORD_SIZE(32)) exmem_alu_result(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(alu_result), .data_out(EXMEM_alu_result));
gen_register #(.WORD_SIZE(32)) exmem_branch_addr(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(branch_addr), .data_out(EXMEM_branch_addr));

//MEMWB
gen_register #(.WORD_SIZE(1)) memwb_mem_to_reg(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(EXMEM_mem_to_reg), .data_out(MEMWB_mem_to_reg));
gen_register #(.WORD_SIZE(1)) memwb_reg_write(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(EXMEM_reg_write), .data_out(MEMWB_reg_write));
gen_register #(.WORD_SIZE(32)) memwb_mem_data(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(mem_data), .data_out(MEMWB_mem_data));
gen_register #(.WORD_SIZE(32)) memwb_alu_result(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(EXMEM_alu_result), .data_out(MEMWB_alu_result));
gen_register #(.WORD_SIZE(5)) memwb_write_reg(.clk(clk), .rst(rst), .write_en(1'b1), .data_in(EXMEM_write_reg), .data_out(MEMWB_write_reg));

always @(*) begin
    prog_count <= {pc_out[31:2], 2'b00} + 4;
    instr_opcode <= IFID_instr[31:26];
    reg1_addr <= instr[25:21];
    reg1_data <= read_data1;
    reg2_addr <= instr[20:16];
    reg2_data <= read_data2;
    write_reg_addr <= MEMWB_write_reg[4:0];
    write_reg_data <= reg_write_data;    
end

endmodule
