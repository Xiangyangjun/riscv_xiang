`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/03 15:02:311
// Design Name: 
// Module Name: ram
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
module ram(

	input wire									clk,
	input wire									rst,
	input wire										we,
	input wire[11:0]			addr,
	input wire[3:0]								sel,
	input wire[31:0]						data_i,
	output reg[31:0]					data_o
	
);
integer i,j,k,l;
	reg[7:0]  data_mem0[0:1023];
	reg[7:0]  data_mem1[0:1023];
	reg[7:0]  data_mem2[0:1023];
	reg[7:0]  data_mem3[0:1023];

	always @ (posedge clk) begin
		if (rst == 1 )begin
		     for(i=0;i<1024;i=i+1)
                   data_mem0[i] <= 8'b0;
             for(j=0;j<1024;j=j+1)
                   data_mem1[j] <= 8'b0;
             for(k=0;k<1024;k=k+1)
                   data_mem2[k] <= 8'b0;
             for(l=0;l<1024;l=l+1)
                   data_mem3[l] <= 8'b0;  
			//data_o <= ZeroWord;
		end else if(we == 1) begin
			  if (sel[3] == 1'b1) begin
		      data_mem3[addr[11:2]] <= data_i[31:24];
		    end
			  if (sel[2] == 1'b1) begin
		      data_mem2[addr[11:2]] <= data_i[23:16];
		    end
		    if (sel[1] == 1'b1) begin
		      data_mem1[addr[11:2]] <= data_i[15:8];
		    end
			  if (sel[0] == 1'b1) begin
		      data_mem0[addr[11:2]] <= data_i[7:0];
		    end			   	    
		end
	end
	
	always @ (*) begin
		if (rst == 1) begin
			data_o <= 31'h00000000;
	  end else if(we == 0) begin
	         if(sel[0]==0) begin
		        if (sel[3] == 1'b1) begin
                     data_o[31:24] <= data_mem3[addr[11:2]];
                end else begin
                     data_o[31:24] <= 8'b0;
                end
                if (sel[2] == 1'b1) begin
                     data_o[23:16] <= data_mem2[addr[11:2]];
                end else begin
                     data_o[23:16] <= 8'b0;
                end
                if (sel[1] == 1'b1) begin
                     data_o[15:8] <= data_mem1[addr[11:2]];
                end else begin
                     data_o[15:8] <= 8'b0;
                end     
                if (sel[0] == 1'b1) begin
                     data_o[7:0] <= data_mem0[addr[11:2]];
                end     
             end else begin
                if(sel[2]==0) begin
                    data_o[31:24] <= {8{data_mem0[addr[11:2]][7]}};
                    data_o[23:16] <= {8{data_mem0[addr[11:2]][7]}};
                    data_o[15:8] <= {8{data_mem0[addr[11:2]][7]}};
                    data_o[7:0] <= data_mem0[addr[11:2]]; 
                end else begin
                    data_o[31:24] <= {8{data_mem1[addr[11:2]][7]}};
                    data_o[23:16] <= {8{data_mem1[addr[11:2]][7]}};
                    data_o[15:8] <= data_mem1[addr[11:2]];
                    data_o[7:0] <= data_mem0[addr[11:2]];  
                end 
             end          
		end else begin
				data_o <= 31'h00000000;
		end
	end		

endmodule
