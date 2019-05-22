`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/28 16:58:46
// Design Name: 
// Module Name: id
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

module id(
input wire rst,
input wire[11:0] pc_i,
input wire[31:0] inst_i,
input wire[6:0]  opcode_pro,
input wire[4:0] ex_wd,

output wire[11:0] pc_o,
output reg  reg1_read_o,
output reg[4:0]  reg1_addr_o,
output reg  reg2_read_o,
output reg[4:0]  reg2_addr_o,

output reg[6:0] opcode_o,
output reg[2:0] funct3_o,
output reg[6:0] funct7_o,
output reg[4:0] wd_o,
output reg wreg_o,
output reg[31:0] imm_o,
//output wire[31:0] inst_o,

output wire stall_req
    );
    wire[6:0] opcode=inst_i[6:0];
    wire[3:0] funct3=inst_i[14:12];
    wire[4:0] rd=inst_i[11:7];
    wire[4:0] rs1=inst_i[19:15];
    wire[4:0] rs2=inst_i[24:20];
    wire[6:0] funct7=inst_i[31:25];
    reg [3:0] type;
    reg stall_req1;
    reg stall_req2;
    reg pro_load;
    
    assign stall_req=stall_req1|stall_req2;
    assign pc_o=pc_i;
    
  always @ (*) begin
         if(opcode_pro==7'b0000011) begin
           pro_load=1;
           end else begin
           pro_load=0;
        end
      end
   
  always @ (*) begin
      case (opcode)
       7'b0110011: begin  type<=4'b0000;end//r
       7'b0010011: begin  type<=4'b0001;end//i
       7'b0100011: begin  type<=4'b0010;end//store
       7'b0000011: begin  type<=4'b0011;end//load
       7'b0110111: begin  type<=4'b0100;end//LUI
       7'b1100011: begin  type<=4'b0101;end//Ìø×ª
       7'b1101111: begin  type<=4'b0110;end//jal
       7'b1100111: begin  type<=4'b0111;end//jalr
       7'b0010111: begin  type<=4'b1000;end//auipc
       endcase
      end
      
   always @ (*) begin
         if (rst == 1) begin
            reg1_read_o<=0;  reg2_read_o<=0;  reg1_addr_o<=0;  reg2_addr_o<=0; opcode_o<=0;  funct3_o<=0;  funct7_o<=0;  wd_o<=rd;    wreg_o<=1;
       end
     end  
    always @ (*) begin   
            case (type)
             4'b0000: begin  
                    reg1_read_o<=1;  reg2_read_o<=1;  reg1_addr_o<=rs1;  reg2_addr_o<=rs2;  opcode_o<=opcode;  funct3_o<=funct3;  funct7_o<=funct7;  wd_o<=rd;   wreg_o<=1;
              end//r
             4'b0001: begin  
                   imm_o<={{20{inst_i[31]}} , inst_i[31:20]};
                   reg1_read_o<=1;    reg2_read_o<=0;  reg1_addr_o<=rs1;  reg2_addr_o<=rs2;   opcode_o<=opcode;  funct3_o<=funct3;  funct7_o<=funct7;   wd_o<=rd;  wreg_o<=1;
             end//i
             4'b0010: begin  
                   imm_o<={{20{inst_i[31]}} , inst_i[31:25],inst_i[11:7]};
                   reg1_read_o<=1;    reg2_read_o<=1;  reg1_addr_o<=rs1;   reg2_addr_o<=rs2;   opcode_o<=opcode;   funct3_o<=funct3;  funct7_o<=funct7;  wd_o<=rd;  wreg_o<=0;
             end//store
             4'b0011: begin  
                   imm_o<={{20{inst_i[31]}} , inst_i[31:20]};                  
                   reg1_read_o<=1;  reg2_read_o<=0;    reg1_addr_o<=rs1;   reg2_addr_o<=rs2;    opcode_o<=opcode;  funct3_o<=funct3;   funct7_o<=funct7;  wd_o<=rd;  wreg_o<=1;
             end//load
             4'b0100: begin  
                   imm_o<={inst_i[31:12],12'h000};
                   reg1_read_o<=0; reg2_read_o<=0;    reg1_addr_o<=rs1;     reg2_addr_o<=rs2;    opcode_o<=opcode;   funct3_o<=funct3;   funct7_o<=funct7;  wd_o<=rd; wreg_o<=1;
             end//lui
             4'b0101: begin  
                   imm_o<={{20{inst_i[31]}} , inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
                   reg1_read_o<=1; reg2_read_o<=1;    reg1_addr_o<=rs1;      reg2_addr_o<=rs2;   opcode_o<=opcode;    funct3_o<=funct3;   funct7_o<=funct7;wd_o<=rd;  wreg_o<=0;
             end//Ìø×ª
            4'b0110: begin  
                   imm_o<={{12{inst_i[31]}} , inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
                    reg1_read_o<=0;  reg2_read_o<=0;   reg1_addr_o<=rs1;      reg2_addr_o<=rs2;     opcode_o<=opcode;     funct3_o<=funct3; funct7_o<=funct7; wd_o<=rd; wreg_o<=1;  
               end//jal
             4'b0110: begin  
                    imm_o<={{20{inst_i[31]}} , inst_i[31:20]};
                    reg1_read_o<=1;  reg2_read_o<=0;   reg1_addr_o<=rs1;     reg2_addr_o<=rs2;     opcode_o<=opcode;     funct3_o<=funct3;   funct7_o<=funct7; wd_o<=rd;wreg_o<=1;  
                end//jalr
              4'b1000: begin  
                    imm_o<={inst_i[31:12],12'h000};
                    reg1_read_o<=0;  reg2_read_o<=0;    reg1_addr_o<=rs1;    reg2_addr_o<=rs2;      opcode_o<=opcode;    funct3_o<=funct3;    funct7_o<=funct7;  wd_o<=rd;  wreg_o<=1;  
               end//auipc
          endcase
      end
    
         always @ (*) begin
                stall_req1<= 0;    
                 if(pro_load == 1'b1 && ex_wd == reg1_addr_o 
                                    && reg1_read_o == 1'b1 ) begin
                 stall_req1<= 1;                           
          end
        end
        
        always @ (*) begin
                stall_req2<= 0;
                if(pro_load == 1'b1 && ex_wd == reg2_addr_o 
                                    && reg2_read_o == 1'b1 ) begin
                stall_req2 <= 1;                 
           end
        end
        
endmodule
     
