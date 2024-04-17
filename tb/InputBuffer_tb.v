module tb_TopDesign();

    // Define parameters
    parameter CLK_PERIOD = 10; // Clock period in simulation time units

    // Signals
    reg clk;
    reg reset;
    reg sensor_data;
    wire anomaly_detected;

    // Instantiate the top module
    i_tree uut (
        .clk(clk),
        .reset(reset),
        .sensor_data(sensor_data),
        .anomaly_detected(anomaly_detected)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Initial values
    initial begin
        clk = 0;
        reset = 1;
        sensor_data = 0;
        #200 reset = 0; // De-assert reset after 20 time units
    end

    // Test cases
    initial begin
      $dumpfile("dump.vcd"); $dumpvars;
        // Case 1: Normal operation, no anomaly detected
        sensor_data = 8'hAA; // Input byte
        #500;
        assert (!anomaly_detected) else $display("Test case 1 failed: Anomaly detected when none was expected.");

        // Case 2: Anomaly detected
        sensor_data = 8'h55; // Input byte
        #500;
        assert (anomaly_detected) else $display("Test case 2 failed: No anomaly detected when one was expected.");

        // Case 3: Anomaly detected after reset
        reset = 1; // Reset asserted
        #500;
        reset = 0; // Reset de-asserted
        sensor_data = 8'h55; // Input byte
        #500;
        assert (anomaly_detected) else $display("Test case 3 failed: No anomaly detected after reset.");

        // Case 4: Continuation after reset with no anomaly
        reset = 1; // Reset asserted
        #500;
        reset = 0; // Reset de-asserted
        sensor_data = 8'hAA; // Input byte
        #500;
        assert (!anomaly_detected) else $display("Test case 4 failed: Anomaly detected after reset when none was expected.");
    end

    // End simulation
    initial begin
        #500;
        $finish;
    end

endmodule
