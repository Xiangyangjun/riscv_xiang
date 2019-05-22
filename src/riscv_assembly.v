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
// 流水线顶层
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
        //连接IF_ID模块的输出与ID模块的输入
        wire[31:0] id_inst_i;
        wire[11:0] id_pc_i;
        //连接译码阶段ID模块的输出与ID/EX模块的输入
        wire[6:0] id_opcode_o;
        wire[2:0] id_funct3_o;
        wire[6:0] id_funct7_o;
        wire id_wreg_o;
        wire[4:0] id_wd_o;
        
        //连接ID/EX模块的输出与执行阶段EX模块的输入
        wire[6:0] ex_opcode_i;
        wire[2:0] ex_funct3_i;
        wire[6:0] ex_funct7_i;
        wire[31:0] ex_reg1_i;
        wire[31:0] ex_reg2_i;
        wire ex_wreg_i;
        wire[4:0] ex_wd_i;
        wire[6:0] ex_opcode;
        
        //连接执行阶段EX模块的输出与EX/MEM模块的输入
        wire ex_wreg_o;
        wire[4:0] ex_wd_o;
        wire[31:0] ex_wdata_o;
    
        //连接EX/MEM模块的输出与访存阶段MEM模块的输入
        wire mem_wreg_i;
        wire[4:0] mem_wd_i;
        wire[31:0] mem_wdata_i;
    
        //连接访存阶段MEM模块的输出与MEM/WB模块的输入
        wire mem_wreg_o;
        wire[4:0] mem_wd_o;
        wire[31:0] mem_wdata_o;
        
        //连接MEM/WB模块的输出与回写阶段的输入    
        wire wb_wreg_i;
        wire[4:0] wb_wd_i;
        wire[31:0] wb_wdata_i;
        
        //连接译码阶段ID模块与通用寄存器Regfile模块
      wire reg1_read;
      wire reg2_read;
      wire[31:0] reg1_data;
      wire[31:0] reg2_data;
      wire[4:0] reg1_addr;
      wire[4:0] reg2_addr;
       wire[31:0]  imm;
       wire[31:0]  ex_imm;
       
       //ram读写
      wire ram_we;
      wire[3:0] sel;
      wire[11:0] ram_addr;
      wire[31:0] ram_wdata;
      wire[31:0] ram_rdata;
      
      //ram读写控制 ex阶段
      wire[11:0] ex_pc_i;
      wire[11:0] ex_pc_o;
      
      wire[1:0] ex_mem_rw;
      wire[11:0] ex_mem_addr;
      wire[3:0]  ex_mem_sel;
      wire[31:0] ex_mem_data;
      
      //ram读写控制 ex_mem阶段
      wire[1:0] mem_rw_i;
      wire[11:0] mem_addr_i;
      wire[3:0]  mem_sel_i;
      wire[31:0] mem_data_i;
      
      //流水线暂停
      wire stall_id;
      wire stall_ex;
      wire[5:0] stall;
      //冲刷
      wire[5:0] flash;
      //分支
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
      
        //IF/ID模块例化
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
          
          //译码阶段ID模块
          id idu(
          
              .rst(rst),
              .inst_i(id_inst_i),
              .imm_o(imm),
              .opcode_pro(ex_opcode),
              //送到regfile的信息
              .reg1_read_o(reg1_read),
              .reg2_read_o(reg2_read),           
              .reg1_addr_o(reg1_addr),
              .reg2_addr_o(reg2_addr),            
              //送到ID/EX模块的信息
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
      
        //通用寄存器Regfile例化
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
               //处于执行阶段的指令要写入的目的寄存器信息
              .ex_wreg(ex_wreg_o),
              .ex_wdata(ex_wdata_o),
              .ex_wd(ex_wd_o),
                //处于mem阶段的指令要写入的目的寄存器信息
              .mem_wreg(mem_wreg_o),
              .mem_wdata(mem_wdata_o),
              .mem_wd(mem_wd_o)
          );
      
          //ID/EX模块
          id_ex id_exu(
              .clk(clk),
              .rst(rst),
              .pc_i(ex_pc_i),
              .pc_o(ex_pc_o),
              //从译码阶段ID模块传递的信息
              .imm_i(imm),
              .id_opcode(id_opcode_o),
              .id_funct3(id_funct3_o),
              .id_funct7(id_funct7_o),
              .id_reg1(reg1_data),
              .id_reg2(reg2_data),
              .id_wd(id_wd_o),
              .id_wreg(id_wreg_o),
           
              //传递到执行阶段EX模块的信息
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
          
          //EX模块
          ex exu(
              .rst(rst),
              .pc_i(ex_pc_o),
              .pc_o(branch_pc),
              .branch(branch),
              //送到执行阶段EX模块的信息
              .imm(ex_imm),
              .opcode(ex_opcode_i),
              .funct3(ex_funct3_i),
              .funct7(ex_funct7_i),
              .reg1(ex_reg1_i),
              .reg2(ex_reg2_i),
              .wd_i(ex_wd_i),
              .wreg_i(ex_wreg_i),
            
            //EX模块的输出到EX/MEM模块信息
              .wd_o(ex_wd_o),
              .wreg_o(ex_wreg_o),
              .wdata(ex_wdata_o),
              .mem_addr(ex_mem_addr),
              .rw(ex_mem_rw),
              .sel(ex_mem_sel),
              .mem_data(ex_mem_data),
              
              .stall_req(stall_ex)
          );
      
        //EX/MEM模块
        ex_mem ex_memu(
              .clk(clk),
              .rst(rst),
            
              //来自执行阶段EX模块的信息    
              .ex_wd_i(ex_wd_o),
              .ex_wreg_i(ex_wreg_o),
              .ex_wdata_i(ex_wdata_o),
              
              .mem_addr_i(ex_mem_addr),
              .mem_rw_i(ex_mem_rw),
              .mem_sel_i(ex_mem_sel),
              .mem_data_i(ex_mem_data),
              
              .stall(stall),
              
             //送到访存阶段MEM模块的信息
              .ex_wd_o(mem_wd_i),
              .ex_wreg_o(mem_wreg_i),
              .ex_wdata_o(mem_wdata_i),
              
              .mem_addr_o(mem_addr_i),
              .mem_rw_o(mem_rw_i),
              .mem_sel_o(mem_sel_i),
              .mem_data_o(mem_data_i)
                                         
          );
          
        //MEM模块例化
          mem memu(
              .rst(rst),
          
              //来自EX/MEM模块的信息    
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
             
              //送到MEM/WB模块的信息
              .wd_o(mem_wd_o),
              .wreg_o(mem_wreg_o),
              .wdata_o(mem_wdata_o)
          );
          
          //数据ram
        ram ramu(
             .clk(clk),
             .rst(rst),
             .we(ram_we),
             .addr(ram_addr),
             .sel(sel),
             .data_i(ram_wdata),
             .data_o(ram_rdata)
        );
        
        //MEM/WB模块
          mem_wb mem_wbu(
          
              .clk(clk),
              .rst(rst),     
              //来自访存阶段MEM模块的信息    
              .mem_wd(mem_wd_o),
              .mem_wreg(mem_wreg_o),
              .mem_wdata(mem_wdata_o),         
              //送到回写阶段的信息
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
