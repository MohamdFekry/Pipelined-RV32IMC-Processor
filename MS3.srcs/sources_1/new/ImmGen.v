/*******************************************************************
*
* Module: ImmGen.v
* Project: RV32IMC Processor
* Author: Sharaf, Amr Gonied
* Description: a 2 input 32 bit mux that uses 32 instances of the 2 input 1 bit mux to sellect between 
*
*
*
**********************************************************************/


`include "defines.v"

module ImmGen (input[31:0] instruction,
               output reg[31:0] Imm);

    always @(*) begin
        case (instruction[6:0])
             `OPCODE_Arith_I   : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                              //arith imm
             `OPCODE_Store     :    Imm = { {21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7] };                                 //store
             `OPCODE_Load      : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                               //LOAD
             `OPCODE_LUI       :    Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };                                              //LUI
             `OPCODE_AUIPC     :    Imm = { instruction[31], instruction[30:20], instruction[19:12], 12'b0 };                                              //AUIPC
             `OPCODE_JAL       : 	Imm = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0 };   //JAL
             `OPCODE_JALR      : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                            //JALR
             `OPCODE_Branch    : 	Imm = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};                         //branch
             default           : 	Imm = { {21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20] };                           // IMM_I
        endcase 
    end
endmodule