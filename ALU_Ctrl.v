//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

//Select exact operation

always @(*)
    begin
        ALUCtrl_o = (ALUOp_i == 3'b010 && funct_i == 6'b100000) ? 4'b0010:      // add
                   (ALUOp_i == 3'b010 && funct_i == 6'b100010) ? 4'b0110:       // sub
                   (ALUOp_i == 3'b010 && funct_i == 6'b100100) ? 4'b0000:       // AND
                   (ALUOp_i == 3'b010 && funct_i == 6'b100101) ? 4'b0001:       // OR
                   (ALUOp_i == 3'b010 && funct_i == 6'b101010) ? 4'b0101:       // slt
                   (ALUOp_i == 3'b100) ? 4'b0010:                                // addi
                   (ALUOp_i == 3'b011) ? 4'b0100:                                // beq
                   (ALUOp_i == 3'b111) ? 4'b0101: 4'b1111;                      // slti
    end                  
endmodule     





                    
                    