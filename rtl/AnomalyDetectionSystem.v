`include "InputBuffer.sv"
`include "IsolationTreeStateMachine.sv"
//`include "InputBuffer.sv"
//`include "InputBuffer.sv"
//`include "InputBuffer.sv"
//`include "InputBuffer.sv"
//`include "InputBuffer.sv"

module AnomalyDetectionSystem(
    input wire clk,
    input wire reset,
    input wire sensor_input,
    output wire anomaly_detected
);

// Signals for FIFO buffer and control
wire [7:0] fifo_data_out;
wire fifo_read_enable, fifo_empty, fifo_full, data_valid;

// Instantiate InputBufferFIFO
InputBufferFIFO input_buffer (
    .clk(clk),
    .reset(reset),
    .sensor_input(sensor_input),
    .read_enable(fifo_read_enable),
    .fifo_output(fifo_data_out),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full)
);

// Instantiate IsolationTreeStateMachine
IsolationTreeStateMachine isolation_tree (
    .clk(clk),
    .reset(reset),
    .data_input(fifo_data_out),
    .data_valid(data_valid),
    .anomaly_detected(anomaly_detected)
);

// Control Logic
assign fifo_read_enable = !fifo_empty && !fifo_full; // Read when FIFO is not empty and not full
assign data_valid = fifo_read_enable; // Data is valid for state machine when we enable FIFO read

endmodule
