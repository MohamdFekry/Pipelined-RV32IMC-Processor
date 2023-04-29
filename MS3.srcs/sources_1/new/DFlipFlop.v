/*******************************************************************
*
* Module: DFlipFlop.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: A 1-bit register
*
**********************************************************************/

module DFlipFlop(input clk, input rst, input D,
                 output reg Q);
                 
    always @ (posedge clk or posedge rst) begin // Asynchronous Reset
        if (rst)
            Q <= 1'b0;
        else 
            Q <= D;
    end
endmodule