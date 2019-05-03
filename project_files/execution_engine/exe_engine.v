/****************************************************************
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker

Module: exe_engine

Inputs: Control bits from OP Code
			instr[4:0]: 
				instr[4:2] : destined for decoder (maybe they don't need to be included in this module?
				instr[1]   : read from (0 = mem; 1 = reg)
				instrs[0]  : write to (0 = mem; 1 = reg)

Outputs: control bits destined for modules
         these bits will be brought in as a single variable, and distributed once inside this module

			read_from : 0=Read from mem, 1=read from reg
			write to  : 0=write to mem, 1=write to reg
			add_en,
			scale_en,
			mult_en,
			transpose_en,
			add_or_sub: 0=add, 1=sub

****************************************************************/

`timescale 1ns / 1ns

module exe_engine (read_from,     //outputs
				   not_read_from,
				   write_to,
				   not_write_to,
				   add_en,
				   scale_en,
				   mult_en,
				   transpose_en,
				   add_or_sub,
                   instr,        //inputs
				   reset, clk); 

output reg read_from,
           not_read_from,     //outputs
		   write_to,
		   not_write_to,
		   add_en,
		   scale_en,
		   mult_en,
		   transpose_en,
		   add_or_sub;

input wire [4:0] instr;
input clk, reset;

parameter add       = 3'b000;
parameter sub       = 3'b001;
parameter scale     = 3'b010;
parameter mult      = 3'b011;
parameter transpose = 3'b100;
//parameter write_reg = 3'b101;
//parameter write_mem = 3'b110;
parameter stop      = 3'b111;



always @ (posedge clk or posedge reset)
begin
/*************************************************************************************
	RESET SHOULD PROBABLY DO SOMETHING HERE, BUT WHAT?
	maybe it can just trigger the STOP instruciton
*************************************************************************************/

	// first assign the bits that passes thru the execution engine 
	// maybe remove from this module once everything is more clear (could have a more direct path to the destination)
	read_from = instr[0];
	write_to  = instr[1];
	#1; // ensure read_from and write_to were assigned before assigning their nots
	    // could be done with blocking, but not b/c I've heard horror stories about blocking in ModelSim
	not_read_from = !read_from;
	not_write_to = !write_to;
	
	
	// big case statement preforms the function of a decoder 
	// instruction bits are passed, control bits are assigned
	case (instr[4:2]) //only using the instruction code (first 3 bits) of the instruction register
		
		add       : begin // CASE ADD
						//write_to_reg = 1'b0;
					    //write_to_mem = 1'b0;
					    add_en       = 1'b1; // enable add/sub module
					    scale_en     = 1'b0;
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'b0; // choose add
					end

		sub       : begin // CASE SUBTRACT
						//write_to_reg = 1'b0;
						//write_to_mem = 1'b0;
					    add_en       = 1'b1; // enable add/sub module
					    scale_en     = 1'b0;
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'b1; // choose sub
				    end

		scale  	  : begin // CASE SCALE
						//write_to_reg = 1'b0;
					    //write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b1; // enable scale module
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'bz; // not used
					end
					
		mult      : begin // CASE MULTIPLY
						//write_to_reg = 1'b0;
					    //write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b1; // enable multiply module
					    transpose_en = 1'b0;
					    add_or_sub   = 1'bz; // not used
					end
					
		transpose : begin // CASE TRANSPOSE
						//write_to_reg = 1'b0;
					    //write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b0; 
					    transpose_en = 1'b1; // enable transpose module
					    add_or_sub   = 1'bz; // not used
					end
/********************************************************************************				
		write_reg  : begin // CASE WRITE TO REGISTER
						write_to_reg = 1'b1; // enable write to register
					    write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b0; 
					    transpose_en = 1'b0; 
					    add_or_sub   = 1'bz; 
					end

		write_mem : begin // CASE WRITE TO MEMORY
						write_to_reg = 1'b0;
					    write_to_mem = 1'b1; // enable write to memory
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b0; 
					    transpose_en = 1'b0; 
					    add_or_sub   = 1'bz; // not used
					end
*******************************************************************************/
		stop      : begin
						$display("Stop code has been executed");
						//$stop; // stop program when stop code is detected
                    end
		
		default   : $display("You did something way wrong. Default case in exe_engine reached!");

	endcase // CASE END
end // ALWAYS END
endmodule
