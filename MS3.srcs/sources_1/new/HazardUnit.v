module HazardUnit(input[4:0] IF_ID_rs1, IF_ID_rs2, ID_EX_rd, input ID_EX_MemRead,
                  output reg stall);

    always @(*) begin
        if (((IF_ID_rs1 == ID_EX_rd) || (IF_ID_rs2 == ID_EX_rd)) && (ID_EX_MemRead) && (ID_EX_rd != 0))
            stall = 1;
        else
            stall = 0;    
    end

endmodule