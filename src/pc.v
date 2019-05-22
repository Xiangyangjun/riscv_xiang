`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:511:35
// Design Name: 
// Module Name: pc
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


module pc(
input wire clk,
input wire rst,
input wire[5:0] stall,
input wire[11:0] branch_pc,
input wire branch,

output reg ce,
output reg[11:0]			pc

    );
    
    always @ (posedge clk) begin
       if(rst==1'b1) begin
          ce<=1'b0;
       end else begin
          ce<=1'b1;
         end
     end
   
       always @ (posedge clk) begin
        if(ce==1'b0) begin
           pc<=12'h000;
        end else if(branch==1) begin
           pc<=branch_pc;
        end else if(stall[0]==0)begin
           pc<=pc+4'h4;
        end
      end    
endmodule
