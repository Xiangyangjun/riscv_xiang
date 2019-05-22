`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 15:56:19
// Design Name: 
// Module Name: rom
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
//÷∏¡Órom£¨¥Û–°4kb

module rom(
    input wire              ce, 
    input wire[11:0]	    addr,
	output reg[31:0]		inst
    );
    
    reg[31:0]  inst_mem[1023:0];
    
        initial $readmemh ( "G:/rom.data", inst_mem );
    
        always @ (*) begin
           if (ce == 0) begin
               inst <= 32'b0;
          end else begin
              inst <= inst_mem[addr[11:2]];
            end
        end

endmodule
