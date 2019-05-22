`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 15:511:38
// Design Name: 
// Module Name: riscv_assembly
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
// ��ˮ�߶���
//////////////////////////////////////////////////////////////////////////////////
`include "define.v "

module riscv_assembly(
input wire  clk,
input wire  rst,

input wire[31:0]  inst,
output wire[11:0]  addr,
output wire  ce

    );
       
        wire[11:0] pc;
        //����IF_IDģ��������IDģ�������
        wire[31:0] id_inst_i;
        wire[11:0] id_pc_i;
        //��������׶�IDģ��������ID/EXģ�������
        wire[6:0] id_opcode_o;
        wire[2:0] id_funct3_o;
        wire[6:0] id_funct7_o;
        wire id_wreg_o;
        wire[4:0] id_wd_o;
        
        //����ID/EXģ��������ִ�н׶�EXģ�������
        wire[6:0] ex_opcode_i;
        wire[2:0] ex_funct3_i;
        wire[6:0] ex_funct7_i;
        wire[31:0] ex_reg1_i;
        wire[31:0] ex_reg2_i;
        wire ex_wreg_i;
        wire[4:0] ex_wd_i;
        wire[6:0] ex_opcode;
        
        //����ִ�н׶�EXģ��������EX/MEMģ�������
        wire ex_wreg_o;
        wire[4:0] ex_wd_o;
        wire[31:0] ex_wdata_o;
    
        //����EX/MEMģ��������ô�׶�MEMģ�������
        wire mem_wreg_i;
        wire[4:0] mem_wd_i;
        wire[31:0] mem_wdata_i;
    
        //���ӷô�׶�MEMģ��������MEM/WBģ�������
        wire mem_wreg_o;
        wire[4:0] mem_wd_o;
        wire[31:0] mem_wdata_o;
        
        //����MEM/WBģ���������д�׶ε�����    
        wire wb_wreg_i;
        wire[4:0] wb_wd_i;
        wire[31:0] wb_wdata_i;
        
        //��������׶�IDģ����ͨ�üĴ���Regfileģ��
      wire reg1_read;
      wire reg2_read;
      wire[31:0] reg1_data;
      wire[31:0] reg2_data;
      wire[4:0] reg1_addr;
      wire[4:0] reg2_addr;
       wire[31:0]  imm;
       wire[31:0]  ex_imm;
       
       //ram��д
      wire ram_we;
      wire[3:0] sel;
      wire[11:0] ram_addr;
      wire[31:0] ram_wdata;
      wire[31:0] ram_rdata;
      
      //ram��д���� ex�׶�
      wire[11:0] ex_pc_i;
      wire[11:0] ex_pc_o;
      
      wire[1:0] ex_mem_rw;
      wire[11:0] ex_mem_addr;
      wire[3:0]  ex_mem_sel;
      wire[31:0] ex_mem_data;
      
      //ram��д���� ex_mem�׶�
      wire[1:0] mem_rw_i;
      wire[11:0] mem_addr_i;
      wire[3:0]  mem_sel_i;
      wire[31:0] mem_data_i;
      
      //��ˮ����ͣ
      wire stall_id;
      wire stall_ex;
      wire[5:0] stall;
      //��ˢ
      wire[5:0] flash;
      //��֧
      wire[11:0] branch_pc;
      wire branch;
      
