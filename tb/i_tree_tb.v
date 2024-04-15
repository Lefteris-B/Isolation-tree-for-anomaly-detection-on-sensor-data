`timescale 1ns / 1ps

module i_tree_tb;

// Parameters
parameter CYCLE = 10; // Clock cycle = 10 ns

// Inputs
reg clk;
reg reset;
reg sensor_data;

// Outputs
wire anomaly_detected;

// Instantiate the Unit Under Test (UUT)
i_tree uut (
    .clk(clk),
    .reset(reset),
    .sensor_data(sensor_data),
    .anomaly_detected(anomaly_detected)
);

// Clock generation
always #(CYCLE/2) clk = ~clk;

// Initial setup and test vectors
initial begin
    // Initialize Inputs
    clk = 0;
    reset = 0;
    sensor_data = 0;
  	$dumpfile("dump.vcd"); $dumpvars;

    // Apply reset
    #(CYCLE) reset = 1;
    #(CYCLE) reset = 0;
    #(CYCLE) reset = 1;

    // Test Case 1: Normal operation - Input correct sequence
    // Assume HARDCODED_VALUE = 8'hAB;
    send_byte(8'hAB); // Expected: anomaly_detected = 1

    // Test Case 2: Normal operation - Input incorrect sequence
    send_byte(8'h55); // Expected: anomaly_detected = 0

    // Test Case 3: Check handling of continuous data
    send_byte(8'hAB); // Expected: anomaly_detected = 1
    send_byte(8'hFF); // Expected: anomaly_detected = 0

    // Test Case 4: Reset during operation
    send_bit(1'b1); // Send partial data
    #(CYCLE * 2) reset = 0; // Assert reset
    #(CYCLE * 2) reset = 1; // Deassert reset
    send_byte(8'hAB); // Expected: anomaly_detected = 1 after reset

    // End of simulation
    #(CYCLE * 10) $finish;
end

// Task to send a single bit
task send_bit;
    input bit_in;
    begin
        sensor_data = bit_in;
        #(CYCLE);
    end
endtask

// Task to send an entire byte
task send_byte;
  input [7:0] bite;
    integer i;
    begin
        for (i = 7; i >= 0; i = i - 1) begin
          send_bit(bite[i]);
        end
    end
endtask

endmodule
