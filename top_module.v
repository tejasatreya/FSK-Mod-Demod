`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2018 01:05:51 PM
// Design Name: 
// Module Name: top_module
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


module top_module(input in_clk,
in_stream,

output demod_output 

    );
    
    wire [15:0]mod_data ;
    
    decision_mak dem0(
     .in_clk(in_clk),
    
    .mod_data(mod_data),
    .final_result(demod_output)
        );
        
Modulation_top mod0(in_stream,in_clk,mod_data);        
        
        
        
endmodule