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
reg [4:0] instr;

// test bench monitors these values (outputs of exe_engine)
wire read_from,
     not_read_from,
	 write_to,
	 not_write_to,
	 add_en,
	 scale_en,
	 mult_en,
	 transpose_en,
	 add_or_sub;


exe_engine foo(read_from,       //outputs
               not_read_from,    
			   write_to,
			   not_write_to,
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
  end // INITIAL END



/*****************************
initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end // INTIAL END
******************************/


initial // set up initial conditions
  begin
	instr = 5'b0; // start at instruction 00000
	// no other initial conditions for now
  end // INITIAL END
 
always @ (posedge clk) // cycle through instructions
  begin
    
	// test all valid instructions

    #15 instr = 5'b001_1_1; // sub	
	#20 instr = 5'b010_1_1; // scale 
	#20 instr = 5'b011_1_1; // multiply
	#20 instr = 5'b100_1_1; // transpose 
  
  
  
  end // ALWAYS END

initial
  begin
  
  end // END inital for monitoring

endmodule
