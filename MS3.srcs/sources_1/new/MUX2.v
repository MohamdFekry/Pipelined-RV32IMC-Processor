/*******************************************************************
*
* Module: MUX2.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: a 1-bit 2x1 MUX
*
**********************************************************************/

module MUX2(input a, b, sel,
            output c);

    assign c = sel ? b : a;   //sel == 1; b, else a

endmodule