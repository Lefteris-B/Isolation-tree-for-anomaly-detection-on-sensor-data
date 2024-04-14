module AnomalyDetectionSystem(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    input wire load_itree,
    input wire [255:0] itree_input,
    output reg anomaly_detected
);

// Signals for FIFO buffer and control
wire [7:0] fifo_data_out;
wire fifo_read_enable, fifo_empty, fifo_full;
wire internal_data_valid; // Internal signal to represent data validity based on FIFO status

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
IsolationTreeStateMachine isolation_tree_sm (
    .clk(clk),
    .reset(reset),
    .data_input(data_input),
    .data_valid(internal_data_valid), // Use internal_data_valid here
    .load_itree(load_itree),
    .itree_input(itree_input),
    .anomaly_detected(anomaly_detected)
);

// Control Logic for internal data validity
assign internal_data_valid = !fifo_empty && !fifo_full && data_valid; // Read when FIFO is not empty, not full, and external data_valid is asserted

endmodule