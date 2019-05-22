`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:59:40
// Design Name: 
// Module Name: ex
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


module ex(
           input wire rst,
          
           input wire[11:0] pc_i,
           input wire[31:0] imm,
           input wire[6:0] opcode,
           input wire[2:0] funct3,
           input wire[6:0] funct7,
           input wire[31:0] reg1,
           input wire[31:0] reg2,
           input wire[4:0] wd_i,
           input wire wreg_i,
           
           output wire[4:0] wd_o,
           output reg[31:0] wdata,
           output wire wreg_o,
           output reg[11:0] mem_addr,
           output reg[1:0] rw,
           output reg[3:0] sel,
           output reg[31:0] mem_data,
          
           output reg stall_req,
           
           //跳转
           output reg[11:0] pc_o,
           output reg branch
    );
    
    wire signed[31:0]  reg_1=reg1;//有符号数
    wire signed[31:0]  reg_2=reg2;
    wire signed[31:0]  imm_=imm;
    
    wire[4:0] wd=wd_i;
    wire wreg=wreg_i;
    
    always @ (*) begin
       if(rst==1) begin
          wdata<=0; mem_addr=0; rw=0; sel=0; mem_data=0;
       end else begin 
          branch=0; rw<=2'b11;stall_req=0; 
          case (opcode)
              7'b0110011: begin  //R型指令
                     case(funct3)
                              3'b000:begin
                                     case(funct7)
                                         7'b0000000:begin//add
                                             wdata<=reg1+reg2; 
                                         end    
                                         7'b0100000:begin//sub
                                             wdata<=reg1-reg2; 
                                         end
                                     endcase  
                              end
                              3'b001:begin//SLL
                                   wdata<=reg1<<reg2[4:0];
                              end
                              3'b010:begin//SLT
                                   wdata<= (reg_1<reg_2) ? 1 : 0;   
                              end 
                              3'b011:begin//SLTU
                                   wdata<=(reg1<reg2) ? 1 : 0;    
                              end
                              3'b100:begin//XOR
                                  wdata<= reg1^reg2;
                              end
                              3'b101:begin
                                      case(funct7)
                                            7'b0000000:begin//SRL
                                                   wdata<=reg1>>reg2[4:0]; 
                                             end    
                                             7'b0100000:begin//SRA
                                                   wdata<=reg_1>>>reg2[4:0];
                                                   //
                                             end
                                      endcase  
                              end
                              3'b110:begin//OR
                                     wdata<=reg1|reg2;   
                              end
                              3'b111:begin//AND
                                     wdata<= reg1&reg2;
                              end    
                     endcase
               end                                    
            7'b0010011: begin  //I型指令
                  case(funct3)
                      3'b000:begin//ADDI
                           wdata<=reg1+imm;
                      end
                      3'b001:begin//SLLI
                           wdata<=reg1<<imm[4:0];
                      end
                      3'b010:begin//SLTI
                           wdata<= (reg_1<imm_) ? 1 : 0; 
                      end
                      3'b011:begin//SLTIU
                           wdata<= (reg1<imm) ? 1 : 0;
                      end
                      3'b100:begin//XORI
                           wdata<=reg1^imm;
                      end
                      3'b101:begin
                           case(funct7)
                                 7'b0000000:begin//SRLI
                                        wdata<=reg1>>imm[4:0]; 
                                 end    
                                 7'b0100000:begin//SRAI
                                        wdata<=reg_1>>>imm[4:0]; 
                                 end
                           endcase  
                      end
                      3'b110:begin//ORI
                           wdata<=reg1|imm;
                      end
                      3'b111:begin//ANDI
                           wdata<=reg1&imm;
                      end
                  endcase
            end//i
           7'b0100011: begin//S型指令 （store）
                  case(funct3)
                        3'b000:begin//SB
                               mem_addr<=reg1[11:0]+imm[11:0];
                               rw<=2'b01;
                               sel<=4'b0001;
                               mem_data<=reg2;
                        end
                        3'b001:begin//SH
                               mem_addr<=reg1[11:0]+imm[11:0];
                               rw<=2'b01;
                               sel<=4'b0011;
                               mem_data<=reg2;
                        end
                        3'b010:begin//SW
                               mem_addr<=reg1[11:0]+imm[11:0];
                               rw<=2'b01;
                               sel<=4'b1111;
                               mem_data<=reg2;
                        end   
                  endcase
           end             
           7'b0000011: begin//I型指令 （load）
                   case(funct3)
                         3'b000:begin//LB
                                 mem_addr<=reg1[11:0]+imm[11:0];
                                 rw<=2'b10;
                                 sel<=4'b1000;                         
                         end
                         3'b001:begin//LH
                                 mem_addr<=reg1[11:0]+imm[11:0];
                                 rw<=2'b10;
                                 sel<=4'b1100;  
                         end
                         3'b010:begin//LW
                                 mem_addr<=reg1[11:0]+imm[11:0];
                                 rw<=2'b10;
                                 sel<=4'b1111;  
                         end
                         3'b011:begin//LBU
                                mem_addr<=reg1[11:0]+imm[11:0];
                                rw<=2'b10;
                                sel<=4'b0011;  
                         end
                         3'b100:begin//LHU
                                 mem_addr<=reg1[11:0]+imm[11:0];
                                 rw<=2'b10;
                                 sel<=4'b0001;   
                         end
                   endcase
           end//
           7'b0110111: begin //lui
                wdata<=imm;
           end
           7'b1100011: begin //跳转
                 case(funct3)
                     3'b000:begin//beq
                          if(reg1==reg2) begin
                             pc_o<=pc_i+imm;
                               //pc_o<=imm[11:0];  
                              branch<=1;
                          end    
                     end  
                     3'b001:begin//bne
                          if(reg1!=reg2) begin
                              pc_o<=pc_i+imm;
                               //pc_o<=imm[11:0]; 
                              branch<=1;
                          end    
                     end
                     3'b010:begin//blt
                          if(reg_1<reg_2) begin
                               pc_o<=pc_i+imm;
                               branch<=1;
                          end    
                     end
                     3'b011:begin//bge
                           if(reg_1>reg_2) begin
                                pc_o<=pc_i+imm;
                                branch<=1;
                           end  
                     end
                     3'b100:begin//bltu
                           if(reg1<reg2) begin
                                pc_o<=pc_i+imm;
                                branch<=1;
                           end  
                     end
                     3'b101:begin//bgeu
                           if(reg1>reg2) begin
                                 pc_o<=pc_i+imm;
                                 branch<=1;
                           end  
                     end
                endcase   
            end
             7'b1101111: begin //jal
                pc_o<=pc_i+imm;
                branch<=1;
                wdata<=pc_i+4;
             end
               7'b1100111: begin //jal
                           pc_o<=reg1+imm;
                           branch<=1;
                           wdata<=pc_i+4;
            end
             7'b0010111: begin //auipc
                          wdata<=pc_i+imm;
            end
           endcase
           end
          end
          
            always @ (*) begin
              stall_req<=0;
              if(((opcode==7'b1100011)|(opcode==7'b1101111)|(opcode==7'b1100111))&&branch==1)begin
                  stall_req<=1;    
              end
           end   
          assign wd_o=wd;
          assign wreg_o=wreg;
endmodule
