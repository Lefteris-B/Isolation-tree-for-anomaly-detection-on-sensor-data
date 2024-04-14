module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    output reg anomaly_detected
);

// Hardcoded iTree value for comparison, now as an 8-bit value
reg [7:0] itree = 8'hAB; // Example 8-bit value, replace 'AB' with your actual value

// State Definitions using reg vectors
reg [1:0] current_state, next_state;

// State encoding
localparam IDLE = 2'b00,
           CHECK_ANOMALY = 2'b01;

// State Machine for Anomaly Detection
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset logic
        anomaly_detected <= 0;
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_valid) begin
                next_state = CHECK_ANOMALY;
            end else {
                next_state = IDLE;
            }
        end
        CHECK_ANOMALY: begin
            // Check if the incoming data_input matches the itree value
            if (data_input == itree) begin
                anomaly_detected = 1;
            end else {
                anomaly_detected = 0;
            }
            // Return to IDLE state to wait for new data
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule
