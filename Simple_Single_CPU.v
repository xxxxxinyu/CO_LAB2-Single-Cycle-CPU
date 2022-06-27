//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_out;
wire [32-1:0] adder1_sum;
wire [32-1:0] adder2_sum;
wire [32-1:0] im_out;
wire [3-1:0] alu_op;
wire alu_src;
wire branch;
wire reg_write;
wire reg_dst;
wire alu_zero;
wire [5-1:0] mux_write_reg_out;
wire [32-1:0] alu_result;
wire [32-1:0] RSdata_out;
wire [32-1:0] RTdata_out;
wire [32-1:0] sign_ext_out;
wire [32-1:0] mux_alusrc_out;
wire [4-1:0] alu_ctrl_out;
wire [32-1:0] shift_left_out;
wire [32-1:0] mux_pc_source;
wire [3-1:0] func_op_i;
wire beq;

assign beq = branch&alu_zero;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc_source) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(32'b00000000000000000000000000000100),     
	    .src2_i(pc_out),     
	    .sum_o(adder1_sum)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(im_out)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(im_out[20:16]),
        .data1_i(im_out[15:11]),
        .select_i(reg_dst),
        .data_o(mux_write_reg_out)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(im_out[25:21]) ,  
        .RTaddr_i(im_out[20:16]) ,  
        .RDaddr_i(mux_write_reg_out) ,  
        .RDdata_i(alu_result)  , 
        .RegWrite_i (reg_write),
        .RSdata_o(RSdata_out) ,  
        .RTdata_o(RTdata_out)   
        );
	
Decoder Decoder(
        .instr_op_i(im_out[31:26]), 
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(im_out[5:0]),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl_out) 
        );
	
Sign_Extend SE(
        .data_i(im_out[15:0]),
        .data_o(sign_ext_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_out),
        .data1_i(sign_ext_out),
        .select_i(alu_src),
        .data_o(mux_alusrc_out)
        );	
		
ALU ALU(
        .src1_i(RSdata_out),
	    .src2_i(mux_alusrc_out),
	    .ctrl_i(alu_ctrl_out),
	    .result_o(alu_result),
		.zero_o(alu_zero)
	    );
		
Adder Adder2(
        .src1_i(adder1_sum),     
	    .src2_i(shift_left_out),     
	    .sum_o(adder2_sum)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_ext_out),
        .data_o(shift_left_out)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(adder1_sum),
        .data1_i(adder2_sum),
        .select_i(branch&alu_zero),
        .data_o(mux_pc_source)
        );	

endmodule
		  


