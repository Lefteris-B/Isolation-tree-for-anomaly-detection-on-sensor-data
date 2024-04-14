module InputBuffer(
    input wire clk,
    input wire reset,
    input wire [7:0] sensor_input,
    input wire read_enable,
    output reg [7:0] buffer_output,
    output reg buffer_valid
);

// Buffer register to hold the sensor input
reg [7:0] buffer_reg;

// Control logic for the buffer register
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset the buffer and valid flag
        buffer_reg <= 8'd0;
        buffer_valid <= 1'b0;
    end else begin
        if (read_enable) begin
            // Load the buffer register with sensor_input when read_enable is asserted
            buffer_reg <= sensor_input;
            buffer_valid <= 1'b1; // Set buffer as valid
        end else begin
            buffer_valid <= 1'b0; // Reset valid flag when read_enable is not asserted
        end
    end
end

// Assign the buffer output
always @(*) begin
    if (buffer_valid) begin
        buffer_output <= buffer_reg; // Output the buffer content when valid
    end
end

endmodule
