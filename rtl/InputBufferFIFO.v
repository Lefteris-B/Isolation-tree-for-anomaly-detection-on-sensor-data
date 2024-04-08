module InputBufferFIFO(
    input wire clk,
    input wire reset,
    input wire sensor_input,
    input wire read_enable,
    output reg [7:0] fifo_output,
    output reg fifo_empty,
    output reg fifo_full
);

parameter FIFO_DEPTH = 32; // Example smaller FIFO depth
parameter FIFO_WIDTH = 8;  // Width of the FIFO (8 bits)
parameter ADDR_WIDTH = 5;  // Address width to support FIFO_DEPTH entries

reg [FIFO_WIDTH-1:0] fifo[FIFO_DEPTH-1:0];
reg [ADDR_WIDTH-1:0] write_ptr = 0;
reg [ADDR_WIDTH-1:0] read_ptr = 0;

integer i;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        write_ptr <= 0;
        read_ptr <= 0;
        fifo_empty <= 1;
        fifo_full <= 0;
        for (i = 0; i < FIFO_DEPTH; i++) begin
            fifo[i] <= 0;
        end
    end else begin
        if (!fifo_full && !read_enable) begin
            fifo[write_ptr] <= sensor_input;
            write_ptr <= (write_ptr + 1) % FIFO_DEPTH;
            fifo_empty <= 0;
            if (((write_ptr + 1) % FIFO_DEPTH) == read_ptr) fifo_full <= 1;
        end
        
        if (read_enable && !fifo_empty) begin
            fifo_output <= fifo[read_ptr];
            read_ptr <= (read_ptr + 1) % FIFO_DEPTH;
            fifo_full <= 0;
            if (read_ptr == write_ptr) fifo_empty <= 1;
        end
    end
end

endmodule
