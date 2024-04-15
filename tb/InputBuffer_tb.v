`timescale 1ns / 1ps

module InputBuffer_tb;

// Parameters
localparam DATA_WIDTH = 8;

// Inputs
reg clk;
reg reset;
reg sensor_data;
reg data_processed;

// Outputs
wire [DATA_WIDTH-1:0] data_output;
wire data_ready;

// Instantiate the Unit Under Test (UUT)
InputBuffer #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (
    .clk(clk), 
    .reset(reset), 
    .sensor_data(sensor_data), 
    .data_processed(data_processed),
    .data_output(data_output), 
    .data_ready(data_ready)
);

initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1; // Active-high due to active-low reset in module
    sensor_data = 0;
    data_processed = 0;
  	$dumpfile("dump.vcd");
  	$dumpvars;

    // Reset the module
    #10 reset = 0; // Assert reset
    #10 reset = 1; // Deassert reset
    
    // Test Case 1: Send 8 bits and expect data_ready pulse
    sendBits(8'b11010101);
    waitForDataReadyAndAcknowledge();
    
    // Test Case 2: Check module's response to reset during operation
    sendBits(8'b00110011); // Start sending bits
    #20 reset = 0; #10 reset = 1; // Reset in the middle
    sendBits(8'b10101010); // Send another set after reset
    waitForDataReadyAndAcknowledge();
    
    // Test Case 3: Send bits without acknowledging data_ready
    sendBits(8'b11110000); // Send bits without acknowledging
    #100; // Wait to see if data_ready is pulsed correctly without acknowledgment
    
    $finish;
end

// Clock generation
always #5 clk = ~clk; // 100MHz clock

// Task to send bits to the module
task sendBits;
    input [DATA_WIDTH-1:0] bits;
    integer i;
    begin
        for (i = DATA_WIDTH-1; i >= 0; i = i - 1) begin
            @(posedge clk) sensor_data = bits[i];
        end
    end
endtask

// Task to wait for data_ready and acknowledge
task waitForDataReadyAndAcknowledge;
    begin
        @(posedge data_ready); // Wait for data_ready to be asserted
        @(posedge clk) data_processed = 1; // Acknowledge data processing
        @(posedge clk) data_processed = 0; // Reset acknowledgment
    end
endtask

endmodule