`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 15:45:08
// Design Name: 
// Module Name: riscv_xiang
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
// the top of riscv
//////////////////////////////////////////////////////////////////////////////////
`include "define.v "

module riscv_xiang(
input wire clk,
input wire rst 
    );
//����
 wire[11:0] inst_addr;//ָ���ַ
 wire[31:0] inst;//ָ��
 wire rom_ce;//ȡֵʹ���ź�
   
riscv_assembly riscv_assembly_0(
    .clk(clk),
    .rst(rst),
    .inst(inst),
    .addr(inst_addr),
    .ce(rom_ce)
    
);//��ˮ��

rom rom_0(
    .addr(inst_addr),
    .ce(rom_ce),
    .inst(inst)
);//ָ��rom
    
endmodule