pc pcu(
              .clk(clk),
              .rst(rst),
              .pc(pc),
              .ce(ce),     
              .branch(branch),
              .branch_pc(branch_pc),
              .stall(stall)
          );
          
        assign addr = pc;
      
        //IF/IDģ������
          if_id if_idu(
          
              .clk(clk),
              .rst(rst),
              .pc_i(pc),
              .pc_o(id_pc_i),
              .if_inst(inst),
              .id_inst(id_inst_i),
              .stall(stall),
              .flash(flash)     
          );
          
          //����׶�IDģ��
          id idu(
          
              .rst(rst),
              .inst_i(id_inst_i),
              .imm_o(imm),
              .opcode_pro(ex_opcode),
              //�͵�regfile����Ϣ
              .reg1_read_o(reg1_read),
              .reg2_read_o(reg2_read),           
              .reg1_addr_o(reg1_addr),
              .reg2_addr_o(reg2_addr),            
              //�͵�ID/EXģ�����Ϣ
              .opcode_o(id_opcode_o),
              .funct3_o(id_funct3_o),
              .funct7_o(id_funct7_o),
              .wd_o(id_wd_o),
              .ex_wd(ex_wd_i),
              .wreg_o(id_wreg_o),
              .pc_i(id_pc_i),
              .pc_o(ex_pc_i),
              
              .stall_req(stall_id)
          );
      
        //ͨ�üĴ���Regfile����
          regfile regfileu(
              .clk (clk),
              .rst (rst),
              .we    (wb_wreg_i),
              .waddr (wb_wd_i),
              .wdata (wb_wdata_i),
              .re1 (reg1_read),
              .raddr1 (reg1_addr),
              .rdata1 (reg1_data),
              .re2 (reg2_read),
              .raddr2 (reg2_addr),
              .rdata2 (reg2_data),
               //����ִ�н׶ε�ָ��Ҫд���Ŀ�ļĴ�����Ϣ
              .ex_wreg(ex_wreg_o),
              .ex_wdata(ex_wdata_o),
              .ex_wd(ex_wd_o),
                //����mem�׶ε�ָ��Ҫд���Ŀ�ļĴ�����Ϣ
              .mem_wreg(mem_wreg_o),
              .mem_wdata(mem_wdata_o),
              .mem_wd(mem_wd_o)
          );
      
          //ID/EXģ��
          id_ex id_exu(
              .clk(clk),
              .rst(rst),
              .pc_i(ex_pc_i),
              .pc_o(ex_pc_o),
              //������׶�IDģ�鴫�ݵ���Ϣ
              .imm_i(imm),
              .id_opcode(id_opcode_o),
              .id_funct3(id_funct3_o),
              .id_funct7(id_funct7_o),
              .id_reg1(reg1_data),
              .id_reg2(reg2_data),
              .id_wd(id_wd_o),
              .id_wreg(id_wreg_o),
           
              //���ݵ�ִ�н׶�EXģ�����Ϣ
              .ex_opcode(ex_opcode_i),
              .ex_funct3(ex_funct3_i),
              .ex_funct7(ex_funct7_i),
              .ex_reg1(ex_reg1_i),
              .ex_reg2(ex_reg2_i),
              .ex_wd(ex_wd_i),
              .ex_wreg(ex_wreg_i),
              .imm_o(ex_imm),
              .opcode_o(ex_opcode),
              
              .stall(stall),
              .flash(flash)
          );        
          
          //EXģ��
          ex exu(
              .rst(rst),
              .pc_i(ex_pc_o),
              .pc_o(branch_pc),
              .branch(branch),
              //�͵�ִ�н׶�EXģ�����Ϣ
              .imm(ex_imm),
              .opcode(ex_opcode_i),
              .funct3(ex_funct3_i),
              .funct7(ex_funct7_i),
              .reg1(ex_reg1_i),
              .reg2(ex_reg2_i),
              .wd_i(ex_wd_i),
              .wreg_i(ex_wreg_i),
            
            //EXģ��������EX/MEMģ����Ϣ
              .wd_o(ex_wd_o),
              .wreg_o(ex_wreg_o),
              .wdata(ex_wdata_o),
              .mem_addr(ex_mem_addr),
              .rw(ex_mem_rw),
              .sel(ex_mem_sel),
              .mem_data(ex_mem_data),
              
              .stall_req(stall_ex)
          );
      
        //EX/MEMģ��
        ex_mem ex_memu(
              .clk(clk),
              .rst(rst),
            
              //����ִ�н׶�EXģ�����Ϣ    
              .ex_wd_i(ex_wd_o),
              .ex_wreg_i(ex_wreg_o),
              .ex_wdata_i(ex_wdata_o),
              
              .mem_addr_i(ex_mem_addr),
              .mem_rw_i(ex_mem_rw),
              .mem_sel_i(ex_mem_sel),
              .mem_data_i(ex_mem_data),
              
              .stall(stall),
              
             //�͵��ô�׶�MEMģ�����Ϣ
              .ex_wd_o(mem_wd_i),
              .ex_wreg_o(mem_wreg_i),
              .ex_wdata_o(mem_wdata_i),
              
              .mem_addr_o(mem_addr_i),
              .mem_rw_o(mem_rw_i),
              .mem_sel_o(mem_sel_i),
              .mem_data_o(mem_data_i)
                                         
          );
          
        //MEMģ������
          mem memu(
              .rst(rst),
          
              //����EX/MEMģ�����Ϣ    
              .wd_i(mem_wd_i),
              .wreg_i(mem_wreg_i),
              .wdata_i(mem_wdata_i),
              
              .mem_addr(mem_addr_i),
              .rw(mem_rw_i),
              .sel_i(mem_sel_i),
              .mem_data(mem_data_i),
              
              .we(ram_we),
              .addr(ram_addr),
              .sel_o(sel),
              .mem_data_r(ram_rdata),
              .mem_data_w(ram_wdata),
             
              //�͵�MEM/WBģ�����Ϣ
              .wd_o(mem_wd_o),
              .wreg_o(mem_wreg_o),
              .wdata_o(mem_wdata_o)
          );
          
          //����ram
        ram ramu(
             .clk(clk),
             .rst(rst),
             .we(ram_we),
             .addr(ram_addr),
             .sel(sel),
             .data_i(ram_wdata),
             .data_o(ram_rdata)
        );
        
        //MEM/WBģ��
          mem_wb mem_wbu(
          
              .clk(clk),
              .rst(rst),     
              //���Էô�׶�MEMģ�����Ϣ    
              .mem_wd(mem_wd_o),
              .mem_wreg(mem_wreg_o),
              .mem_wdata(mem_wdata_o),         
              //�͵���д�׶ε���Ϣ
              .wb_wd(wb_wd_i),
              .wb_wreg(wb_wreg_i),
              .wb_wdata(wb_wdata_i),             
              .stall(stall)                                                   
          );
          
          ctrl ctrlu(
          
          .rst(rst),
          .stallreq_from_id(stall_id),
          .stallreq_from_ex(stall_ex),
          .stall(stall)   , 
          .flash(flash)
          );
     
endmodule
