module CPU_Pipelined(input clk, rst, input[1:0] ledSel, input[3:0] ssdSel, output reg[15:0] leds, output reg[12:0] ssd);

wire [31:0] address_in, target_address, temp_instruction, instruction, gen_out, readdata1, readdata2, writedata, ALU_in2, ALU_result, pc_step, pc_jump, MemVSALU, ForwardA_out, ForwardB_out;
wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, CompressFlag, cf, zf, vf, sf;
wire [1:0] ALUOp, WhatToWrite, PCsel, ForwardA, ForwardB;
wire [4:0] ALUsel;

//IFID:
wire [31:0] IF_ID_target_address, IF_ID_instruction, IF_ID_pc_step;
wire [4:0] IF_ID_readreg1 = IF_ID_instruction[19:15], IF_ID_readreg2 = IF_ID_instruction[24:20], IF_ID_rd = IF_ID_instruction[11:7];
wire [4:0] IF_ID_funct = {IF_ID_instruction[30], IF_ID_instruction[25], IF_ID_instruction[14:12]};
wire [4:0] IF_ID_shamt = IF_ID_instruction[24:20];
wire IF_ID_inst2 = IF_ID_instruction[2], IF_ID_inst3 = IF_ID_instruction[3];
wire [2:0] IF_ID_halt = IF_ID_instruction[6:4];

//IDEX:
wire ID_EX_branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_inst2, ID_EX_inst3;
wire [1:0] ID_EX_ALUOp, ID_EX_WhatToWrite;
wire [31:0] ID_EX_target_address, ID_EX_pc_step, ID_EX_readdata1, ID_EX_readdata2, ID_EX_gen_out;
wire [4:0] ID_EX_funct, ID_EX_shamt, ID_EX_readreg1, ID_EX_readreg2, ID_EX_rd;
wire [2:0] ID_EX_halt;
wire [7:0] ID_EX_flushCtrls;

//EXMEM:
wire [31:0] EX_MEM_target_address, EX_MEM_pc_step, EX_MEM_pc_jump, EX_MEM_ALU_result, EX_MEM_readdata2, EX_MEM_gen_out, EX_MEM_ForwardB_out;
wire EX_MEM_branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_cf, EX_MEM_zf, EX_MEM_vf, EX_MEM_sf, EX_MEM_inst2, EX_MEM_inst3;
wire [1:0] EX_MEM_WhatToWrite;
wire [4:0] EX_MEM_funct, EX_MEM_rd, EX_MEM_flushCtrls;
wire [2:0] EX_MEM_halt;

//MEMWB:
wire [1:0] MEM_WB_WhatToWrite;
wire [4:0] MEM_WB_rd;
wire MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire[31:0] MEM_WB_mem_out, MEM_WB_ALU_result, MEM_WB_pc_step, MEM_WB_pc_jump, MEM_WB_gen_out;

// IF





reg flushSignal;
always@(*) begin
    if (PCsel == 2'b11 | PCsel == 2'b01)
        flushSignal = 1;
    else
        flushSignal = 0;
end

