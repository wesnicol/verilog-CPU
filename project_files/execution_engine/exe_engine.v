/****************************************************************
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker

Module: exe_engine

Inputs: Control bits from OP Code
			instr[4:0]: 
				instr[4:2] : destined for decoder (maybe they don't need to be included in this module?
				instr[1:0] : control bits not changed by execution engine, maybe should be removed for clarity

Outputs: control bits destined for modules
			read_from: 0=Read from reg, 1=read from memory,
			write_to_reg,
			write_to_mem,
			add_en,
			scale_en,
			mult_en,
			transpose_en,
			add_or_sub: 0=add, 1=sub

****************************************************************/

`timescale 1ns / 1ns

module exe_engine (read_from,     //outputs
				   write_to_reg,
				   write_to_mem,
				   add_en,
				   scale_en,
				   mult_en,
				   transpose_en,
				   add_or_sub,
                   instr, reset, clk); //inputs

output reg read_from,
		   write_to_reg,
		   write_to_mem,
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
parameter unused    = 3'b101;
parameter write_mem = 3'b110;
parameter stop      = 3'b111;



always @ (posedge clk or posedge reset)
begin
/*************************************************************************************
**************************************************************************************
	// RESET SHOULD PROBABLY DO SOMETHING HERE, BUT WHAT?
	maybe it can just trigger the STOP instruciton
**************************************************************************************
*************************************************************************************/

	// first assign the bits that pass thru the execution engine 
	// maybe remove these from this module once everything is more clear (they could have a more direct path to their destination)
	read_from = instr[1];
	write_to_reg = instr[0]; 
	
	// big case statement preforms the function of a decoder 
	// instruction bits are passed, control bits are assigned
	case (instr[4:2]) //only using the instruction code (first 3 bits) of the instruction register
		
		add       : begin // CASE ADD
					    write_to_mem = 1'b0;
					    add_en       = 1'b1; // enable add/sub module
					    scale_en     = 1'b0;
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'b0; // choose add
					end

		sub       : begin // CASE SUBTRACT
						write_to_mem = 1'b0;
					    add_en       = 1'b1; // enable add/sub module
					    scale_en     = 1'b0;
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'b1; // choose sub
				    end

		scale  	  : begin // CASE SCALE
					    write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b1; // enable scale module
					    mult_en      = 1'b0;
					    transpose_en = 1'b0;
					    add_or_sub   = 1'bz; // not used
					end
					
		mult      : begin // CASE MULTIPLY
					    write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b1; // enable multiply module
					    transpose_en = 1'b0;
					    add_or_sub   = 1'bz; // not used
					end
					
		transpose : begin // CASE TRANSPOSE
					    write_to_mem = 1'b0;
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b0; 
					    transpose_en = 1'b1; // enable transpose module
					    add_or_sub   = 1'bz; // not used
					end
					
		unused    : begin // UNUSED CASE -- all outputs not driven (all set to z)
					    write_to_mem = 1'bz;
					    add_en       = 1'bz; 
					    scale_en     = 1'bz; 
					    mult_en      = 1'bz; 
					    transpose_en = 1'bz; 
					    add_or_sub   = 1'bz; 
					end

		write_mem : begin // CASE WRITE TO MEMORY
					    write_to_mem = 1'b1; // enable transpose module
					    add_en       = 1'b0; 
					    scale_en     = 1'b0; 
					    mult_en      = 1'b0; 
					    transpose_en = 1'b0; 
					    add_or_sub   = 1'bz; // not used
					end
					
		stop      : begin
						$display("Stop code has been executed");
						//$stop; // stop program when stop code is detected
                    end
		
		default   : $display("You did something way wrong. Default case in exe_engine reached!");

	endcase
end
endmodule
