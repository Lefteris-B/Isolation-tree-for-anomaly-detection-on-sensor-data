module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    input wire load_itree,
    input wire [255:0] itree_input,
    output reg anomaly_detected
);

reg [7:0] state = 0;
integer i;
reg [255:0] itree = 256'b0;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state <= 0;
        anomaly_detected <= 0;
    end else if (data_valid) begin
        if (load_itree) begin
            itree <= itree_input;
        end
        
        for (i = 0; i < 8; i = i + 1) begin
            if (state < 256) begin
                if (data_input[i] == itree[state]) begin
                    state <= state + 1;
                end
                 else begin
                    state <= 0;
                    anomaly_detected <= 0;
                   
                end
                
                if (state == 255) begin
                    anomaly_detected <= 1;
                    state <= 0;
                    end
                     else begin
                    anomaly_detected <= 0;
                end
            end
        end
    end
end

endmodule
