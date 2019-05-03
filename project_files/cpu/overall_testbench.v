/***************************************************************** 
Author....: Wes Nicol
Date......: 2019-03-05
Class.....: HDL
Professor.: Mark Welker 

Module: overall_testbench
	
Purpose: This test bench serves as a printed circuit board for wiring together 
         all modules of the project. A visual example of this can be seen in the 
		 block diagram pdf. 
		 This test bench will supply data and instruction memory with their 
		 respective data to preform the actions requested in the assignment.

Expected Result: Data memory will end up identical to the deifned solution 
                 in the project assignment.

*****************************************************************/

`timescale 1ns / 1ns
module overall_testbench;

integer row,col; // used as indicies in for loops unrolling matricies








// global reset
reg reset;
	
	
// wires to connect everything
reg clk;

wire [3:0] address_of_next_instruction;
	
	
// declare all of the modules
program_counter pc (address_of_next_instruction,
					clk, reset);	
					
					
reg write_instr_data; // always reading from instr mem
reg read_instr_data;
reg data_to_write;

wire [26:0] current_opcode;
wire [4:0] instr;
wire [6:0] dest;
wire [6:0] src1;
wire [6:0] src2;
wire [7:0] scalar;
instr_mem instruction_mem (current_opcode,      // outputs
                           instr,  //current_opcode[26:22]
				           dest,   //current_opcode[21:15]
				           src1,   //current_opcode[14:8]
				           src2,   //current_opcode[7:1]
				           scalar, //current_opcode[7:0]
                           address_of_next_instruction,  // inputs
			           	   write_instr_data,
				           read_instr_data,
				           data_to_write,
				           reset, clk);
						   
						   
wire [255:0] src1_data;
wire w_reg,
     r_reg;
wire [255:0] output_of_math;
output_reg output_register(src1_data,   // output
                           w_reg,       // inputs
				           r_reg, 
				           output_of_math, 
				           reset, clk);


wire [255:0] src2_data;
wire enable_mult;
matrix_mult multiplier(output_of_math,      //outputs
                       src1_data,           //inputs
				       src2_data, 
				       enable_mult, reset, clk);
					   
wire enable_add,
     enable_scale,
	 enable_transpose,
	 add_or_sub,
	 not_r_reg,
	 not_w_reg;

exe_engine execution_engine(r_reg,     //outputs
				            not_r_reg,
							w_reg,
				            not_w_reg,
							enable_add,
                            enable_scale,
				            enable_mult,
				            enable_transpose,
				            add_or_sub,
                            instr,      //inputs
							reset, clk); 


add_sub addition_subtraction(output_of_math, //outputs   
                             src1_data,     //inputs
				             src2_data, 
				             add_or_sub, enable_add, reset, clk);
							 




data_mem data_memory(src1_data,
                     src2_data,
 					 src1,
					 src2,
					 dest,
					 output_of_math,
					 not_w_reg,
					 not_r_reg,
					 reset, clk);
					 
					 
scale_matrix scale (output_of_math,     //outputs 
                    src1_data,              //inputs
				    scalar, 
				    enable_scale,
					reset, clk); 			 


transpose transp(output_of_math,  //outputs
                 src1_data,       //inputs
			     enable_transpose, 
			     reset, clk); 			   






initial // Clock generator
  begin
    clk = 0;
    forever #50 clk = !clk;
  end // INITIAL END	
	

initial
  begin
    reset = 0;
    write_instr_data = 1'b0;
	read_instr_data = 1'b1;
	data_to_write = 27'bz;





	
  end // END INITIAL
  
  
  always @ (posedge clk)
    begin

	
	end



endmodule
