`timescale 1ns / 1ps
module CPU_tb();

reg clk, rst;

CPU uut(clk, rst);

initial begin
    clk = 0;
    forever #20 clk = ~clk;
end

initial begin
    rst = 1; #15;
    rst = 0; #20;
end
endmodule