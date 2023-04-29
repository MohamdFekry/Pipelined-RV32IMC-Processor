`timescale 1ns / 1ps
module shifter_tb();


reg[31:0] in1; reg type; reg[4:0] shamt, in2; wire[31:0] shifted;

right_shifter shift(in1, type, shamt, in2, shifted);

initial begin

type = 0;
in1 = -100;
in2 = 5;
shamt = 2;
#50;
type =1;

end
endmodule