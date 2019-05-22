`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 111:22:511
// Design Name: 
// Module Name: mem
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




module mem(

	input wire										rst,
	
	//来自执行阶段的信息	
	input wire[4:0]       wd_i,
	input wire                    wreg_i,
	input wire[31:0]					  wdata_i,
	
	input wire[1:0]       rw,
    input wire[3:0]       sel_i,
    input wire[11:0]      mem_addr,
    input wire[31:0]      mem_data,
    input wire[31:0]      mem_data_r,
            
    output reg  we,
    output reg[11:0] addr,
    output reg[3:0]  sel_o,
    output reg[31:0] mem_data_w,
 
	//送到回写阶段的信息
	output reg[4:0]      wd_o,
	output reg                   wreg_o,
	output reg[31:0]					 wdata_o
	
);

	
	always @ (*) begin
		if(rst == 1) begin
			wd_o <= 5'b0;
			wreg_o <= 1'b0;
		    wdata_o <= 32'b0;
		    we<=0;
		    addr<=0;
		    sel_o<=0;
		    mem_data_w<=0;
		end else begin
		    wd_o <= wd_i;
			wreg_o <= wreg_i;
			if(rw==2'b10) begin
			    wdata_o<=mem_data_r;
            end else begin
                wdata_o <= wdata_i;	
            end    	    	
		end 
end		 
    always @ (*) begin
        if(rst == 1) begin
            we<=1'b0;
            addr<=12'h000;
            sel_o<=4'b0000;
            mem_data_w<=32'h00000000;
        end else begin
            we<=rw[0];
            addr<=mem_addr;
            sel_o<=sel_i;
            mem_data_w<=mem_data;
	    end     
end			

endmodule
