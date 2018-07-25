`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2018 12:40:05 PM
// Design Name: 
// Module Name: Modulation_top
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


module Modulation_top(bit_data,clk_in1,data);
    input bit_data;
    input clk_in1;
    wire datav,phasev;
    output[15:0]data;
    wire[39:0]phase;
    wire [39:0]pinc;
    wire addr;
    assign addr=bit_data;
   dds_compiler_0 mydds (
      .aclk(clk_in1),                                // input wire aclk
      .s_axis_phase_tvalid(1'b1),  // input wire s_axis_phase_tvalid
      .s_axis_phase_tdata(pinc),    // input wire [39 : 0] s_axis_phase_tdata
      .m_axis_data_tvalid(datav),    // output wire m_axis_data_tvalid
      .m_axis_data_tdata(data),      // output wire [15 : 0] m_axis_data_tdata
      .m_axis_phase_tvalid(phasev),  // output wire m_axis_phase_tvalid
      .m_axis_phase_tdata(phase)    // output wire [39 : 0] m_axis_phase_tdata
    );
   blk_mem_gen_1 mybram (
      .clka(clk_in1),    // input wire clka
      .ena(1'b1),      // input wire ena
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(addr),  // input wire [0 : 0] addra
      .dina(40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000),    // input wire [39 : 0] dina
      .douta(pinc)  // output wire [39 : 0] douta
    );
    /*clk_wiz_0 myclock
       (
       // Clock in ports
        .clk_in1(clk_in1),      // input clk_in1
        // Clock out ports
        .clk_out1(clk_out1),     // output clk_out1
        .clk_out2(clk_out2),     // output clk_out2
        // Status and control signals
        .reset(1'b0), // input reset
        .locked(locked));*/
    ila_1 your_instance_name (
            .clk(clk_in1), // input wire clk
        
        
            .probe0(data) // input wire [15:0] probe0
        );      
    /*always@(posedge clk1)
        begin
            if(addr==1'b1)
                addr=1'b0;
            else
                addr=addr+1'b1;
        end*/
    /*always@(posedge clk_out1)                   //Code for converting 6.4MHZ clock to 100kHz
        begin
            if(counter==6'b111111)
                counter=6'b000000;
            else
                counter=counter+6'b000001;  
        end                     */
endmodule

