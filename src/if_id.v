`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:58:26
// Design Name: 
// Module Name: if_id
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


module if_id(

input wire clk,
input wire rst,
input wire[11:0] pc_i,
input wire[31:0]  if_inst,
input wire[5:0] stall,
input wire[5:0] flash,

output reg[31:0] id_inst,
output reg[11:0] pc_o
    );

    always @ (posedge clk) begin
          if(rst==1'b1) begin
              id_inst<=32'h00000000;
              pc_o<=0; 
          end else if((stall[1] == 1 && stall[2] == 0)|flash[1]==1) begin
              id_inst <= 0;
              pc_o<=0;    
          end else if(stall[1] == 0) begin
               id_inst <= if_inst;
               pc_o=pc_i;
          end 
       end 
endmodule
