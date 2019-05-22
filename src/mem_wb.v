`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 111:23:12
// Design Name: 
// Module Name: mem_wb
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



module mem_wb(

	input	wire										clk,
	input wire										rst,
	

	//来自访存阶段的信息	
	input wire[4:0]       mem_wd,
	input wire                    mem_wreg,
	input wire[31:0]					 mem_wdata,
	input wire[5:0]      stall,

	//送到回写阶段的信息
	output reg[4:0]      wb_wd,
	output reg                   wb_wreg,
	output reg[31:0]					 wb_wdata	       
	
);


	always @ (posedge clk) begin
		if(rst == 1) begin
			wb_wd <= 4'b0;
			wb_wreg <= 1'b0;
		  wb_wdata <= 32'b0;	
		end else begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
		end    //if
	end      //always
			

endmodule