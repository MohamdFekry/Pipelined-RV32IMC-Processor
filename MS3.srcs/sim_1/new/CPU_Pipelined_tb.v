`timescale 1ns / 1ps
module CPU_Pipelined_tb();

reg clk, rst;

CPU_Pipelined uut(clk, rst);

initial begin
    clk = 0;
    forever #50 clk = ~clk;
end

initial begin
    rst = 1; #15;
    rst = 0;
end
endmodule