/*******************************************************************
*
* Module: ALU_ctrlUnit.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry. 
* Description: A module to handle which function is issued to the ALU 
*
*
**********************************************************************/

`include "defines.v"

module ALU_ctrlUnit(input[1:0] ALUOp, input[14:12] inst, input inst_30, inst_25,
                    output reg[4:0] ALUsel);

    wire [6:0] detector = {ALUOp, inst, inst_30, inst_25};
    
    always@(*) begin
        casex(detector)
            7'b00_XXX_X_X: ALUsel = `ALU_ADD;     //add for JALR, store, load    3
            7'b01_XXX_X_X: ALUsel = `ALU_SUB;     //sub for branch               4
            //I-type
            7'b11_111_X_X: ALUsel = `ALU_AND;     //ANDI   0
            7'b11_110_X_X: ALUsel = `ALU_OR;      //ORI    1
            7'b11_100_X_X: ALUsel = `ALU_XOR;     //XORI   2
            7'b11_000_X_X: ALUsel = `ALU_ADD;     //ADDI   3
            7'b11_010_X_X: ALUsel = `ALU_SLT;     //SLTI   5
            7'b11_011_X_X: ALUsel = `ALU_SLTU;    //SLTIU  6
            7'b11_001_0_0: ALUsel = `ALU_SLLI;    //SLLI   7
            7'b11_101_0_0: ALUsel = `ALU_SRLI;    //SRLI   8
            7'b11_101_1_0: ALUsel = `ALU_SRAI;    //SRAI   9
            //R-type
            7'b10_111_0_0: ALUsel = `ALU_AND;     //AND  0 
            7'b10_110_0_0: ALUsel = `ALU_OR;      //OR   1
            7'b10_100_0_0: ALUsel = `ALU_XOR;     //XOR  2
            7'b10_000_0_0: ALUsel = `ALU_ADD;     //ADD  3
            7'b10_000_1_0: ALUsel = `ALU_SUB;     //SUB  4
            7'b10_010_0_0: ALUsel = `ALU_SLT;     //SLT  5
            7'b10_011_0_0: ALUsel = `ALU_SLTU;    //SLTU 6
            7'b10_001_0_0: ALUsel = `ALU_SLL;     //SLL  10
            7'b10_101_0_0: ALUsel = `ALU_SRL;     //SRL  11
            7'b10_101_1_0: ALUsel = `ALU_SRA;     //SRA  12
            //M-extension
            7'b10_000_0_1: ALUsel = `ALU_MUL;     //MUL     13 
            7'b10_001_0_1: ALUsel = `ALU_MULH;    //MULH    14
            7'b10_010_0_1: ALUsel = `ALU_MULHSU;  //MULHSU  15
            7'b10_011_0_1: ALUsel = `ALU_MULHU;   //MULHU   16
            7'b10_100_0_1: ALUsel = `ALU_DIV;     //DIV     17
            7'b10_101_0_1: ALUsel = `ALU_DIVU;    //DIVU    18
            7'b10_110_0_1: ALUsel = `ALU_REM;     //REM     19
            7'b10_111_0_1: ALUsel = `ALU_REMU;    //REMU    20
            default: ALUsel = 5'b11111;   //zero the ALU result   31
        endcase
    end

endmodule


