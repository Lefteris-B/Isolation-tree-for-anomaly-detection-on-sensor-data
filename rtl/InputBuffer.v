module InputBuffer #(
    parameter DATA_WIDTH = 8 // Parameterize data width for flexibility
)(
    input wire clk,
    input wire reset, // Active-low reset
    input wire sensor_data,
    input wire data_processed, // Acknowledgment from IsolationTreeModule
    output reg [DATA_WIDTH-1:0] data_output = 0,
    output reg data_ready = 0
);

// Internal shift register and bit counter
reg [DATA_WIDTH-1:0] shift_register = 0;
reg [$clog2(DATA_WIDTH)-1:0] bit_count = 0; // Counter size based on DATA_WIDTH

// State machine states for data_ready pulse
reg data_ready_pulse = 0;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        shift_register <= 0;
        bit_count <= 0;
        data_output <= 0;
        data_ready <= 0;
        data_ready_pulse <= 0;
    end else begin
        // Handle data_processed acknowledgment
        if (data_processed) begin
            data_ready <= 0; // Clear data_ready once data is processed
            data_ready_pulse <= 0; // Ensure pulse is reset
        end
        
        if (bit_count < DATA_WIDTH) begin
            // Shift in the new bit from the right
            shift_register <= (shift_register << 1) | sensor_data;
            bit_count <= bit_count + 1;
        end
        
        if (bit_count == DATA_WIDTH-1) begin
            // On the last bit, update data_output and prepare data_ready pulse
            data_output <= (shift_register << 1) | sensor_data;
            data_ready_pulse <= 1; // Set pulse flag
            bit_count <= 0; // Reset for the next byte
            shift_register <= 0; // Optionally, reset shift_register
        end
        
        // Generate a single-cycle data_ready pulse
        if (data_ready_pulse) begin
            data_ready <= 1;
            data_ready_pulse <= 0; // Reset pulse flag
        end else if (!data_processed) begin
            data_ready <= 0; // Ensure data_ready is low if not in pulse state
        end
    end
end

endmodule