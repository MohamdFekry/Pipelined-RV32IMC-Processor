/*******************************************************************
*
* Module: RegFile.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: The regfile holding the 32 regs.
*
*
*
**********************************************************************/

module RegFile (input clk, rst, input [4:0] readreg1, readreg2, writereg, input [31:0] writedata, input regwrite,
                output [31:0] readdata1, readdata2);

    reg[31:0] loads;
    wire[31:0] regs_out[0:31];   //the 32 regs
    register regist(0, 1'b0, rst, clk, regs_out[0]);   //putting 0 in x0
    
    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1)begin: regs
            register regist(writedata, loads[i], rst, clk, regs_out[i]);
        end
    endgenerate
    
    assign readdata1 = regs_out[readreg1];
    assign readdata2 = regs_out[readreg2];
    
    integer j;
    always@(*) begin
        loads = 0;
        for(j = 1; j < 32; j = j + 1)begin    //not enabling write to x0
            if ((j == writereg) && regwrite)
                loads[j] = 1;
            else
                loads[j] = 0;
        end
    end
endmodule