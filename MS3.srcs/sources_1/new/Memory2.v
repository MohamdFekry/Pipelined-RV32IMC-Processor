/*******************************************************************
*
* Module: InstMem.v
* Project: RV32IMC Processor
* Author: Abdelwahab Ganna, Ahmed Shalaby, and Mohamed Fekry.
* Description: A word-addressable memory holding the program's instructions.
* Change history: 27/6/2022 - Ahmed shalaby and abdelwahab Ganna added 3 test cases
*                 29/6/2022 - Mohmaed Fekry added 6 tets cases 
*                 
*
**********************************************************************/

`include "defines.v"

module Memory2 (input [13:0] addr, input [31:0] data_in, input clk, MemRead, MemWrite, input[14:12] fun3,
                output reg [31:0] out);
                
//wire[13:0] mem_addr = {EX_MEM_ALU_result[6:0], target_address[6:0]};
    
    
    reg [7:0] mem [0:255];  
    reg [31:0] temp [0:31];   //max 32 word instructions for the 128 places for instructions
    
    always @(posedge clk) begin
        if (MemWrite) begin 
            if(fun3 == `SB)
                mem[addr[13:7]+128] <= data_in[7:0];
            else if(fun3 == `SH) begin
                mem[addr[13:7]+128] <= data_in[7:0];
                mem[addr[13:7]+129] <= data_in[15:8];
            end
            else if(fun3 == `SW) begin
                mem[addr[13:7]+128] <= data_in[7:0];
                mem[addr[13:7]+129] <= data_in[15:8];
                mem[addr[13:7]+130] <= data_in[23:16];
                mem[addr[13:7]+131] <= data_in[31:24];
            end
        end
    end
    
    //reading instructions from files
    initial begin
        $readmemh("C:/Users/Mohamed/Desktop/MS3_rep/Tests/Branches_test.hex", temp);
    end
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+1)
            {mem[(i*4)+3], mem[(i*4)+2], mem[(i*4)+1], mem[i*4]} = temp[i];
    end
    
    always@(*) begin
    //fetch data   //7ot if (clk)
    if(~clk) begin
        if(MemRead) begin
            if(fun3 == `LB)
                out = {{24{mem[addr[13:7]+128][7]}}, mem[addr[13:7]+128]};
            else if(fun3 == `LH) begin
                out = {{16{mem[addr[13:7]+129][7]}}, mem[addr[13:7]+129], mem[addr[13:7]+128]};
            end
            else if(fun3 == `LW) begin
                out = {mem[addr[13:7]+131], mem[addr[13:7]+130], mem[addr[13:7]+129], mem[addr[13:7]+128]};
            end   
            else if(fun3 == `LBU) begin
                out = {{24'd0}, mem[addr[13:7]+128]};
            end
            else if(fun3 == `LHU) begin
                out = {{16'd0}, mem[addr[13:7]+129], mem[addr[13:7]+128]};
            end     
        end
    end   
        //Fetch instruction
        else
            out = {mem[addr[6:0]+3], mem[addr[6:0]+2], mem[addr[6:0]+1], mem[addr[6:0]]};
    end
    
    
    
    //initializing memory to zeroes
//    integer j;
//    initial begin
//        for(j = 0; j < 255; j=j+1)
//            mem[j] = 8'd0;
//    end
    
    initial begin
        mem[128] = -3;
        mem[129] = 8'd2;
        mem[130] = 8'd4;
        mem[131] = 8'd5;
        mem[132] = 8'd6;
        mem[133] = 8'd7;
        mem[134] = 8'd8;
        mem[135] = -9;
        mem[136] = -10;
//        mem[128] = 8'd17;
//        mem[129] = 8'd0;
//        mem[130] = 8'd0;
//        mem[131] = 8'd0;
//        mem[132] = 8'd9;
//        mem[133] = 8'd0;
//        mem[134] = 8'd0;
//        mem[135] = 8'd0;
//        mem[136] = 8'd25;
//        mem[137] = 8'd0;
//        mem[138] = 8'd0;
//        mem[139] = 8'd0;
    end

endmodule
    
    
    
    //exp 4
    /*mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
    mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)          x1 = 17
    mem[2]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)          x2 = 9
    mem[3]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)          x3 = 25
    mem[4]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2        x4 = 25
    mem[5]=32'b0_000000_00011_00100_000_0100_0_1100011 ; //beq x4, x3, L      L = 4, branch taken
    mem[6]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2       
    mem[7]=32'b0000000_00010_00011_000_00101_0110011 ; //L: add x5,x3,x2      x5 = 34
    mem[8]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)         mem[3] = 34
    mem[9]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)         x6 = 34
    mem[10]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1     x7 = 0
    mem[11]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2     x8 = 8
    mem[12]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
    mem[13]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1     x9 = 17*/

    //exp 5
   /* mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  // add x0, x0, x0
    mem[1]=32'h00002183 ;                               // lw x3, 0(x0)              #i = x3 = 1
    mem[2]=32'h00402203 ;                               // lw x4, 4(x0)              #x4 = 10
    mem[3]=32'h003002b3 ;                               // add x5, x0, x3            #x5 as counter = 1
    mem[4]=32'h00418663 ;                               //loop: beq  x3,x4, exit
    mem[5]=32'h005181b3 ;                               // add x3,x3,x5
    mem[6]=32'hfe000ce3 ;                               // beq  x0,x0, loop
    mem[7]=32'h00302423 ;                               // exit: sw x3, 8(x0)
    mem[8]=32'h0041e2b3 ;                               // or x5, x3, x4
    mem[9]=32'h0041f333 ;                               // and x6, x3, x4
    mem[10]=32'h40528333 ;                              // sub x6, x5, x5
*/

    //LW, SW    dd
    /*lb x1, 0(x0)    #x1 = -3
    lh x2, 0(x0)    #x2 = 765
    lw x3, 0(x0)    #x3 = 84148989
    add x4, x3, x2  #x4 = 84149754
    add x9, x3, x2  #x9 = 84149754
    sw x3, 8(x0)    #mem[8] = -3, mem[9] = 2, mem[10] = 4, mem[11] = 5,
    lw x5, 8(x0)    #x5 = 84148989
    sb x3, 0(x0)    #mem[0] = -3
    sh x3, 4(x0)    #mem[4] = -3, mem[5] = 2  
    lbu x6, 7(x0)   #x6 = 247
    lhu x7, 7(x0)   #x7 = 65015
    mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
    mem[1]=32'h00000083 ;                               
    mem[2]=32'h00001103 ;                               
    mem[3]=32'h00002183 ;                                
    mem[4]=32'h00704203 ;                               
    mem[5]=32'h00705283 ;                               
    mem[6]=32'h00300023;                               
    mem[7]=32'h00301223 ;                               
    mem[8]=32'h00302423 ;                              
    */
  
   //Branches   dd
   /*notwanted:addi x1, x0, -5
   addi x2, x1, -2         #x2 never equals -7
   wanted:addi x2, x1, -1
   beq x1, x2, notwanted
   blt x1, x2, notwanted
   bgeu x1, x2, wanted
   bltu x1, x2, notwanted
   mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
   mem[1]=32'hffb00093 ;                               
   mem[2]=32'hfff08113 ;                               
   mem[3]=32'hfe208ce3 ;                                
   mem[4]=32'hfe20cce3 ;                               
   mem[5]=32'hfe20fae3 ;                               
   mem[6]=32'hfe20e8e3;                               
   */
  
   //R & FENCE & ECALL & EBREAK   dd
  /*addi x1, x0, -3 #//x1 = -3
   addi x2, x0, 2   #//x2 = 2
   lb x1, 0(x0)
   lb x2, 1(x0)
   add x3, x1, x2   #//x3 = -1    
   sub x4, x3, x2   #//x4 = -3
   sll x5, x4, x2   #//x5 = -12
   slt x6, x5, x1   #//x6 = 1
   sltu x7, x6, x2  #//x7 = 1
   xor x8, x7, x6   #//x8 = 0
  FENCE
  FENCE           // == 32'h00000015
  srl x9, x8, x7    #//x9 = 0
  sra x10, x1, x2   #//x10 = -1
  or x11, x9, x2    #//x11 = 2
  and x12, x10, x11 #//x12 = 2
  ECALL/EBREAK       
  add x13, x1, x2   #//x13 = 0   -1
  sub x14, x1, x2   #//x14 = 0   -5
  ADDI x15, x1, 5   #//x15 = 0    2
  
    mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
    mem[1]=32'h00000083 ;                               
    mem[2]=32'h00100103 ;                               
    mem[3]=32'h002081b3 ;                               
    mem[4]=32'h40208233 ;                              
    mem[5]=32'h002092b3 ;                               
    mem[6]=32'h00112333;                               
    mem[7]=32'h0020b3b3 ;                               
    mem[8]=32'h0020c433 ;                              
    mem[9]=32'b000000000000_00000_000_00000_0001111 ;  //fence 
    mem[10]=32'b000000000000_00000_000_00000_0001111 ;      //fence                       
    mem[11]=32'h0020d4b3 ;                               
    mem[12]=32'h4020d533 ;                                
    mem[13]=32'h0020e5b3 ;                               
    mem[14]=32'h0020f633 ;                               
   // mem[15]=32'h00000073 ;   ECALL                       
    mem[15]=32'b000000000001_00000_000_00000_1110011 ;  //EBREAK
    mem[16]=32'h002086b3 ;                              
    mem[17]=32'h40208733 ;                               
    mem[18]=32'h00508793;                         
    */
   
   //LUI, AUIPC, JAL, JALR     dd
   /*lbl:add x0, x0, x0
   addi x5, x0, 4     #x5 = 4
   lui x1, 5          #x1 = 5 * 2^12 = 20480
   auipc x2, 3        #x2 = 12 + 3 * 2^12 = 12300
   jal x3, lbl        #x3 = 20, PC = 0
   //#jalr x4, x5, 0     #x4 = 20, PC = 4
   addi x5, x0, 9     #won't be executed  so x5 never equals 9
   mem[0]=32'h00000033 ;  
   mem[1]=32'h00400293 ;                               
   mem[2]=32'h000050b7 ;                               
   mem[3]=32'h00003117 ;                               
   mem[4]=32'hff1ff1ef ; //JAL                             
   //mem[4]=32'h00028267 ; //JALR                              
   mem[5]=32'h00900293 ;                               
   */
    
   //I       dd
   /*addi x1, x0, 3     #x1 = 3
   slti x2, x1, -4    #x2 = 0
   sltiu x3, x1, 5    #x3 = 1
   sltiu x4, x1, -5   #x4 = 1
   xori x5, x1, -3    #x5 = -2
   ori x6, x1, 4      #x6 = 7
   andi x7, x1, -1    #x7 = 3
   slli x8, x1, 6     #x8 = 192
   srli x9, x1, 2     #x9 = 0.75 = 0
   addi x1, x0, -3    #x1 = -3
   srai x10, x1, 2    #x10 = -1
   mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
   mem[1]=32'h00300093 ;                               
   mem[2]=32'hffc0a113;                               
   mem[3]=32'h0050b193 ;                               
   mem[4]=32'hffb0b213 ;                              
   mem[5]=32'hffd0c293 ;                               
   mem[6]=32'h0040e313;                               
   mem[7]=32'hfff0f393 ;                               
   mem[8]=32'h00609413 ;                              
   mem[9]=32'h0020d493 ;  
   mem[10]=32'hffd00093 ;                        
   mem[11]=32'h4020d513	;                               
   */
    
   //M      dd
   /*addi x1, x0, 3   #x1 = 3
   addi x2, x0, -1    #x2 = -1
   mul x3, x1, x2     #x3 = -3
   mulh x4, x1, x2    #x4 = -1
   mulhu x5, x1, x2   #x5 = 2
   mulhsu x6, x1, x2  #x6 = 2
   addi x1, x0, 7     #x1 = 7
   addi x2, x0, -2    #x2 = -2
   div x7, x1, x2     #x7 = -3
   rem x8, x1, x2     #x8 = 1
   divu x9, x1, x2    #x9 = 0
   remu x10, x1, x2   #x10 = 7
   mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
   mem[1]=32'h00300093 ;                               
   mem[2]=32'hfff00113;                               
   mem[3]=32'h022081b3 ;                               
   mem[4]=32'h02209233 ;                              
   mem[5]=32'h0220b2b3 ;                               
   mem[6]=32'h0220a333;                               
   mem[7]=32'h00700093 ;                               
   mem[8]=32'hffe00113 ;                              
   mem[9]=32'h0220c3b3 ; 
   mem[10]=32'h0220e433 ;                            
   mem[11]=32'h0220d4b3 ;        
   mem[12]=32'h0220f533 ;  */      
   
   // REM with negatives   dd
   /*
   mem[0]=32'b0000000_00000_00000_000_00000_0110011 ;  
   mem[1]=32'hffd00093 ;  //x1 = -3                             
   mem[2]=32'h00200113 ;  //x2 = 2                             
   mem[3]=32'h0220e1b3 ;  //x3 = x1%x2 = -1
 */   
 