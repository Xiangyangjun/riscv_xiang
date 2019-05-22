# riscv_xiang
## riscv
RISC-V is a free and open ISA enabling a new era of processor innovation through open standard collaboration. Born in academia and research, RISC-V ISA delivers a new level of free, extensible software and hardware freedom on architecture, paving the way for the next 50 years of computing design and innovation.
## xiang
xiang is a very easy cpu with RISC-V ISA.
##Implemented instructions
RType: Type of R-Type Instruction （10） add/sub sll slt sltu xor srl sra or and \n
IType: Tyoe of Imm Instruction （11 addi slti sltiu xori ori andi slli srli/srai
BrType:Type of Branch Instruction （6） BEQ/BNE/BLT/BLTU/BGE/BGEU
JType:Type of Jump Instruction （2）
LdType:Type of Load Instruction (5) lb lh lw lbu lhu
StType:Type of Store Instruction store 3) sb sh sw
LUI/AUIPC
