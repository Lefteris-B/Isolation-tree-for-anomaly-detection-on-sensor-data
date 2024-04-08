module IsolationTreeStateMachine_TB;

  // Inputs
  reg clk;
  reg reset;
  reg [7:0] data_input;
  reg data_valid;
  reg load_itree;
  reg [255:0] itree_input;

  // Outputs
  wire anomaly_detected;

  // Instantiate the design under test
  IsolationTreeStateMachine dut (
    .clk(clk),
    .reset(reset),
    .data_input(data_input),
    .data_valid(data_valid),
    .load_itree(load_itree),
    .itree_input(itree_input),
    .anomaly_detected(anomaly_detected)
  );

  // Clock generation
  always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
  end

  // Test cases
  initial begin
    // Test case 1: No anomaly detected
    reset = 1;
    data_input = 8'b00000000;
    data_valid = 0;
    load_itree = 0;
    itree_input = 256'b0;
    #10;
    reset = 0;
    data_valid = 1;
    data_input = 8'b00000000;
    #100;
    data_valid = 0;
    #10;
    if (anomaly_detected) begin
      $display("Test case 1 failed: Anomaly detected when it shouldn't have");
    end else begin
      $display("Test case 1 passed");
    end

    // Test case 2: Anomaly detected
    reset = 1;
    data_input = 8'b11111111;
    data_valid = 0;
    load_itree = 1;
    itree_input = 256'b1111111111111111111111111111111111111111111111111111111111111111;
    #10;
    reset = 0;
    data_valid = 1;
    data_input = 8'b11111111;
    #100;
    data_valid = 0;
    #10;
    if (!anomaly_detected) begin
      $display("Test case 2 failed: No anomaly detected when it should have");
    end else begin
      $display("Test case 2 passed");
    end

    // Add more test cases as needed

    $finish;
  end

endmodule