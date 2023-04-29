/*******************************************************************
*
* Module: ALU32.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry. 
* Description: our 32-bit ALU that performs R, I, M instructions 
*
*
**********************************************************************/


`include "defines.v"

module ALU32 (input[31:0] in1, in2, input[4:0] ALUsel, input[4:0] shamt,
              output reg [31:0] result, output cf, zf, vf, sf);

    wire[31:0] add, not_in2, right_shifted;
    assign not_in2 = (~in2);
    assign {cf, add} = ALUsel[0] ? (in1 + in2) : (in1 + (not_in2 + 1'b1));
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (in1[31] ^ (not_in2[31]) ^ add[31] ^ cf);
    
    right_shifter shift(in1, ALUsel[0], shamt, in2[4:0], right_shifted);
    //RCA32 temp(in1, in2, sum_out);
    //RCA32 temp2(in1, minus_in,  minus_out);
    
    //temps for multiplications
    wire signed [31:0] signed_in1 = in1;
    wire signed [31:0] signed_in2 = in2;
    wire[63:0] MUL = in1 * in2;
    wire signed[63:0] MULH = signed_in1 * signed_in2;
    wire signed[63:0] MULHSU = signed_in1 * in2; 
    wire [31:0] REM = signed_in1 % signed_in2;
    
    always@(*) begin
        case(ALUsel)
            `ALU_AND:  result = in1 & in2; 
            `ALU_OR:   result = in1 | in2;    
            `ALU_XOR:  result = in1 ^ in2;   
            `ALU_ADD:  result = add;    //result is addition
            `ALU_SUB:  result = add;    //result is subtraction
            `ALU_SLT:  result = {31'b0, (signed_in1 < signed_in2)};
            `ALU_SLTU: result = {31'b0,(~cf)};        
            `ALU_SLLI: result = in1 << shamt;        
            `ALU_SRLI: result = in1 >> shamt;        
            `ALU_SRAI: result = right_shifted;
            `ALU_SLL:  result = in1 << in2[4:0];
            `ALU_SRL:  result = in1 >> in2[4:0];
            `ALU_SRA:  result = right_shifted;
            
            `ALU_MUL:    result = MUL[31:0]; 
            `ALU_MULH:   result = MULH[63:32]; 
            `ALU_MULHSU: result = MULHSU[63:32]; 
            `ALU_MULHU:  result = MUL[63:32]; 
            `ALU_DIV:
                begin
                    if(signed_in2 == 0)
                        result = 32'dZ;
                    else
                        result = signed_in1 / signed_in2;
                end 
                
            `ALU_DIVU:
                begin
                    if(in2 == 0)
                        result = 32'dZ;
                    else 
                        result = in1 / in2; 
                end
                
            `ALU_REM:
                begin
                    if(signed_in2 == 0)
                        result = 32'dZ;
                    else
                        result = REM; 
                end
                 
            `ALU_REMU:
                begin
                    if(in2 == 0)
                        result = 32'dZ;
                    else 
                        result = in1 % in2; 
                end
            default: result = 0;
        endcase
    end
endmodule