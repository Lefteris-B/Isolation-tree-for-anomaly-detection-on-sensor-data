module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    output reg anomaly_detected
);

reg [7:0] itree = 8'hAB; // Example 8-bit hardcoded value

// Define states using localparam
localparam [1:0] 
    IDLE = 2'b00,
    CHECK_ANOMALY = 2'b01;

reg [1:0] current_state = IDLE;
reg [1:0] next_state;

// State Machine for Anomaly Detection
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        anomaly_detected <= 0;
        current_state <= IDLE;
    end else begin
        current_state <= next_state; // Use non-blocking assignment for sequential logic
    end
end

// Next state logic using always_comb (SystemVerilog) or always @* (Verilog)
always @* begin // Use @* for sensitivity list in Verilog
    case (current_state)
        IDLE: begin
            if (data_valid)
                next_state = CHECK_ANOMALY; // Ensure blocking assignment in combinational logic
            else
                next_state = IDLE;
        end
        CHECK_ANOMALY: begin
            if (data_input == itree)
                anomaly_detected = 1; // Direct blocking assignment within combinational logic
            else
                anomaly_detected = 0;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule
