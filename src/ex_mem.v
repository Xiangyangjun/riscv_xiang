`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 111:22:41
// Design Name: 
// Module Name: ex_mem
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:59:09
// Design Name: 
// Module Name: id_ex
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




module ex_mem(

	input	wire										clk,
	input wire										rst,

	
	//从译码阶段传递的信息
	input wire[4:0] ex_wd_i,
	input wire ex_wreg_i,
	input wire[31:0] ex_wdata_i,
	
	input wire[1:0] mem_rw_i,
    input wire[11:0] mem_addr_i,
    input wire[3:0] mem_sel_i,
    input wire[31:0] mem_data_i,
    input wire[5:0]  stall,
	
	output reg [4:0] ex_wd_o,
	output reg ex_wreg_o,
	output reg[31:0] ex_wdata_o,
	
	
	output reg [1:0] mem_rw_o,
    output reg [11:0] mem_addr_o,
    output reg[4:0] mem_sel_o,
    output reg[31:0] mem_data_o
);

	always @ (posedge clk) begin
		if (rst == 1) begin
			ex_wd_o=5'B0;
            ex_wreg_o=1'B0;
            ex_wdata_o=32'B0;
            mem_rw_o=2'b0;
            mem_addr_o=12'b0;
            mem_sel_o=4'b0;
		end else if(stall[3]==1 && stall[4]==0)begin
		    ex_wd_o=0;
            ex_wreg_o=0;
            ex_wdata_o=0;
            mem_rw_o=0;
            mem_addr_o=0;
            mem_sel_o=0;
            mem_data_o=0;
		end else if(stall[3]==0) begin 		
			ex_wd_o=ex_wd_i;
            ex_wreg_o=ex_wreg_i;
            ex_wdata_o=ex_wdata_i;
            mem_rw_o=mem_rw_i;
            mem_addr_o=mem_addr_i;
            mem_sel_o=mem_sel_i;
            mem_data_o=mem_data_i;
		end
	end
	
endmodule
