/*******************************************************************
*
* Module: BranchUnit.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, AHmed Shalaby, and Mohamed Fekry.
* Description: used to choose which pc instruction to jump to. 
*
*
*
**********************************************************************/


`include "defines.v"

module BranchUnit(input cf, zf, vf, sf, branch, input[14:12] fun3, input inst_2, inst_3, input[6:4] halt, output reg [1:0] muxSel);
//                                                                 for JALR & JAL    for ebreak, ecall
reg flag;
always@(*) begin
    if (~inst_2) begin
        if (branch) begin
            case(fun3)
                `BR_BEQ: flag = zf;          //beq
                `BR_BNE: flag = ~zf;         //bne
                `BR_BLT: flag = (sf != vf);  //blt
                `BR_BGE: flag = (sf == vf);  //bge
                `BR_BLTU: flag = ~cf;        //bltu
                `BR_BGEU: flag = cf;         //bgeu
                default: flag = 3'bZZZ;
            endcase
        end
    end
end

always@(*) begin
//branch\JAL(pc = pc+offset): 11,   pc = pc: 00,  JALR(pc = rs1+imm): 01,   pc +=4: 10
    if(inst_2 && branch && ~inst_3)
        muxSel = 2'b01;
    else if((flag && branch)||(inst_2 && branch && inst_3))
        muxSel = 2'b11;
    else if(halt == 3'b111)
        muxSel = 2'b00;
    else
        muxSel = 2'b10;
end
endmodule