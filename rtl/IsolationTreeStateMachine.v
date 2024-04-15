module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    output reg anomaly_detected,
    output reg data_processed // Acknowledgment signal
);

// Define states
localparam IDLE = 2'b00,
           CHECK_ANOMALY = 2'b01,
           PROCESS_DONE = 2'b10; // New state to indicate processing is done

// Hardcoded value for comparison
localparam [7:0] HARDCODED_VALUE = 8'hAB;

// State and next state variables
reg current_state = IDLE;
reg next_state = IDLE;

// State Machine for Anomaly Detection
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        anomaly_detected <= 0;
        data_processed <= 0; // Ensure data_processed is low after reset
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
        if (current_state == PROCESS_DONE) begin
            data_processed <= 1; // Set data_processed high when processing is done
        end else begin
            data_processed <= 0; // Otherwise, keep it low
        end
    end
end

// Next state logic
always @* begin
    case (current_state)
        IDLE: begin
            if (data_valid)
                next_state = CHECK_ANOMALY;
            else
                next_state = IDLE;
        end
        CHECK_ANOMALY: begin
            next_state = PROCESS_DONE; // Move to PROCESS_DONE after checking anomaly
        end
        PROCESS_DONE: begin
            next_state = IDLE; // Loop back to IDLE to read next value
        end
        default: next_state = IDLE;
    endcase
end

// Anomaly detection logic
always @(posedge clk) begin
    if (current_state == CHECK_ANOMALY) begin
        if (data_input == HARDCODED_VALUE)
            anomaly_detected <= 1;
        else
            anomaly_detected <= 0;
    end
end

endmodule