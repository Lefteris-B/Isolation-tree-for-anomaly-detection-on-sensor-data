module i_tree(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,  // Assuming this is the correct input for FIFO
    input wire data_valid,
    output reg anomaly_detected
);

// Signals for FIFO buffer and control
wire [7:0] fifo_data_out;
reg fifo_read_enable; // Changed to reg if driven by procedural code
wire fifo_empty, fifo_full;
wire internal_data_valid; // Internal signal to represent data validity based on FIFO status

// Instantiate InputBufferFIFO
InputBufferFIFO input_buffer (
    .clk(clk),
    .reset(reset),
    .sensor_input(data_input),
    .read_enable(fifo_read_enable),
    .fifo_output(fifo_data_out),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full)
);

// Instantiate IsolationTreeStateMachine
IsolationTreeStateMachine isolation_tree_sm (
    .clk(clk),
    .reset(reset),
    .data_input(fifo_data_out), // Using FIFO output here
    .data_valid(internal_data_valid),
    .anomaly_detected(anomaly_detected)
);

// Control Logic for internal data validity and FIFO read enable
assign internal_data_valid = !fifo_empty && data_valid; // Simplified condition
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        fifo_read_enable <= 0;
    end else begin
        fifo_read_enable <= !fifo_empty && !anomaly_detected; // Control reading based on FIFO status and anomaly detection
    end
end

endmodule
