`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2018 11:16:31 AM
// Design Name: 
// Module Name: decision_mak
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decision_mak(
input in_clk,
//input reset,
input [15:0]mod_data,
output reg final_result
    );
     wire reset;
     assign reset=0;
       parameter M=4 ;
     wire [31:0]lp_result ;
     wire [31:0]sub_out ;
     
    conv_lp   lpf(in_clk,reset,lp_result,mod_data);
    
    
    floating_point_3 subs (
      .aclk(in_clk),                                  // input wire aclk
      .s_axis_a_tvalid(1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(lp_result),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(1),            // input wire s_axis_b_tvalid
      .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
      .s_axis_b_tdata(32'b0100_1111_1010_1000_1111_1010_1011_1010),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready(1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(sub_out)    // output wire [31 : 0] m_axis_result_tdata
    );

    always@(*) begin
    final_result=~sub_out[31] ;
    
    end
    ila_0 myila (
        .clk(in_clk), // input wire clk
    
    
        .probe0(lp_result), // input wire [31:0]  probe0  
        .probe1(final_result) // input wire [0:0]  probe1
    );

    
endmodule
