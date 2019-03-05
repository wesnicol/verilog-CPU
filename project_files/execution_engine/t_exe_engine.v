/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker 

Module: t_exe_engine (test bench)
	
Purpose: Test Bench for the exe_engine module. This test bench provides 
         a pre-determined instruction, a clock, and a reset as inputs

Expected Result: Given a certian input (a 5-bit instruction), control
                 bits should be assigned according to the
				 opcode discription document


*****************************************************************/

`timescale 1ns / 1ns
module t_exe_engine;

// test bench generates & supplies these values to exe_engine
reg clk, reset;
reg instr[4:0];

// test bench monitors these values (outputs of exe_engine)
wire read_from,
	 write_to_reg,
	 write_to_mem,
	 add_en,
	 scale_en,
	 mult_en,
	 transpose_en,
	 add_or_sub;


exe_engine foo(read_from,     //outputs
			   write_to_reg,
			   write_to_mem,
			   add_en,
			   scale_en,
			   mult_en,
			   transpose_en,
			   add_or_sub,
               instr, reset, clk); //inputs 

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end

initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end
 
initial // set up initial conditions
  begin
	instr = 1'b0; // start at instruction 00000
	// no other initial conditions for now
  end
 
always @ (posedge clk) // cycle through instructions
  begin
    instr = instr + 1'b1; // add 1 to instruction every clk
	                      // ensures complete coverage of instruction possiblities
  end

initial
    $monitor($stime,
			 instr,
	         read_from,
			 write_to_reg,
			 write_to_mem,
			 add_en,
			 scale_en,
			 mult_en,
			 transpose_en,
			 add_or_sub);

endmodule
