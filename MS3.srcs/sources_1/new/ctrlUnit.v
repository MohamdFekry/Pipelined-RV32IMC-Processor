/*******************************************************************
*
* Module: ctrlUnit.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: takes the opcode and accordingly it outputs the controls needed to tell the components what to do 
*
*
**********************************************************************/

`include "defines.v"

module ctrlUnit(input[6:0] inst, output reg branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
                output reg[1:0] ALUOp, WhatToWrite);

    always@(*) begin
        case(inst)
            `OPCODE_Arith_R: {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b000_10_001_00;   //Arithamtic & M-extension
            `OPCODE_Load:    {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b011_00_011_00;   //Load
            `OPCODE_Store:   {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b00X_00_110_XX;   //store
            `OPCODE_Branch:  {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b10X_01_000_XX;   //Branch
            `OPCODE_Arith_I: {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b000_11_011_00;   //Arithmatic Imm
            `OPCODE_LUI:     {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b000_XX_0X1_11;   //LUI
            `OPCODE_AUIPC:   {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b000_XX_0X1_10;   //AUIPC
            `OPCODE_JAL:     {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b100_XX_0X1_01;   //JAL
            `OPCODE_JALR:    {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b100_00_011_01;   //JALR
            default:         {branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, WhatToWrite} = 10'b000_00_000_00;   //Fence, Ecall, Ebreak
        endcase
    end

endmodule

//ALUOp: 00 : LW & SW
//       01 : BEQ
//       10 : R-type
//       11 : I-type

//WhatToWrite: 00 : store data coming from ALU\memory
//             01 : store data represents JAL\Jalr
//             10 : store data represents AUIPC
//             11 : store data representing LUI coming from the ImmGen

//add a condition to make PC load = 0 when ECALL or EBREAK  (Done)

//STILL MISSING: add the modification of the ALUOp (Done)

//the branch unit control should determine to branch to JALR(rs1 + imm), PC + imm, PC + 4 (Done)

