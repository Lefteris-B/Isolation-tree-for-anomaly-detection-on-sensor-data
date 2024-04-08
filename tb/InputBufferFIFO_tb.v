`timescale 1ns / 1ps

module InputBufferFIFO_tb;

reg clk;
reg reset;
reg sensor_input;
reg read_enable;
wire [7:0] fifo_output;
wire fifo_empty, fifo_full;

// Parameter for FIFO depth used in the testbench
parameter FIFO_DEPTH = 32;

// Instantiate the Unit Under Test (UUT)
InputBufferFIFO #(.FIFO_DEPTH(FIFO_DEPTH)) uut (
    .clk(clk),
    .reset(reset),
    .sensor_input(sensor_input),
    .read_enable(read_enable),
    .fifo_output(fifo_output),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full)
);

// Clock generation
always #5 clk = ~clk; // Generate a clock with a period of 10ns

initial begin
    // Initialize Inputs
    clk = 0;
    reset = 0;
    sensor_input = 0;
    read_enable = 0;

    // Wait for global reset
    #100;
    
    reset = 1; // Release reset
    #20;
    
    // Test Case 1: Fill the FIFO
    $display("Test Case 1: Filling the FIFO");
    repeat (FIFO_DEPTH) begin
        sensor_input = $random % 2; // Random sensor input
        #10; // Wait a clock cycle
    end
    if (fifo_full) $display("FIFO is full as expected.");
    else $display("Error: FIFO should be full.");

    // Test Case 2: Try overfilling the FIFO
    $display("Test Case 2: Attempting to overfill the FIFO");
    sensor_input = 1;
    #10; // Wait a clock cycle
    if (!fifo_full) $display("Error: FIFO should still be full.");
    
    // Test Case 3: Emptying the FIFO
    $display("Test Case 3: Emptying the FIFO");
    read_enable = 1; // Start reading from the FIFO
    repeat (FIFO_DEPTH) begin
        #10; // Wait a clock cycle
    end
    if (fifo_empty) $display("FIFO is empty as expected.");
    else $display("Error: FIFO should be empty.");
    
    // Test Case 4: Try underflowing the FIFO
    $display("Test Case 4: Attempting to underflow the FIFO");
    #10; // Wait a clock cycle
    if (!fifo_empty) $display("Error: FIFO should still be empty.");

    // Complete simulation
    $finish;
end
      
endmodule
