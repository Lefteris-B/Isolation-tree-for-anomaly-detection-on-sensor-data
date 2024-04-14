`timescale 1ns / 1ps

module i_tree_tb;

    // Inputs to the i_tree
    reg clk;
    reg reset;
    reg [7:0] data_input;
    reg data_valid;

    // Output from the i_tree
    wire anomaly_detected;

    // Instantiate the i_tree module
    i_tree dut (
        .clk(clk),
        .reset(reset),
        .data_input(data_input),
        .data_valid(data_valid),
        .anomaly_detected(anomaly_detected)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10ns
    end

    // Test vectors and initialization
    initial begin
        // Initialize Inputs
        reset = 1;
        data_input = 0;
        data_valid = 0;

        // Allow time for global reset
        #10;
        reset = 0; #5;
        reset = 1; #10;

        // Test Case 1: Input valid data matching the itree value
        // Expect anomaly_detected to be asserted
        data_valid = 1;
        data_input = 8'hAB;  // Assuming 'AB' is the hardcoded value for anomaly detection
        #20; data_valid = 0; #10;

        // Test Case 2: Input valid data that does not match the itree value
        // Expect anomaly_detected to not be asserted
        data_valid = 1;
        data_input = 8'hFF;
        #20; data_valid = 0; #10;

        // More test cases can be added here
        // Test Case 3: Rapid sequence of valid and invalid data
        data_valid = 1; data_input = 8'hAB; #10;
        data_valid = 1; data_input = 8'h23; #10;
        data_valid = 1; data_input = 8'hAB; #10;
        data_valid = 0; #10;

        // Test Case 4: Check response to reset during operation
        data_valid = 1; data_input = 8'hAB;
        #5 reset = 0; #5 reset = 1;  // Pulse reset
        #20;

        // Complete all tests
        #50 $finish;
    end

    // VCD file generation for waveform analysis
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, i_tree_tb);
    end

endmodule
