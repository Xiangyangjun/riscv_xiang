`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:59:25
// Design Name: 
// Module Name: regfile
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
`include "define.v "

module regfile(

	input	wire										clk,
	input wire										rst,
	//ex
    input wire[4:0] ex_wd,
    input wire ex_wreg,
    input wire[31:0] ex_wdata,
	//mem
	input wire[4:0]       mem_wd,
    input wire                    mem_wreg,
    input wire[31:0]           mem_wdata,
	//Ð´¶Ë¿Ú
	input wire										we,
	input wire[4:0]				waddr,
	input wire[31:0]						wdata,
	
	//¶Á¶Ë¿Ú1
	input wire										re1,
	input wire[4:0]			  raddr1,
	output reg[31:0]           rdata1,
	
	//¶Á¶Ë¿Ú2
	input wire										re2,
	input wire[4:0]			  raddr2,
	output reg[31:0]           rdata2
	
);
    integer i;
	reg[31:0]  regs[31:0];

	always @ (posedge clk) begin
		if (rst == 0) begin
			if((we == 1) && (waddr != 0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	
	always @ (*) begin
		if(rst == 1) begin
			  rdata1 <= 32'h00000000;
			  for(i=0;i<32;i=i+1)
			     regs[i] <= 32'b0;
	  end else if(raddr1 == 0) begin
	  		rdata1 <= 32'h00000000;
      end else if((ex_wreg == 1'b1) && (ex_wd == raddr1)&&(re1 == 1)) begin
             rdata1 <= ex_wdata; 
       end else if(( mem_wreg == 1'b1) && (mem_wd == raddr1)&&(re1 == 1)) begin
             rdata1<= mem_wdata; 
       end else if((raddr1 == waddr) && (we == 1) 
               && (re1 == 1)) begin
                rdata1 <= wdata;            	  	  
	  end else if(re1 == 1) begin
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= 32'h00000000;
	  end
	end

	always @ (*) begin
		if(rst == 1) begin
			  rdata2 <= 32'h00000000;
	  end else if(raddr2 == 0) begin
	  		rdata2 <= 32'h00000000;
	  end else if((ex_wreg == 1'b1) && (ex_wd == raddr2) &&(re2 == 1)) begin
          rdata2 <= ex_wdata; 
      end else if(( mem_wreg == 1'b1) && (mem_wd == raddr2) &&(re2 == 1)) begin
           rdata2<= mem_wdata; 
       end else if((raddr2 == waddr) && (we == 1) 
                           && (re2 == 1)) begin
           rdata2 <= wdata;                        
	  end else if(re2 == 1) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= 32'h00000000;
	  end
	end

endmodule
