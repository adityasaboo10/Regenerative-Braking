//50 hz == 20 ms
`timescale 1ns / 1ps

module Clock_50Hz(
input clk_50M,
input reset,
output reg clk_50
    );
    
reg [19:0] counter; // 20-bit counter
localparam tick = 500000;

always @(posedge clk_50M or negedge reset) begin
    if(!reset) begin
        counter <= 0;
        clk_50 <= 1'b0;
    end
    else begin
        if(counter < tick ) begin
            counter <= counter + 1;
            
        end
        else begin 
        counter <= 0;
        clk_50 <= ~clk_50;
        end
    end
end
endmodule
