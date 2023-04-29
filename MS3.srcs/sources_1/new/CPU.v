/*******************************************************************
*
* Module: CPU.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: the connection between all the modules to build the sigle-cycle processor
* Change history: 30/6/2022 – Ahmed Shalaby re organized the wires to match the project requirments
* 
*
*
**********************************************************************/
/*
module CPU(input clk, rst);

    wire [31:0] address_in, target_address, instruction, gen_out;
    wire load;
    wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire cf, zf, vf, sf;
    wire [1:0] ALUOp, WhatToWrite, muxPC_Sel;
    wire [4:0] ALUsel;
    wire [4:0] readreg1 = instruction[19:15], readreg2 = instruction[24:20], writereg = instruction[11:7], shamt = instruction[24:20];
    wire [2:0] fun3 = instruction[14:12];
    wire [31:0] readdata1, readdata2, MemVSALU, writedata, ALU_in2, ALU_result, dataMem_out, pc_plus4, pc_jump;
    
    //lama tla2y el Ecall aw Ebreak eb3t el PC el asly
    //~(instruction[4] & instruction[6] & instruction[5]) to handle ECALL & EBREAK
    //reg32 PC(address_in, ~(instruction[6] & instruction[5] & instruction[4]), rst, clk, target_address);
    reg32 PC(address_in, 1'b1, rst, clk, target_address);
    RCA32 plus4_address(target_address, 4, pc_plus4);
    InstMem instructions(target_address[7:2], instruction);
    ctrlUnit control(instruction[6:2], branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, WhatToWrite);
    RegFile file(clk, rst, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
    ImmGen gen(instruction, gen_out);
    ALU_ctrlUnit ALU_Ctrl(ALUOp, fun3, instruction[30], instruction[25], ALUsel);
    MUX32_2 MUX_ALU(readdata2, gen_out, ALUSrc, ALU_in2);
    ALU32 ALU(readdata1, ALU_in2, ALUsel, shamt, ALU_result, cf, zf, vf, sf);
    DataMem datas(clk, MemRead, MemWrite, fun3, ALU_result[7:0], readdata2, dataMem_out);
    MUX32_2 MUX_MemALU(ALU_result, dataMem_out, MemtoReg, MemVSALU);
    RCA32 jump_address (target_address, gen_out, pc_jump);
    MUX32_4 MUX_Writedata(MemVSALU, pc_plus4, pc_jump, gen_out, WhatToWrite, writedata);
    BranchUnit branchCtrl(cf, zf, vf, sf, branch, fun3, instruction[2], instruction[3], instruction[6:4], muxPC_Sel);
    MUX32_4 MUX_PC(target_address, ALU_result, pc_plus4, pc_jump, muxPC_Sel, address_in);

endmodule
*/

module CPU(input clk, rst);
    wire compressed_flag;
    wire [31:0] pc_add_value;
    wire [31:0] address_in, target_address, instruction, gen_out;
    wire load;
    wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire cf, zf, vf, sf;
    wire [1:0] ALUOp, WhatToWrite, muxPC_Sel;
    wire [4:0] ALUsel;
    wire [4:0] readreg1 = instruction[19:15], readreg2 = instruction[24:20], writereg = instruction[11:7], shamt = instruction[24:20];
    wire [2:0] fun3 = instruction[14:12];
    wire [31:0] readdata1, readdata2, MemVSALU, writedata, ALU_in2, ALU_result, dataMem_out, pc_plus4, pc_jump, uncompressed, instruction_final;
    
    
    //lama tla2y el Ecall aw Ebreak eb3t el PC el asly
    //~(instruction[4] & instruction[6] & instruction[5]) to handle ECALL & EBREAK
    //reg32 PC(address_in, ~(instruction[6] & instruction[5] & instruction[4]), rst, clk, target_address);
    register PC(address_in, 1'b1, rst, clk, target_address);
                 MUX_2X1 pc_add_2_or_4(2, 4, compressed_flag, pc_add_value );
                 RCA32 plus4_address(target_address, pc_add_value, pc_plus4);          
    //InstMem instructions(target_address[7:2], instruction);
                compressed_unit expand(instruction [15:0], uncompressed, compressed_flag);
                MUX_2X1 choose_expaned_or_inst(uncompressed, instruction, compressed_flag, instruction_final);
    
    ctrlUnit control(instruction_final[6:0], branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, WhatToWrite);
    RegFile file(clk, rst, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
    ImmGen gen(instruction_final, gen_out);
    
    ALU_ctrlUnit ALU_Ctrl(ALUOp, fun3, instruction_final[30], instruction_final[25], ALUsel);
    MUX_2X1 MUX_ALU(readdata2, gen_out, ALUSrc, ALU_in2);
    ALU32 ALU(readdata1, ALU_in2, ALUsel, shamt, ALU_result, cf, zf, vf, sf);
    RCA32 jump_address (target_address, gen_out, pc_jump);
    
    //DataMem datas(clk, MemRead, MemWrite, fun3, ALU_result[7:0], readdata2, dataMem_out);
    
    BranchUnit branchCtrl(cf, zf, vf, sf, branch, fun3, instruction_final[2], instruction_final[3], instruction_final[6:4], muxPC_Sel);
    MUX_4X1 MUX_PC(target_address, ALU_result, pc_plus4, pc_jump, muxPC_Sel, address_in);
    
    MUX_2X1 MUX_MemALU(ALU_result, dataMem_out, MemtoReg, MemVSALU);
    MUX_4X1 MUX_Writedata(MemVSALU, pc_plus4, pc_jump, gen_out, WhatToWrite, writedata);
    Memory mem(target_address[9:0], instruction, //inst_Mem
            ALU_result[9:0], readdata2, clk, MemRead, MemWrite, fun3, dataMem_out);  
    
    
endmodule
