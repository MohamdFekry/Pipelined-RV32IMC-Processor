/*******************************************************************
*
* Module: RCA32.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: a 32 bit ripple carry adder used for addtion and subtraction by the ALU. 
*
*
*
**********************************************************************/


module RCA32(input[31:0] a, input[31:0] b,
             output [31:0] out);

    wire[31:0] sum;
    wire[32:0] cout;
    assign cout[0] = 0;
    
    genvar i;
    
    generate
        for (i = 0; i < 32; i = i+1) begin :adders
            FA d(a[i], b[i], cout[i], sum[i], cout[i+1]);
            
        end
    endgenerate
    
    assign out = sum;
    
endmodule