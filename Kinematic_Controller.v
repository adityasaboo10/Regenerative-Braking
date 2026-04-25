`timescale 1ns / 1ps

module Kinematic_Controller(
    input clk_50M,
    input clk_50, reset,
    input hwa,
    output  reg signed [19:0] v_s2, //velocity proportional to difference of x
    output  reg signed [19:0] a //proportional to difference of v
    );
//Encoder instatiation
wire signed[19:0] counter_L /*counter_R*/;
encoder L (.clk_50M(clk_50M), .reset(reset), .hwa(hwa), .counter(counter_L));
//encoder R (.clk_50M(clk_50M), .reset(reset), .en1(en1), .en2(en2), . counter(counter_R));

//---------------------------------
reg signed [19:0] L_ref, /*R_ref*/ v_ref, a_ref;
reg signed [19:0] counter_L_s1;   // registered encoder value (stage 1 output)
//---------------------------------

// STAGE 1 — capture position and hold previous position
always @(posedge clk_50 or negedge reset) begin
    if (!reset) begin
        counter_L_s1 <= 20'd0;
        L_ref        <= 20'd0;
    end else begin
        counter_L_s1 <= counter_L;      // register the raw encoder wire
        L_ref        <= counter_L_s1;   // L_ref is now exactly 1 cycle behind
    end
end
// STAGE 2 — compute velocity, latch previous velocity
always @(posedge clk_50 or negedge reset) begin
    if (!reset) begin
        v_s2  <= 20'd0;
        v_ref <= 20'd0;
    end else begin
        v_s2  <= counter_L_s1 - L_ref; // both are stable stage-1 registers
        v_ref <= v_s2;                  // latch current v to use as "previous" next cycle
    end
end

// STAGE 3 — compute acceleration
always @(posedge clk_50 or negedge reset) begin
    if (!reset) begin
        a <= 20'd0;
    end else begin
        a <= v_s2 - v_ref;  // v_s2 = current v, v_ref = previous v, both stable registers
    end
end
endmodule
