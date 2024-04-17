module tb_IsolationTreeStateMachine();

    // Define parameters
    parameter CLK_PERIOD = 10; // Clock period in simulation time units

    // Signals
    reg clk;
    reg reset;
    reg [7:0] sensor_data;
    reg data_valid;
    wire anomaly_detected;
    wire data_processed;

    // Instantiate the IsolationTreeStateMachine module
    IsolationTreeStateMachine uut (
        .clk(clk),
        .reset(reset),
        .data_input(sensor_data),
        .data_valid(data_valid),
        .anomaly_detected(anomaly_detected),
        .data_processed(data_processed)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Initial values
    initial begin
        clk = 0;
        reset = 1;
        sensor_data = 8'h00;
        data_valid = 0;
        #20 reset = 0; // De-assert reset after 20 time units
    end

    // Test cases
    initial begin
        // Case 1: Normal operation, no anomaly
        sensor_data = 8'hAA; // Data input
        data_valid = 1; // Valid data
      $dumpfile("dump.vcd");
      $dumpvars;
        #50;
        assert (!anomaly_detected) else $display("Test case 1 failed: Anomaly detected incorrectly.");

        // Case 2: Anomaly detected
        sensor_data = 8'hAA; // Data input
        data_valid = 1; // Valid data
        #50;
        assert (anomaly_detected) else $display("Test case 2 failed: Anomaly not detected.");

        // Case 3: Data processed after anomaly detected
        sensor_data = 8'h00; // Data input
        data_valid = 1; // Valid data
        #50;
        assert (data_processed) else $display("Test case 3 failed: Data not processed after anomaly detected.");

        // Case 4: Reset behavior
        reset = 1; // Reset asserted
        #50;
        assert (!anomaly_detected && !data_processed) else $display("Test case 4 failed: Reset behavior incorrect.");
    end

    // End simulation
    initial begin
        #500;
        $finish;
    end

endmodule
