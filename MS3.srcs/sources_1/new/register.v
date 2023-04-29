module register #(parameter n = 32)(input [n-1:0]D, input load, rst, clk,
             output [n-1:0] Q);
    wire[n-1:0] dd;
    genvar i;
    generate 
        for(i = 0; i < n; i = i+1)begin: logic
            MUX2 u(Q[i], D[i], load, dd[i]);
            DFlipFlop Flip(clk, rst, dd[i], Q[i]);
    end
    endgenerate
endmodule