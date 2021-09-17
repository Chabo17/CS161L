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

module processor_tb;

// Inputs
reg clk;
reg rst;

// Outputs
wire [31:0] prog_count;
wire [5:0] instr_opcode;
wire [4:0] reg1_addr;
wire [31:0] reg1_data;
wire [4:0] reg2_addr;
wire [31:0] reg2_data;
wire [4:0] write_reg_addr;
wire [31:0] write_reg_data;

processor #(.MEM_FILE("program.coe")) uut (
    .clk(clk),
    .rst(rst),
    .prog_count(prog_count),
    .instr_opcode(instr_opcode),
    .reg1_addr(reg1_addr),
    .reg1_data(reg1_data),
    .reg2_addr(reg2_addr),
    .reg2_data(reg2_data),
    .write_reg_addr(write_reg_addr),
    .write_reg_data(write_reg_data)
);
  
initial begin 
    clk = 0; rst = 1; #50; 
    clk = 1; rst = 1; #50; 
    clk = 0; rst = 0; 
         
    forever begin 
        #5 clk = ~clk;
    end 
end 

reg[31:0] result;
reg[31:0] expected;
integer last_instruction; 
integer passedTests = 0;
integer totalTests = 0;
initial begin
    /* Testing an entire program... last_instruction is the PC of the last instruction to execute */
    /*wait (prog_count == last_instruction)
    result = write_reg_data;
    $write("Test Case 1: (init.coe)...");
    totalTests = totalTests + 1;
    expected = 172;
    if (result == expected) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed. Expected %0d but got %0d",expected,result);
    end*/

   /* Individual tests... Check the result after each instruction */
    @(negedge rst); // Wait for reset
    @(posedge clk); // Skip LW instruction

    @(posedge clk); #1; 
    totalTests = totalTests + 1;
    $write("Test Case %0d: and $t0, $v0, $v1...", totalTests);
    if (write_reg_addr === 8 && write_reg_data === -1600085856) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end

    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $t0, $t0, $t0...", totalTests);
    if (write_reg_addr === 8 && write_reg_data === 1600085855) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $t1, $v0, $v0...", totalTests);
    if (write_reg_addr === 9 && write_reg_data === 1431655765) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $t2, $v1, $v1...", totalTests);
    if (write_reg_addr === 10 && write_reg_data === 252645135) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end

    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: or  $t3, $t1, $t2...", totalTests);
    if (write_reg_addr === 11 && write_reg_data === 1600085855) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: slt $s0, $t0, $t3...", totalTests);
    if (write_reg_addr === 16 && write_reg_data === 0) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end

    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: slt $s1, $t3, $t0...", totalTests);
    if (write_reg_addr === 17 && write_reg_data === 0) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: or  $t4, $v0, $v1...", totalTests);
    if (write_reg_addr === 12 && write_reg_data === -84215046) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $t4, $t4, $t4...", totalTests);
    if (write_reg_addr === 12 && write_reg_data === 84215045) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: and $t5, $t1, $t2...", totalTests);
    if (write_reg_addr === 13 && write_reg_data === 84215045) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: slt $s2, $t4, $t5...", totalTests);
    if (write_reg_addr === 18 && write_reg_data === 0) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: slt $s3, $t5, $t4...", totalTests);
    if (write_reg_addr === 19 && write_reg_data === 0) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $a0, $s0, $s1...", totalTests);
    if (write_reg_addr === 4 && write_reg_data === -1) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("Test Case %0d: nor $a1, $s2, $s3...", totalTests);
    if (write_reg_addr === 5 && write_reg_data === -1) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end
    
    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $write("FINAL Test Case %0d: and $a2, $a0, $a1...", totalTests);
    if (write_reg_addr === 6 && write_reg_data === -1) begin
        passedTests = passedTests + 1;
        $display("passed.");
    end else begin
        $display("failed.");
    end

    $display("------------------------------------------------------------------");
    $display("Testing complete\nPassed %0d / %0d tests.",passedTests,totalTests);
    $display("------------------------------------------------------------------");
    $finish();
end
endmodule