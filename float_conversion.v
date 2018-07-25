`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2018 12:32:57 PM
// Design Name: 
// Module Name: demodulation
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


module float_conversion(clk,float_data,mod_data);
    input clk;
    output [31:0]float_data;
    input [15:0]mod_data;
    //reg[16:0]addr=17'b0;
    reg [31:0]int_data;
   // wire[15:0]dout;
    wire fixed_tready,float_tvalid;
 /*   blk_mem_gen_0 mybram (
      .clka(clk),    // input wire clka
      .ena(1'b1),      // input wire ena
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(addr),  // input wire [16 : 0] addra
      .dina(16'b0),    // input wire [15 : 0] dina
      .douta(dout)  // output wire [15 : 0] douta
    );*/
 /*   always@(posedge clk)
    begin
        if(addr==17'b11111111111111111)
            addr=17'b0;
        else
            addr=addr+17'b00000000000000001;
    end*/
    always@(*)
    begin
        int_data=mod_data;
        if(int_data[15]==1'b0)
         int_data[31:16]=0 ;
           
        else
            if(int_data[15]==1'b1)
                begin
                    int_data[31:16]=16'b1111111111111111;
                   
                end
    end
    floating_point_0 myconverter (
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(fixed_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(int_data),              // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(float_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(float_data)    // output wire [31 : 0] m_axis_result_tdata
    );  
    
                                     
endmodule
