`timescale 1ns / 1ps

module IsolationTreeStateMachine_tb;

// Inputs
reg clk;
reg reset;
reg [7:0] data_input;
reg data_valid;

// Output
wire anomaly_detected;

// Instantiate the Unit Under Test (UUT)
IsolationTreeStateMachine uut (
    .clk(clk), 
    .reset(reset), 
    .data_input(data_input), 
    .data_valid(data_valid), 
    .anomaly_detected(anomaly_detected)
);

initial begin
    // Initialize Inputs
    clk = 0;
    reset = 0;
    data_input = 0;
    data_valid = 0;
  	$dumpfile("dump.vcd");
  	$dumpvars;

    // Wait 100 ns for global reset to finish
    #100;
    
    // Add stimulus here
    reset = 1; // Release reset
    #20;
    
    // Test Case 1: Non-matching data input
    data_input = 8'h55; // Non-matching value
    data_valid = 1;
    #10; // Wait for a clock cycle
    data_valid = 0;
    #10;
    
    // Test Case 2: Matching data input
    data_input = 8'hAB; // Matching value
    data_valid = 1;
    #10; // Wait for a clock cycle
    data_valid = 0;
    #10;
    
    // Test Case 3: Another non-matching data input
    data_input = 8'hFF; // Non-matching value
    data_valid = 1;
    #10; // Wait for a clock cycle
    data_valid = 0;
    #10;
    
    // Test Case 4: Reset during operation
    data_input = 8'hAB; // Matching value
    data_valid = 1;
    #5; // Midway through operation
    reset = 0; // Assert reset
    #10;
    reset = 1; // Release reset
    data_valid = 0;
    #10;
    
    $finish;
end

// Clock generation
always #5 clk = ~clk;

endmodule