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

`define CAM_DEPTH 8
`define CAM_WIDTH 8

module CAM_Wrapper_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [`CAM_DEPTH-1:0] we_decoded_row_address;
    reg [`CAM_WIDTH-1:0] search_word;
    reg [`CAM_WIDTH-1:0] dont_care_mask;

    // Outputs
    wire [`CAM_DEPTH-1:0] decoded_match_address_BCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_TCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_STCAM;

    // Instantiate the Unit Under Test (UUT)
    // Notice all three uut's (uut, uut2, uut3) share all inputs and only differ on their output
    // You can differ all inputs and outputs if desired, but "sufficient" testing can be done 
    // by just checking the outputs and keeping all stored data the same.
    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("BCAM")) uut1 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_BCAM)
    );

    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("TCAM")) uut2 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(8'h55), 
        .decoded_match_address(decoded_match_address_TCAM)
    );
   
    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("STCAM")) uut3 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_STCAM)
    );

    // Clock block 
    initial begin 
        clk = 0; rst = 1; #10;
        clk = 1; rst = 1; #10;
        clk = 0; rst = 0; #10;
        clk = 1; rst = 0; #10;

        forever begin 
            clk = ~clk; #10;
        end 
    end

    integer totalTests = 0;
    integer testGroup = 0;
    integer testNumber = 0;
    integer passedTests = 0;
   
    initial begin
        @(negedge rst); // Wait for rst to be released
        @(posedge clk); // Wait for first clk high out of rst
        // *****************************************************
        // First, write the values (address one example shown)
        // *****************************************************
        //     addr|  search   | don't care (stored)
        //      1  | 0000 0001 | 0000 0000
        //      2  | 0101 0101 | 0000 0000
        //      3  | 1101 1011 | 0000 0000
        //      4  | 0110 0000 | 0000 0110
        //         |           |
        //      5  | 1110 0000 | 0110 1010
        //      6  | 0010 0110 | 0100 0010
        //      7  | 1001 1001 | 1000 1001
        //      8  | 0001 1000 | 1000 1001
        // -------------------------------------------------------
        we_decoded_row_address = 8'h01;
        search_word = 8'h01; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h02;
        search_word = 8'h55; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)
        
        we_decoded_row_address = 8'h03;
        search_word = 8'hdb; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h04;
        search_word = 8'h60; 
        dont_care_mask = 8'h06; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h05;
        search_word = 8'he0; 
        dont_care_mask = 8'h6a; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h06;
        search_word = 8'h26; 
        dont_care_mask = 8'h42; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h07;
        search_word = 8'h99; 
        dont_care_mask = 8'h89; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)

        we_decoded_row_address = 8'h08;
        search_word = 8'h18; 
        dont_care_mask = 8'h89; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)
        
        // ... Change the dont_care_mask to store "don't care" bits for STCAM
        
        we_decoded_row_address  = 8'h00; // No longer writing to addresses
        dont_care_mask = 8'h00; 
        //*********************************************************
        // Test cases
        //*********************************************************

        /*--------------------------BCAM--------------------------*/
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (0000 0001 => 0000 0001)...", testGroup,testNumber);
        search_word  = 8'h01; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h01) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (0101 0101 => 0000 0010)...", testGroup,testNumber);
        search_word  = 8'h55; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h02) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (1101 1011 => 0000 0011)...", testGroup,testNumber);
        search_word  = 8'hdb; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (1110 0000 => 0000 0101)...", testGroup,testNumber);
        search_word  = 8'he0; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h05) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (0001 1000 => 0000 1000)...", testGroup,testNumber);
        search_word  = 8'h18; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h08) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (1111 1111 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'hff; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (1110 0111 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'he7; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (0000 0000 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'h00; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        /*-------------------------STCAM--------------------------*/
        testGroup = testGroup + 1;
        $display("Test Group %0d: STCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (0000 0001 => 0000 0001)...", testGroup,testNumber);
        search_word  = 8'h01; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h01) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (1101 1011 => 0000 0011)...", testGroup,testNumber);
        search_word  = 8'hdb; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (0110 0000 => 0000 0100)...", testGroup,testNumber);
        search_word  = 8'h66; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h04) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (1010 1010 => 0000 0101)...", testGroup,testNumber);
        search_word  = 8'haa; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h05) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (1111 1111 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'hff; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (STCAM)  (0000 0000 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'h00; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_STCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        /*--------------------------TCAM--------------------------*/
        // Hard-coded "dont care" as 8'h55 or 0101 0101
        testGroup = testGroup + 1;
        $display("Test Group %0d: TCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (0000 0001 => 0000 0001)...", testGroup,testNumber);
        search_word  = 8'h01; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h01) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (1101 1011 => 0000 0011)...", testGroup,testNumber);
        search_word  = 8'hdb; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (1111 0000 => 0000 0101)...", testGroup,testNumber);
        search_word  = 8'hf0; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h05) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (1100 1100 => 0000 0011)...", testGroup,testNumber);
        search_word  = 8'hcc; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h03) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end



        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (1111 1111 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'hff; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (0000 0010 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'h02; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (TCAM)  (0000 0000 => 0000 0001)...", testGroup,testNumber);
        search_word  = 8'h00; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_TCAM === 8'h01) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        // Change the dont_care_mask to test "don't care" input bits for TCAM

        // ****************************************************************
        // End testing 
        // ****************************************************************
        $display("-------------------------------------------------------------");
        $display("Testing complete\nPassed %0d / %0d tests.",passedTests,totalTests);
        $display("-------------------------------------------------------------");
        $finish();
    end
   
endmodule

