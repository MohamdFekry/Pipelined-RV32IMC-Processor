module compressed_unit(input [31:0] inst_in, output reg [31:0] inst_out, output reg flag);

always @(*) begin
    if (inst_in[1:0]==2'b11 && inst_in != 32'h00000015) 
        flag = 0;    
    else
        flag=1;
    end

always @(*) begin
    
    if(inst_in[1:0] == 2'b11 || inst_in != 32'h00000015)
        inst_out = inst_in;
        
    else begin
        casex(inst_in[15:0]) 
        16'b000_xxxxx_xxxxxx_00:inst_out={2'b0, inst_in[10:7], inst_in[12:11], inst_in[5],inst_in[6], 2'b00, 5'b00010, 3'b000, 2'b01, inst_in[4:2], 7'b0010011};//addi4spn= addi x(8+rd),x2,imm scalled by 4
        16'b010_xxxxx_xxxxxx_00:inst_out={5'b0, inst_in[5], inst_in[12:10], inst_in[6],2'b00, 2'b01, inst_in[9:7], 3'b010, 2'b01, inst_in[4:2], 7'b0000011};//c.lw = lw (8+rd),offset[6:2](8+rs1)
        16'b110_xxxxx_xxxxxx_00:inst_out={5'b0, inst_in[5], inst_in[12], 2'b01, inst_in[4:2], 2'b01, inst_in[9:7], 3'b010, inst_in[11:10], inst_in[6], 2'b00, 7'b0100011};//c.sw= sw (8+rs2),offset[6:2](8+rs1)
        16'b000_xxxxx_xxxxxx_01:inst_out={{6 {inst_in[12]}}, inst_in[12], inst_in[6:2], inst_in[11:7], 3'b0, inst_in[11:7], 7'b0010011};//c.nop=addi x0, x0, 0 or c.addi (rd),(rd), imm
        16'b001_xxxxx_xxxxxx_01:inst_out={inst_in[12], inst_in[8], inst_in[10:9], inst_in[6],inst_in[7], inst_in[2], inst_in[11], inst_in[5:3],{9 {inst_in[12]}}, 4'b0, 1'b1, 7'b1101111};//c.jal= jal x1, offset[11:1]
        16'b010_xxxxx_xxxxxx_01:inst_out={{7 {inst_in[12]}}, inst_in[6:2], 5'b00000,3'b000, inst_in[11:7], 7'b0010011};//c.li =addi rd,x0,imm
        16'b011_x_00010_xxxxx_01:inst_out={{3 {inst_in[12]}}, inst_in[4:3], inst_in[5],inst_in[2],inst_in[6], 4'b0000,5'b00010 , 3'b000, 5'b00010, 7'b0010011};// addil16sp =addix2,x2
        16'b011_xxxxx_xxxxxx_01:inst_out={{15 {inst_in[12]}}, inst_in[6:2], inst_in[11:7], 7'b0110111};//c.liu =addi rd,x0,imm
        16'b100_x_00_xxxxxxxx_01:inst_out={7'b0100000, inst_in[6:2], 2'b01, inst_in[9:7],3'b101, 2'b01, inst_in[9:7], 7'b0010011};//c.srli=srli (8+rd) (8+rd) shamt 
        16'b100_x_01_xxxxxxxx_01:inst_out={7'b0000000, inst_in[6:2], 2'b01, inst_in[9:7],3'b101, 2'b01, inst_in[9:7], 7'b0010011};//c.srai=srai (8+rd) (8+rd) shamt 
        16'b100_x_10_xxxxxxxx_01:inst_out={{6 {inst_in[12]}}, inst_in[12], inst_in[6:2], 2'b01, inst_in[9:7], 3'b111, 2'b01, inst_in[9:7], 7'b0010011};//c.andi= andi (8+rd) (8+rd) imm
        16'b100011_xxx_00_xxx_01:inst_out={9'b010000001, inst_in[4:2], 2'b01, inst_in[9:7], 3'b000, 2'b01, inst_in[9:7], 7'b0110011};//c.sub = sub (8+rd) (8+rd) (8+rs) 
        16'b100011_xxx_01_xxx_01:inst_out={9'b000000001, inst_in[4:2], 2'b01, inst_in[9:7], 3'b100, 2'b01, inst_in[9:7], 7'b0110011};//c.xor=xor (8+rd) (8+rd) (8+rs2)
        16'b100011_xxx_10_xxx_01:inst_out={9'b000000001, inst_in[4:2], 2'b01, inst_in[9:7], 3'b110, 2'b01, inst_in[9:7], 7'b0110011};//c.or=or (8+rd) (8+rd) (8+rs2)
        16'b100011_xxx_11_xxx_01:inst_out={9'b000000001, inst_in[4:2], 2'b01, inst_in[9:7], 3'b111, 2'b01, inst_in[9:7], 7'b0110011};//c.and=and (8+rd) (8+rd) (8+rs2)
        16'b101_xxxxx_xxxxxx_01:inst_out={inst_in[12], inst_in[8], inst_in[10:9], inst_in[6],inst_in[7], inst_in[2], inst_in[11], inst_in[5:3],{9 {inst_in[12]}}, 4'b0, 1'b0, 7'b1101111};//c.j= jal x0, offset[11:1]
        16'b110_xxxxx_xxxxxx_01:inst_out={{4 {inst_in[12]}}, inst_in[6:5], inst_in[2], 5'b0, 2'b01,inst_in[9:7], 3'b000, inst_in[11:10], inst_in[4:3],inst_in[12], 7'b1100011};//c.beqz=beq (8++rs1),x0,offset[8:1]
        16'b111_xxxxx_xxxxxx_01:inst_out={{4 {inst_in[12]}}, inst_in[6:5], inst_in[2], 5'b0, 2'b01,inst_in[9:7], 3'b001, inst_in[11:10], inst_in[4:3],inst_in[12], 7'b1100011};//c.bnez=bne (8++rs1),x0,offset[8:1]
        16'b000_xxxxx_xxxxxx_10:inst_out={7'b0, inst_in[6:2], inst_in[11:7], 3'b001, inst_in[11:7], 7'b0010011};//c.slli = slli rd rd shamt
        16'b010_xxxxx_xxxxxx_10:inst_out={4'b0, inst_in[3:2], inst_in[12], inst_in[6:4], 2'b00, 5'b00010,3'b010, inst_in[11:7], 7'b00};//c.lwsp=lw rd offset(*2)
        16'b100_0_xxxxx_00000_10:inst_out={12'b0, inst_in[11:7], 3'b000, 5'b00000, 7'b1100111};//c.jr = jalr x0 rs1 0
        16'b100_0_xxxxx_xxxxx_10:inst_out={7'b0, inst_in[6:2], 5'b00000, 3'b000, inst_in[11:7], 7'b0110011};//c.mv=add rd x0 rs2
        16'b100_1_00000_00000_10:inst_out={32'h00_10_00_73};//ebreak
        16'b100_1_xxxxx_00000_10:inst_out={12'b0, inst_in[11:7], 3'b000, 5'b00001, 7'b1100111};//c.jalr=jalr x1 rs1 0
        16'b100_1_xxxxx_xxxxx_10:inst_out={7'b0, inst_in[6:2], inst_in[11:7], 3'b000, inst_in[11:7], 7'b0110011};//c.add rd rd rs2
        16'b110_xxxxxx_xxxxx_10:inst_out={4'b0, inst_in[8:7], inst_in[12], inst_in[6:2], 5'b00010, 3'b010,inst_in[11:9], 2'b00, 7'b0100011};//c.swsp=sw rs2 offset(x2)
        default: inst_out= 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        endcase
    end
end 
endmodule