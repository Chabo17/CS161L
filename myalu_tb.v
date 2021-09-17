//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Chandler Bottomley
// Email: cbott001@ucr.edu
// 
// Assignment name: lab1 prelab
// Lab section: 021
// TA: Sakib Md
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module myalu_tb;
    parameter NUMBITS = 8;

    // Inputs
    reg clk;
    reg reset;
    reg [NUMBITS-1:0] A;
    reg [NUMBITS-1:0] B;
    reg [2:0] opcode;

    // Outputs
    wire [NUMBITS-1:0] result;
    reg [NUMBITS-1:0] R;
    wire carryout;
    wire overflow;
    wire zero;

    // -------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // -------------------------------------------------------
    myalu #(.NUMBITS(NUMBITS)) uut (
        .clk(clk),
        .reset(reset) ,  
        .A(A), 
        .B(B), 
        .opcode(opcode), 
        .result(result), 
        .carryout(carryout), 
        .overflow(overflow), 
        .zero(zero)
    );

      initial begin 
    
     clk = 0; reset = 1; #50; 
     clk = 1; reset = 1; #50; 
     clk = 0; reset = 0; #50; 
     clk = 1; reset = 0; #50; 
         
     forever begin 
        clk = ~clk; #50; 
     end 
     
    end 
    
    integer totalTests = 0;
    integer failedTests = 0;
    initial begin // Test suite
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        // Additional test cases
        // ---------------------------------------------
        // Testing unsigned additions 
        // --------------------------------------------- 
        $write("Test Group 1: Testing unsigned additions ... \n");
        opcode = 3'b000; 
        totalTests = totalTests + 1;
        $write("\tTest Case 1.1: Unsigned Add ... ");
        A = 8'hFF;
           B = 8'h01;
        R = 8'h00; 
        #100; // Wait 
        if (R != result || zero != 1'b1 || carryout != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait 
		  
		  // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 1.2: Unsigned Add adding with zero ");
        A = 8'h01;
           B = 8'h00;
        R = 8'h01; 
        #100; // Wait 
        if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait 
		  
		  // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 1.3: Unsigned Add adding two zeros without carryout ");
        A = 8'h00;
           B = 8'h00;
        R = 8'h00; 
        #100; // Wait 
        if (R != result || zero != 1'b1 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait 
		  
		  // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 1.4: Unsigned Add standard add");
        A = 8'h0F;
           B = 8'hF0;
        R = 8'hFF; 
        #100; // Wait 
        if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
        
		// Add more tests here

        // ---------------------------------------------
        // Testing unsigned subs 
        // --------------------------------------------- 
		  totalTests = totalTests + 1;
        $write("Test Group 2: Testing unsigned subs ...\n");
        opcode = 3'b010; 
		  
		  // -----------------------------------------------------------------
		  $write("\tTest Case 2.1: Unsigned subs standard subtraction");
		  A = 8'hFF;
		  B = 8'h0F;
		  R = 8'hF0;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed sub test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
        
		  // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 2.2: Unsigned subs subtracting zeros");
		  A = 8'hFF;
		  B = 8'h00;
		  R = 8'hFF;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed sub test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 2.3: Unsigned subs subtracting 2 zeros");
		  A = 8'h00;
		  B = 8'h00;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed sub test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 2.4: Unsigned subs testing carryout");
		  A = 8'h00;
		  B = 8'h01;
		  R = 8'h01;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b1) begin
				$write("failed sub test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 2.5: Unsigned subs testing only zero");
		  A = 8'h01;
		  B = 8'h01;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b1) begin
				$write("failed sub test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;

		

        // ---------------------------------------------
        // Testing signed adds 
        // --------------------------------------------- 
        $write("Test Group 3: Testing signed adds ...\n");
        opcode = 3'b001; 
		  
		 // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 3.1: signed add testing carryout");
		  A = 8'hFF;
		  B = 8'h01;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b1) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
					  
		 // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 3.2: signed add testing adding negative");
		  A = 8'h0F;
		  B = 8'hF0;
		  R = 8'hF1;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 3.3: signed add testing adding 2 positives");
		  A = 8'h0A;
		  B = 8'h01;
		  R = 8'h0B;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 3.4: signed add testing zero and overflow");
		  A = 8'hEF;
		  B = 8'h20;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b1) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 3.5: signed add testing");
		  A = 8'h05;
		  B = 8'h05;
		  R = 8'h0A;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;

		// Add more tests here

        // ---------------------------------------------
        // Testing signed subs 
        // --------------------------------------------- 
        $write("Test Group 4: Testing signed subs ...\n");
        opcode = 3'b011; 
		  
		 // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 4.1: signed sub testing");
		  A = 8'h06;
		  B = 8'h05;
		  R = 8'h01;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 4.2: signed sub testing zero");
		  A = 8'h06;
		  B = 8'h06;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
                
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 4.3: signed sub testing negative");
		  A = 8'h06;
		  B = 8'h07;
		  R = 8'hFF;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 4.4: signed sub testing carryover");
		  A = 8'hFF;
		  B = 8'h80;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b1) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
           

        // ---------------------------------------------
        // Testing ANDS 
        // --------------------------------------------- 
        $write("Test Group 5: Testing ANDs ...\n");
        opcode = 3'b100; 
                
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 5.1: Testing ANDS");
		  A = 8'hFF;
		  B = 8'h0F;
		  R = 8'h0F;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 5.2: Testing ANDS with zero");
		  A = 8'h00;
		  B = 8'h0F;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 5.3: Testing ANDS with zero");
		  A = 8'hFF;
		  B = 8'hF0;
		  R = 8'hF0;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;

        // ----------------------------------------
        // ORs 
        // ---------------------------------------- 
        $write("Test Group 6: Testing ORs ...\n");
        opcode = 3'b101; 
        
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 6.1: Testing ORs");
		  A = 8'h00;
		  B = 8'h0F;
		  R = 8'h0F;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
        
		  
		 // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 6.2: Testing ORs");
		  A = 8'hF0;
		  B = 8'h0F;
		  R = 8'hFF;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 6.3: Testing ORs with zeros");
		  A = 8'h00;
		  B = 8'h00;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
        // ----------------------------------------
        // XORs 
        // ---------------------------------------- 
        $write("Test Group 7: Testing XORs ...\n");
        opcode = 3'b110; 
        
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 7.1: Testing ORs");
		  A = 8'hF0;
		  B = 8'h0F;
		  R = 8'hFF;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 7.2: Testing ORs");
		  A = 8'hFF;
		  B = 8'hFF;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
        
		 // -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 7.3: Testing ORs");
		  A = 8'h01;
		  B = 8'h00;
		  R = 8'h01;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 7.4: Testing ORs");
		  A = 8'h03;
		  B = 8'h01;
		  R = 8'h02;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
			
        // ----------------------------------------
        // Div 2 
        // ----------------------------------------
        $write("Test Group 8: Testing DIV 2 ...\n");
        opcode = 3'b111; 
        
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 8.1: Testing ORs");
		  A = 8'h03;
		  R = 8'h02;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 8.2: Testing ORs");
		  A = 8'h01;
		  R = 8'h00;
		  #100;
		  
		  if(R!= result || zero != 1'b1 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;
			
		// -----------------------------------------------------------------
		  totalTests = totalTests + 1;
		  $write("\tTest Case 8.2: Testing ORs");
		  A = 8'hFF;
		  R = 8'hEF;
		  #100;
		  
		  if(R!= result || zero != 1'b0 || carryout != 1'b0) begin
				$write("failed signed add test 1\n");
				failedTest = failedTests + 1;
			end else begin
				$write("passed\n");
			end
			#10;

        // -------------------------------------------------------
        // End testing
        // -------------------------------------------------------
        $write("\n-------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests", totalTests-failedTests,totalTests);
        $write("\n-------------------------------------------------------");
    end
endmodule
