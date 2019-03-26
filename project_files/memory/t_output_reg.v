

/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: t_memory (test bench)
	
Purpose: Test Bench for the output register module. This test bench provides a clock, an index,
         sample data to write to memory, and a bit dictating whether to read or write

Expected Result: if write bit = 1, data will be written to addressed spot in memory
                 if write bit = 0, data will be read from addressed spot in memory


*****************************************************************/

`timescale 1ns / 1ns
module t_output_reg;

// test bench generates & supplies these values to module
reg write_data, reset, clk;
reg [255:0] data_to_write;


// test bench monitors these values (outputs of module being tested)
wire [255:0] data;



output_reg foo(data, write_data, data_to_write, reset, clk);

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

  end

 
always @ (posedge clk) // write/read each spot in memory
  begin

/***************************************
WRITE AND READ TO EVERY SPOT IN MEMORY
***************************************/
	// write 5555h to spot in memory
	data_to_write = 255'h555555555555555555555555555555555555555555555555555555555555555; // write 5555 to all 256 bits (hexidecimal)
	write_data = 1; // indicate a write should be executed
	
	// read previous spot in memory (should be 5555h)
	#1 write_data = 0; // indicate a read should be executed
	
	
	
	// write AAAAh to spot in memory
	
	#1 data_to_write = 255'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA; // write AAAA (hexidecimal)
	#1 write_data = 1; // indicate a write should be executed
	
	// read previous spot in memory
	#1 write_data = 0;
	

  end

initial  // monoitor outpus here
    $monitor($stime, data);

endmodule
