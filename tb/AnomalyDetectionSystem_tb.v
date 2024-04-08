`timescale 1ns / 1ps

module AnomalyDetectionSystem_tb;

// Inputs
reg clk;
reg reset;
reg sensor_input;

// Output
wire anomaly_detected;

// Instantiate the Top Module
AnomalyDetectionSystem uut (
    .clk(clk),
    .reset(reset),
    .sensor_input(sensor_input),
    .anomaly_detected(anomaly_detected)
);

// Clock generation
always #5 clk = ~clk; // Generate a clock with a period of 10ns

initial begin
    // Setup VCD dump
    $dumpfile("dump.vcd");
    $dumpvars(0, AnomalyDetectionSystem_tb);

    // Initialize Inputs
    clk = 0;
    reset = 0;
    sensor_input = 0;

    // Reset the system
    #10;
    reset = 1;
    #10;

    // Test Case 1: No sensor input, expecting no anomaly
    $display("Test Case 1: Starting with no sensor input.");
    repeat (10) #10 sensor_input = 0;

    // Test Case 2: Generate sensor inputs that do not lead to anomaly
    $display("Test Case 2: Sensor inputs that do not lead to anomaly.");
    repeat (5) begin
        #10 sensor_input = 1; 
        #10 sensor_input = 0;

    
    // Wait and observe
    #100;
    
    // Complete simulation
    $finish;
end

endmodule
