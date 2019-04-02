

/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: t_instr_mem (test bench)
	
Purpose: Test Bench for the instruction memory module. This test bench provides a clock, an index,
         sample data to write to memory, and a bit dictating whether to read or write

Expected Result: if write bit = 1, data will be written to addressed spot in memory
                 if read bit = 1, data will be read from addressed spot in memory


*****************************************************************/
`timescale 1ns / 1ns
module t_instr_mem;

integer i, j, n; // used as index in while loops

// test bench generates & supplies these values to module
reg write_data, read_data, reset, clk;
reg [25:0] data_to_write;
reg [3:0] pointer;


// test bench monitors these values (outputs of module being tested)
wire [25:0] data;



instr_mem foo(data, pointer, write_data, read_data, data_to_write, reset, clk);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end


/*********************
initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end
*********************/

 
initial // write/read each spot in memory
  begin

/***************************************
WRITE AND READ TO EVERY SPOT IN MEMORY
***************************************/
    i = 0;
    while(i < 10) // 10 spots to wirte to in memory
	  begin

	    pointer = i; // write 5555h to spot j in memory
		data_to_write = 26'h555555; // write 5555 to all bits (hexidecimal)
		write_data = 1; // indicate a write should be executed
		#1 write_data = 0;
	
	// read previous spot in memory (should be 5555h)
		#1 read_data = 1;
		#1 read_data = 0;
	
	// write AAAAh to spot in memory
		#1 data_to_write = 26'hAAAAAA; // write AAAA (hexidecimal)
		#1 write_data = 1; // indicate a write should be executed
		#1 write_data = 0;
	
	// read previous spot in memory
		#1 read_data = 1;
		#1 read_data = 0;
		
		
/********************************************************
READ FROM OTHER SPOTS IN MEMORY TO SHOW THEY ARE EMPTY
********************************************************/
        j = 0;
        while(j < 10)
		  begin 
		    pointer = j;
			#1 read_data = 1; // read spot in memory at loc n
			#1 read_data = 0;
			j = j+1;
		  end // end while loop with index j 
		
		pointer = i; // reassign the pointer to the current index
		
		
		
/***************************************
WALK AA ACROSS MEMORY
***************************************/
		#1 data_to_write = 26'hAA; // begin with 000...00AA
		
		
		
		n = 0; // start index from 0
		while(n < 6) // walking AA across all spots
		  begin
			#1 write_data = 1;
			#1 write_data = 0;
		
			#1 read_data = 1;
			#1 read_data = 0;
		
			#1 data_to_write = data_to_write * 26'h100; // this multiplication shifts AA two places left
		  
			n = n+1; // update index
		  end // end while loop with index n
	  
	    i = i+1;
	  end // end while loop with index i
  end // end always block

initial  // monoitor outputs here
    $monitor($stime, data);

endmodule
