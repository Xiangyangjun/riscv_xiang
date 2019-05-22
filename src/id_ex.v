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




module id_ex(

	input	wire										clk,
	input wire										rst,
    input wire[11:0] pc_i,
	
	//从译码阶段传递的信息
	input wire[6:0]         id_opcode,
	input wire[5:0]        stall,
	input wire[5:0]        flash,
	input wire[2:0]        id_funct3,
	input wire[6:0]        id_funct7,
	input wire[31:0]           id_reg1,
	input wire[31:0]           id_reg2,
	input wire[4:0]       id_wd,
	input wire                    id_wreg,	
	input wire [31:0] imm_i, 
	
	//传递到执行阶段的信息
	output reg[11:0] pc_o,
	
	output reg[6:0]         ex_opcode,
	output reg[2:0]        ex_funct3,
	output reg[6:0]        ex_funct7,
	output reg[31:0]           ex_reg1,
	output reg[31:0]           ex_reg2,
	output reg[4:0]       ex_wd,
	output reg                    ex_wreg,
	output reg [31:0] imm_o,
	output reg[6:0] opcode_o
	
);

   
	always @ (posedge clk) begin
		if (rst == 1) begin
			ex_opcode <= 7'b0;
			ex_funct3 <= 3'b0;
			ex_funct7 <= 7'b0;
			ex_reg1 <= 32'b0;
			ex_reg2 <= 32'b0;
			ex_wd <= 5'b0;
			ex_wreg <= 1'b0;
			imm_o<=32'b0;
			pc_o=0;
			opcode_o=0;
		end else if((stall[2]==1 && stall[3]==0)|flash[2]==1) begin
		    ex_opcode <= 7'b0;
            ex_funct3 <= 3'b0;
            ex_funct7 <= 7'b0;
            ex_reg1 <= 32'b0;
            ex_reg2 <= 32'b0;
            ex_wd <= 5'b0;
            ex_wreg <= 1'b0;
            imm_o<=32'b0;
            pc_o=0;
            opcode_o=0;
		end else if(stall[2]==0) begin		
			ex_opcode <= id_opcode;
			ex_funct3 <= id_funct3;
			ex_funct7 <= id_funct7;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;	
			imm_o<=imm_i;
			pc_o=pc_i;
			opcode_o=id_opcode;
		end
	end
	
endmodule