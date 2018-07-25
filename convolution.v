`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2018 04:42:59 PM
// Design Name: 
// Module Name: convolution
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


module convolution(in_clk,result,reset,mod_data);
    input in_clk;
    input reset ;
    output reg [31:0]result ;
    input [15:0]mod_data;
    wire [31:0]float_data ;
   parameter N=9 ;
    wire [31:0]result_mul_w[0:N] ;
     reg [31:0]result_mul[0:N] ;
     wire [31:0]result_sq_w ;
     
     reg [31:0]h[0:N] ;
    wire [31:0]w_in[0:N] ;
    reg h_write_done=0 ;
    always@(posedge in_clk) begin
     h[0]=32'b0_01111111_00000000000000000000000 ;
    h[1]=32'b0_01111111_00000000000000000000000 ;
     h[2]=32'b0_01111111_00000000000000000000000 ;
      h[3]=32'b0_01111111_00000000000000000000000 ;
       h[4]=32'b0_01111111_00000000000000000000000 ;
       h[5]=32'b0_01111111_00000000000000000000000 ;
           h[6]=32'b0_01111111_00000000000000000000000 ;
            h[7]=32'b0_01111111_00000000000000000000000 ;
             h[8]=32'b0_01111111_00000000000000000000000 ;
              h[9]=32'b0_01111111_00000000000000000000000 ;
       h_write_done=1 ;
    end
    
    wire clk ;
    assign clk=h_write_done&in_clk ;
    
    float_conversion float0(clk,float_data,mod_data);
    
    assign w_in[0]=float_data ;
    genvar le ;
    generate 
    for(le=0; le<N ;le=le+1) begin : le_dff
    dff ff(.clk(clk),.reset(reset),.d(w_in[le]),.q(w_in[le+1])) ;
    end
    endgenerate
    
    
    
    
    genvar i ;
    generate 
     for(i=0;i<N+1;i=i+1) begin : le_bal
    
    floating_point_1 mult(
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(w_in[i]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
      .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
      .s_axis_b_tdata(h[i]),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(result_mul_w[i])    // output wire [31 : 0] m_axis_result_tdata
    );
    end
    endgenerate
    integer a ;
    always@(*) begin
    for(a=0;a<5;a=a+1) begin 
      result_mul[a]= result_mul_w[a] ;
    end
    
    
    
    end
    
    wire [31:0]result_adder_w[0:N] ;
    
    assign result_adder_w[0]=result_mul_w[0] ;
    
     genvar j ;
       generate 
        for(j=1;j<N+1;j=j+1) begin : le_add
       
    
    
    floating_point_2 adder (
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(result_adder_w[j-1]),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
      .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
      .s_axis_b_tdata(result_mul_w[j]),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(result_adder_w[j])    // output wire [31 : 0] m_axis_result_tdata
    );
    
    end
    endgenerate
    
    
  
    
    floating_point_1 square(
          .aclk(clk),                                  // input wire aclk
          .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(result_adder_w[N]),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
          .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
          .s_axis_b_tdata(result_adder_w[N]),              // input wire [31 : 0] s_axis_b_tdata
          .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
          .m_axis_result_tdata(result_sq_w)    // output wire [31 : 0] m_axis_result_tdata
        );
        
          always@(*) begin
          result = result_sq_w ;
          end
    
    
    
endmodule
