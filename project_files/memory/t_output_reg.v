

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

integer i; // used as index in while loop

// test bench generates & supplies these values to module
reg write_data,read_data, reset, clk;
reg [255:0] data_to_write;


// test bench monitors these values (outputs of module being tested)
wire [255:0] data;



output_reg foo(data, write_data, read_data, data_to_write, reset, clk);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INITIAL END


/********************
initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end // INITIAL END
********************/


 
initial // set up initial conditions
  begin

  end // INITIAL END

 
initial // write/read each spot in memory
  begin
/***************************************
WRITE AND READ TO EVERY SPOT IN MEMORY
***************************************/
	// write 5555h to spot in memory
	data_to_write = 255'h5555555555555555555555555555555555555555555555555555555555555555; // write 5555 to all 256 bits (hexidecimal)
	write_data = 1; // indicate a write should be executed
	#1 write_data = 0;
	
	// read previous spot in memory (should be 5555h)
	#1 read_data = 1;
	#1 read_data = 0;
	
	// write AAAAh to spot in memory
	#1 data_to_write = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA; // write AAAA (hexidecimal)
	#1 write_data = 1; // indicate a write should be executed
	#1 write_data = 0;
	
	// read previous spot in memory
	#1 read_data = 1;
	#1 read_data = 0;
	
	
	
/***************************************
WALK AA ACROSS MEMORY
***************************************/
	
	#1 data_to_write = 256'hAA; // begin with 000...00AA
	
	
	
	i = 0; // start index from 0
	while(i < 32) // walking AA across 32 total spots
	  begin
		#1 write_data = 1;
		#1 write_data = 0;
		
		#1 read_data = 1;
		#1 read_data = 0;
		
		data_to_write = data_to_write * 256'h100; // this multiplication shifts AA two places left
	
	    i = i+1; // update index
	  end // WHIEL END
	
	
	

  end // INITIAL END

initial  // monoitor outpus here
    $monitor($stime, data);

endmodule
