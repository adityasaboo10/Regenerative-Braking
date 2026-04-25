`timescale 1ns / 1ps

module datapath(
    input clk_50M,
    input reset,
    input hwa,
    input accelerator_pressed,
    input brake_pressed,
    output wire [1:0] current_state,
    output wire [1:0] control_signal
    );
 
//----------------------   
wire clk_50;
Clock_50Hz clk( .clk_50M(clk_50M), . reset(reset), .clk_50(clk_50));

//-------------------
wire signed [19:0] v, a ;
Kinematic_Controller KC(.clk_50M(clk_50M), .clk_50(clk_50), .reset(reset), . hwa(hwa), .v(v), .a(a));

//------V avg--------
wire signed [19:0] v_avg;
Moving_Average_Filter MAFv(.clk_50(clk_50), . reset(reset), .data(v), .avg(v_avg));

//------A avg-----------
wire signed [19:0] a_avg; 
Moving_Average_Filter MAFa(.clk_50(clk_50), . reset(reset), .data(a), .avg(a_avg));

//-----Brake Blending FSM---
Brake_Blending_FSM BBF(.clk_50(clk_50), . reset(reset), 
                       .accelerator_pressed(accelerator_pressed), 
                       .brake_pressed(brake_pressed), .a_avg(a_avg), 
                       .current_state(current_state), .control_signal(control_signal));
endmodule
