
/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: t_memory (test bench)
	
Purpose: Test Bench for the memory module. This test bench provides a clock, an index,
         sample data to write to memory, and a bit dictating whether to read or write

Expected Result: if write bit = 1, data will be written to addressed spot in memory
                 if write bit = 0, data will be read from addressed spot in memory


*****************************************************************/

`timescale 1ns / 1ns
module t_memory;

// test bench generates & supplies these values to module
reg write_data, clk;
reg [25:0] data_to_write;
reg [3:0] prog_pointer;

// test bench monitors these values (outputs of module being tested)
wire [25:0] opcode;



instr_mem foo(opcode, prog_pointer, write_data, data_to_write, clk);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end


/****************************
initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end
****************************/


 
initial // set up initial conditions
  begin
	prog_pointer = 0; // set pointer to first index
	
  end
 
always @ (posedge clk) // write/read each spot in memory
  begin
    while(prog_pointer < 10)
	begin
	
		// write 5555h to spot in memory
		write_data = 1; // indicate a write should be executed
		data_to_write = 16'h5555; // write 5555 (hexidecimal)
		
		// read previous spot in memory (should be 5555h)
		write_data = 0; // indicate a read should be executed
		
		// write AAAAh to spot in memory
		write_data = 1; // indicate a write should be executed
		data_to_write = 16'hAAAA; // write AAAA (hexidecimal)
		// read previous spot in memory
		write_data = 0;
		prog_pointer = prog_pointer + 1'b1; // add 1 to prog_pointer to advance thorugh memory
	end
  end

initial  // monoitor outpus here
    $monitor($stime, opcode);

endmodule
