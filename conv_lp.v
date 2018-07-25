`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2018 10:28:52 AM
// Design Name: 
// Module Name: conv_lp
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


module conv_lp(
input in_clk,
input reset,
output reg [31:0]lp_result ,input [15:0]mod_data

    );
    wire [31:0]bp_sq_data ;
    convolution  conv_bp_sq(.in_clk(in_clk),.result(bp_sq_data),.reset(reset),.mod_data(mod_data));
    
    
    ////
    
    
    
       parameter M=4 ;
     
      wire [31:0]result_mul_w[0:M] ;
      
      reg [31:0]h[0:M] ;
     wire [31:0]w_in[0:M] ;
     reg h_write_done=0 ;
     always@(posedge in_clk) begin
      h[0]=32'b0_01111111_00000000000000000000000 ;
     h[1]=32'b0_01111111_00000000000000000000000 ;
      h[2]=32'b0_01111111_00000000000000000000000 ;
       h[3]=32'b0_01111111_00000000000000000000000 ;
        h[4]=32'b0_01111111_00000000000000000000000 ;
/*      h[5]=32'b0_11111111_00000000000000000000000 ;
            h[6]=32'b0_11111111_00000000000000000000000 ;
             h[7]=32'b0_11111111_00000000000000000000000 ;
              h[8]=32'b0_11111111_00000000000000000000000 ;
               h[9]=32'b0_11111111_00000000000000000000000 ;
               */
            
        h_write_done=1 ;
     end
     
     wire clk ;
     assign clk=h_write_done&in_clk ;
     
     
     
     assign w_in[0]=bp_sq_data ;
     genvar le ;
     generate 
     for(le=0; le<M ;le=le+1) begin : le_dff
     dff ff(.clk(clk),.reset(reset),.d(w_in[le]),.q(w_in[le+1])) ;
     end
     endgenerate
     
     
     
     genvar i ;
     generate 
      for(i=0;i<M+1;i=i+1) begin : le_bal
     
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
    /* integer a ;
     always@(*) begin
     for(a=0;a<5;a=a+1) begin 
       result_mul[a]= result_mul_w[a] ;
     end
     
     
     
     end
     */
     
     wire [31:0]result_adder_w[0:M] ;
     
     assign result_adder_w[0]=result_mul_w[0] ;
     
      genvar j ;
        generate 
         for(j=1;j<M+1;j=j+1) begin : le_add
        
     
     
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
     
     
   
    
    
    
    
    
    ///
    always@(*) begin
    lp_result = result_adder_w[M] ;
    end
    
    
    
    
endmodule
