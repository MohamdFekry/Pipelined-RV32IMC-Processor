module MUX_2X1 #(parameter n = 32) (input [n-1:0] a, b, input sel, output [n-1:0] c);
/*
    genvar i;
    generate 
        for(i = 0; i < n; i = i+1)begin: muxes
            MUX2 u(a[i], b[i], sel, c[i]);
    end
    endgenerate
*/
    assign c = sel? b : a;
endmodule