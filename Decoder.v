//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

//Main function
always @(*)
    begin
        RegDst_o = (instr_op_i == 6'b000000) ? 1'b1:1'b0;
        RegWrite_o = (instr_op_i != 6'b000100) ? 1'b1:1'b0;
        Branch_o = (instr_op_i == 6'b000100) ? 1'b1:1'b0;
        ALUSrc_o = (instr_op_i == 6'b001010 || instr_op_i == 6'b001000) ? 1'b1:1'b0;
        
        ALU_op_o = (instr_op_i == 6'b000000) ? 3'b010:          // R-type
                  (instr_op_i == 6'b001000) ? 3'b100:           // addi    
                  (instr_op_i == 6'b000100) ? 3'b011:           // beq
                  (instr_op_i == 6'b001010) ? 3'b111: 3'b000;   // slti
    end    
endmodule





                    
                    