/*******************************************************************
*
* Module: defines.v
* Project: RV32IMC Processor
* Author: Provided by Dr. Sherif Salama, very small addition for the bonus by Mohamed Fekry.
* Description: to declare some variables that correspond to some specific hardwired numbers. 
*
*
*
**********************************************************************/


`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20

`define     OPCODE_Branch   7'b11_000_11
`define     OPCODE_Load     7'b00_000_11
`define     OPCODE_Store    7'b01_000_11
`define     OPCODE_JALR     7'b11_001_11
`define     OPCODE_JAL      7'b11_011_11
`define     OPCODE_Arith_I  7'b00_100_11
`define     OPCODE_Arith_R  7'b01_100_11
`define     OPCODE_AUIPC    7'b00_101_11
`define     OPCODE_LUI      7'b01_101_11
`define     OPCODE_SYSTEM   7'b11_100_11
`define     OPCODE_Custom   7'b10_001_11

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

`define     LB              3'b000
`define     LH              3'b001
`define     LW              3'b010
`define     LBU             3'b100
`define     LHU             3'b101
`define     SB              3'b000
`define     SH              3'b001
`define     SW              3'b010

`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     ALU_AND         5'b00000
`define     ALU_OR          5'b00001
`define     ALU_XOR         5'b00010
`define     ALU_ADD         5'b00011
`define     ALU_SUB         5'b00100
`define     ALU_SLT         5'b00101
`define     ALU_SLTU        5'b00110
`define     ALU_SLLI        5'b00111
`define     ALU_SRLI        5'b01000
`define     ALU_SRAI        5'b01001
`define     ALU_SLL         5'b01010
`define     ALU_SRL         5'b01011
`define     ALU_SRA         5'b01100
`define     ALU_MUL         5'b01101
`define     ALU_MULH        5'b01110
`define     ALU_MULHSU      5'b01111
`define     ALU_MULHU       5'b10000
`define     ALU_DIV         5'b10001
`define     ALU_DIVU        5'b10010
`define     ALU_REM         5'b10011
`define     ALU_REMU        5'b10100

`define     OPCODE          IR[`IR_opcode]

`define     SYS_EC_EB       3'b000
