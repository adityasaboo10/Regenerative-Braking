`timescale 1ns / 1ps

module Moving_Average_Filter(
   input clk_50,
   input reset,
   input signed [19:0] data,
   output reg signed [19:0] avg);
   
reg signed [19:0] fifo [7:0];
reg signed [23:0] sum; //An accumulator to hold the sum
integer i;

always @(posedge clk_50 or negedge reset)begin
    if(!reset)begin
        for( i=0; i<8; i = i+1) begin
            fifo[i] <= 20'd0;
        end 
    sum <= 0;
    avg <=0;
    end
    else begin
        for (i = 7; i > 0; i = i - 1) begin
            fifo[i] <= fifo[i-1]; // Shift all old data down the line (working backwards)
        end
        fifo[0] <= data;    // ---Put the newest raw sample into the first slot----
        // Sum all 8 elements in the array
        sum <= data + fifo[0] + fifo[1] + fifo[2] + fifo[3] + fifo[4] + fifo[5] + fifo[6];
        // (fifo[7] is being shifted out, so it's dropped) 
        avg <= sum >>> 3; //Arithmetic Right Shift (>>>). A standard shift (>>) would destroy negative sign bit       
    end
end
endmodule

