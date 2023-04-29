//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2022 10:32:25 AM
// Design Name: 
// Module Name: ForwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ForwardingUnit(input [4:0] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd, input EX_MEM_RegWrite, MEM_WB_RegWrite,
                      output reg [1:0] ForwardA, ForwardB);

//    always @(*) begin
                
//        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
//            ForwardA = 2'b10;
          
//        else if ((MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1)) && ~(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)))
//            ForwardA = 2'b01;
          
//        else
//            ForwardA = 2'b00;  
//    end  
    
//    always @(*) begin  
       
//        if ((MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2)) && ~(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)))
//            ForwardB = 2'b01;
            
//        else if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
//            ForwardB = 2'b10;
        
//        else
//            ForwardB = 2'b00;     
//    end

    always @(*) begin
                //I guess we now only need forwarding from the memory stage 
        if ((MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1)))
            ForwardA = 2'b01;
          
        else
            ForwardA = 2'b00;  
    end  
    
    always @(*) begin  
       
        if ((MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2)))
            ForwardB = 2'b01;
        
        else
            ForwardB = 2'b00;     
    end
endmodule