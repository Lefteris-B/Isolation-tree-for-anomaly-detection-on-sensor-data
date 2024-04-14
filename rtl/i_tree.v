`include "InputBuffer.sv"
`include "IsolationTreeStateMachine.sv"

module i_tree(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,  // Assuming this is the correct input for Buffer
    input wire data_valid,
    output reg anomaly_detected
);

// Signals for Buffer control
reg buffer_read_enable;
wire [7:0] buffer_output;
wire buffer_valid;

// Instantiate InputBuffer
InputBuffer input_buffer (
    .clk(clk),
    .reset(reset),
    .sensor_input(data_input),
    .read_enable(buffer_read_enable),
    .buffer_output(buffer_output),
    .buffer_valid(buffer_valid)
);

// Instantiate IsolationTreeStateMachine
IsolationTreeStateMachine isolation_tree_sm (
    .clk(clk),
    .reset(reset),
    .data_input(buffer_output), // Using Buffer output here
    .data_valid(buffer_valid),
    .anomaly_detected(anomaly_detected)
);

// Control Logic for Buffer read enable
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        buffer_read_enable <= 0;
    end else begin
        buffer_read_enable <= data_valid && !anomaly_detected; // Enable reading when data is valid and no anomaly detected
    end
end

endmodule