//Memory
wire[13:0] mem_addr = {EX_MEM_ALU_result[6:0], target_address[6:0]};
wire[31:0] mem_out;


    register PC(address_in, /*1'b1*/~(IF_ID_instruction[6] & IF_ID_instruction[5] & IF_ID_instruction[4]), rst, clk, target_address);
    Memory2 instructions_and_data(mem_addr, EX_MEM_ForwardB_out, clk, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_funct[2:0], mem_out);
    RegFile file(~clk, rst, IF_ID_readreg1, IF_ID_readreg2, MEM_WB_rd, writedata, MEM_WB_RegWrite, readdata1, readdata2);
    compressed_unit compressedOut(mem_out, temp_instruction, CompressFlag);
    RCA32 PC_addressAdder (target_address, CompressFlag? 2 : 4, pc_step);
    //RCA32 PC_addressAdder (target_address, 4, pc_step);
    
    MUX_2X1 flushing_fisrt (temp_instruction, 32'h00000033, 1'b0/*flushSignal*/, instruction);
    
    
    register #(96) IFID({target_address, instruction, pc_step}, 1'b1, rst, ~clk, {IF_ID_target_address, IF_ID_instruction, IF_ID_pc_step});
    
    
    ctrlUnit control(IF_ID_instruction[6:0], branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, WhatToWrite);
    //RegFile file(clk, rst, IF_ID_readreg1, IF_ID_readreg2, MEM_WB_rd, writedata, MEM_WB_RegWrite, readdata1, readdata2);
    ImmGen gen(IF_ID_instruction, gen_out);
    
    MUX_2X1 #(8) flushing_second ({branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp}, 8'd0, flushSignal, ID_EX_flushCtrls);
    
    
    register #(200) IDEX({ID_EX_flushCtrls, WhatToWrite, IF_ID_target_address, IF_ID_pc_step, readdata1, readdata2, gen_out, IF_ID_funct, IF_ID_shamt, IF_ID_readreg1, IF_ID_readreg2, IF_ID_rd, IF_ID_inst2, IF_ID_inst3, IF_ID_halt},
                         1'b1, rst, clk, 
                         {ID_EX_branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_ALUOp, ID_EX_WhatToWrite,
                         ID_EX_target_address, ID_EX_pc_step, ID_EX_readdata1, ID_EX_readdata2, ID_EX_gen_out, ID_EX_funct, ID_EX_shamt, ID_EX_readreg1, ID_EX_readreg2, ID_EX_rd, ID_EX_inst2, ID_EX_inst3, ID_EX_halt});
    
    
    ALU_ctrlUnit ALU_Ctrl(ID_EX_ALUOp, ID_EX_funct[2:0], ID_EX_funct[4], ID_EX_funct[3], ALUsel);
    RCA32 jump_address (ID_EX_target_address, ID_EX_gen_out, pc_jump);
    ForwardingUnit forwarding(ID_EX_readreg1, ID_EX_readreg2, EX_MEM_rd, MEM_WB_rd, EX_MEM_RegWrite, MEM_WB_RegWrite, ForwardA, ForwardB);
    MUX_4X1 forward_a(ID_EX_readdata1, writedata, EX_MEM_ALU_result, 0, ForwardA, ForwardA_out);
    MUX_4X1 forward_b(ID_EX_readdata2, writedata, EX_MEM_ALU_result, 0, ForwardB, ForwardB_out);
    MUX_2X1 MUX_ALU(ForwardB_out, ID_EX_gen_out, ID_EX_ALUSrc, ALU_in2);
    ALU32 ALU(ForwardA_out, ALU_in2, ALUsel, ID_EX_shamt, ALU_result, cf, zf, vf, sf);
    
    MUX_2X1 #(5) flushing_third ({ID_EX_branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_RegWrite}, 5'd0, 1'b0/*flushSignal*/, EX_MEM_flushCtrls);
    
    
    register #(250) EXMEM({EX_MEM_flushCtrls, ID_EX_WhatToWrite, ID_EX_target_address, pc_jump, ID_EX_pc_step, cf, zf, vf, sf, ALU_result, ForwardB_out, ID_EX_readdata2, ID_EX_funct, ID_EX_rd, ID_EX_inst2, ID_EX_inst3, ID_EX_halt, ID_EX_gen_out},
                          1'b1, rst, ~clk, 
                          {EX_MEM_branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_WhatToWrite, EX_MEM_target_address, EX_MEM_pc_jump, EX_MEM_pc_step, EX_MEM_cf, EX_MEM_zf, EX_MEM_vf, EX_MEM_sf,
                          EX_MEM_ALU_result, EX_MEM_ForwardB_out, EX_MEM_readdata2, EX_MEM_funct, EX_MEM_rd, EX_MEM_inst2, EX_MEM_inst3, EX_MEM_halt, EX_MEM_gen_out});
    
    
    BranchUnit branchCtrl(EX_MEM_cf, EX_MEM_zf, EX_MEM_vf, EX_MEM_sf, EX_MEM_branch, EX_MEM_funct[2:0], EX_MEM_inst2, EX_MEM_inst3, EX_MEM_halt, PCsel);
    MUX_4X1 MUX_PC(EX_MEM_target_address, EX_MEM_ALU_result, IF_ID_pc_step, EX_MEM_pc_jump, PCsel, address_in);
    
        
    register #(169) MEMWB({EX_MEM_MemtoReg, EX_MEM_RegWrite, EX_MEM_WhatToWrite, mem_out, EX_MEM_ALU_result, EX_MEM_rd, EX_MEM_pc_step, EX_MEM_pc_jump, EX_MEM_gen_out},
                          1'b1, rst, clk, 
                          {MEM_WB_MemtoReg, MEM_WB_RegWrite, MEM_WB_WhatToWrite, MEM_WB_mem_out, MEM_WB_ALU_result, MEM_WB_rd, MEM_WB_pc_step, MEM_WB_pc_jump, MEM_WB_gen_out});
    
    
    MUX_2X1 MUX_mem_ALU(MEM_WB_ALU_result, MEM_WB_mem_out, MEM_WB_MemtoReg, MemVSALU);
    MUX_4X1 MUX_Writedata(MemVSALU, MEM_WB_pc_step, MEM_WB_pc_jump, MEM_WB_gen_out, MEM_WB_WhatToWrite, writedata);
    
    
    
    
always @(*) begin
    case(ledSel)
        2'b00: leds = instruction[15:0];
        2'b01: leds = instruction[31:16];
        2'b10: leds = {2'b00, branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, ALUsel, zf, branch & zf};
        default: leds = 0;
    endcase
end

always @(*) begin
    case(ssdSel)
        4'b0000: ssd = target_address[12:0];
        4'b0001: ssd = pc_step[12:0];
        4'b0010: ssd = pc_jump[12:0];
        4'b0011: ssd = address_in[12:0];
        4'b0100: ssd = readdata1[12:0];
        4'b0101: ssd = readdata2[12:0];
        4'b0110: ssd = writedata[12:0];
        4'b0111: ssd = gen_out[12:0];
        4'b1001: ssd = ALU_in2[12:0];
        4'b1010: ssd = ALU_result[12:0];
        4'b1011: ssd = mem_out[12:0];
        4'b1100: ssd = MEM_WB_rd;
        default: ssd = 0;
    endcase
end


endmodule
