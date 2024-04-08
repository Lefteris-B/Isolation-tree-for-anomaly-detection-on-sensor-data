`timescale 1ns / 1ps

module IsolationTreeStateMachine_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] data_input;
    reg data_valid;
    
    // Outputs
    wire anomaly_detected;
    
    // Instantiate the Unit Under Test (UUT)
    IsolationTreeStateMachine uut (
        .clk(clk),
        .reset(reset),
        .data_input(data_input),
        .data_valid(data_valid),
        .anomaly_detected(anomaly_detected)
    );
    
    // Clock generation
    always #10 clk = ~clk; // Clock with period of 20ns
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        data_input = 0;
        data_valid = 0;
        
        // Reset the UUT
        #50;
        reset = 1;
        #20;
        
        // Test Case 1: Valid Data with no anomaly
        $display("Test Case 1: Valid Data with no anomaly");
        data_input = 8'b10101010; // Adjust according to your itree
        data_valid = 1;
        #20; // Wait for a clock cycle
        
        // Test Case 2: Valid Data leading to anomaly detection
        $display("Test Case 2: Valid Data leading to anomaly detection");
        data_input = 8'b11001100; // Adjust this value to simulate anomaly detection
        data_valid = 1;
        #20; // Wait for a clock cycle
        
        // Test Case 3: Invalid data when data_valid is low
        $display("Test Case 3: Invalid data when data_valid is low");
        data_input = 8'b11111111; // This should not affect the system as data_valid is low
        data_valid = 0;
        #20; // Wait for a clock cycle
        
        // Resetting for next tests
        reset = 0; #20; reset = 1;
        
        // Add more test cases as needed
        
        // Complete simulation
        #100;
        $finish;
    end
      
endmodule
