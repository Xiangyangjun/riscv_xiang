`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 11:38:46
// Design Name: 
// Module Name: ctrl
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

module ctrl(

	input wire										rst,
//来自译码阶段的暂停请求
	input wire                   stallreq_from_id,

  //来自执行阶段的暂停请求
	input wire                   stallreq_from_ex,
	output reg[5:0]              stall,
	output reg[5:0]              flash
	
);

	always @ (*) begin
		if(rst == 1) begin
			stall <= 6'b000000;
			flash <= 6'b000000;
		end else if(stallreq_from_ex == 1) begin
			flash <= 6'b000111;
		end else if(stallreq_from_id == 1) begin
			stall <= 6'b000111;			
		end else begin
			stall <= 6'b000000;
			flash <= 6'b000000;
		end    //if
	end      //always
			

endmodule
