module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,  // Changed to 8-bit input from FIFO
    input wire data_valid,        // Signal indicating valid data is available from FIFO
    output reg anomaly_detected
);

// Hardcoded binary representation of the Isolation Tree
parameter [255:0] itree = 256'b0100101111010111110001001111010111011100100000011100001000101100011010111111111110101001100000011111000110111011101000000110010100000100011101000010101001101011010000010111000101101000010101110100110010100011011010001100110001000111000111110000000100100110;// Example representation
  
reg [7:0] state = 0; // Current state in the tree
integer i;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state <= 0;
        anomaly_detected <= 0;
    end else if (data_valid) begin  // Process data only when valid data is available
        // Process each bit in the 8-bit data_input
        for (i = 0; i < 8; i = i + 1) begin
            if (state < 256) begin
                // Compare current data bit to the expected bit in the tree
                if (data_input[i] == itree[state]) begin
                    state <= state + 1;  // Advance to the next state
                end else begin
                    state <= 0; // Reset state if there's a mismatch
                    anomaly_detected <= 0;
                    break; // Exit loop on mismatch
                end
                
                // Check for anomaly detection
                if (state == 255) begin
                    anomaly_detected <= 1;
                    state <= 0; // Reset state after detecting anomaly
                    break; // Exit loop after detecting anomaly
                end else begin
                    anomaly_detected <= 0;
                end
            end
        end
    end
end

endmodule
