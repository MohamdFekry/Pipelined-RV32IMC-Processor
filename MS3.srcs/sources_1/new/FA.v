/*******************************************************************
*
* Module: FA.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: A 1-bit full adder used for implementing the 32-bit full adder
*
**********************************************************************/

module FA (input a, b, cin, output sum, cout);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule 