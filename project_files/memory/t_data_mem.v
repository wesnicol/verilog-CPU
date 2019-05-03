

/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: t_data_memory (test bench)
	
Purpose: Test Bench for the data memory module. This test bench provides a clock, an index,
         sample data to write to memory, and a bit dictating whether to read or write

Expected Result: if write bit = 1, data will be written to addressed spot in memory
                 if read bit = 1, data will be read from addressed spot in memory


*****************************************************************/

`timescale 1ns / 1ns
module t_data_memory;

integer i, j, n; // used as index in while loops

// test bench generates & supplies these values to module
reg write_data, read_data, reset, clk;
reg [2:0] write_data_pointer;
reg [255:0] data_to_write;
reg [2:0] pointer1;
reg [2:0] pointer2;


// test bench monitors these values (outputs of module being tested)
wire [255:0] data1;
wire [255:0] data2;


data_mem foo   (data1,              // outputs
                data2,
				pointer1,          // inputs
                pointer2,
				write_data_pointer,
				data_to_write,
                write_data,				
				read_data, 
				reset, clk);
				
				
initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INTIAL END


/*********************
initial	// Reset test
  begin
    reset = 0;
    #5 reset = 1;
    #4 reset = 0;
  end
*********************/


initial // set flags to zero
  begin 
	write_data = 0;
	read_data = 0;
	reset = 0;
  end // INITAL END





initial
  begin



/***************************************
WRITE AND READ TO EVERY SPOT IN MEMORY

    i = 0;
    while(i < 6) // 6 spots to wirte to in memory
	  begin

	    pointer = i; // write 5555h to spot j in memory
		data_to_write = 256'h5555555555555555555555555555555555555555555555555555555555555555; // write 5555 to all 256 bits (hexidecimal)
		#1 write_data = 1; // indicate a write should be executed
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
		
		
/********************************************************
READ FROM OTHER SPOTS IN MEMORY TO SHOW THEY ARE EMPTY

        j = 0;
        while(j < 6)
		  begin 
		    pointer = j;
			#1 read_data = 1; // read spot in memory at loc n
			#1 read_data = 0;
			j = j+1;
		  end // end while loop with index j 
		
		pointer = i; // reassign the pointer to the current index
		
		
		
/***************************************
WALK AA ACROSS MEMORY

		#1 data_to_write = 256'hAA; // begin with 000...00AA
		
		
		
		n = 0; // start index from 0
		while(n < 32) // walking AA across all spots
		  begin
			#1 write_data = 1;
			#1 write_data = 0;
		
			#1 read_data = 1;
			#1 read_data = 0;
		
			#1 data_to_write = data_to_write * 256'h100; // this multiplication shifts AA two places left
		  
			n = n+1; // update index
		  end // end while loop with index n
	  
	    i = i+1;
	  end // end while loop with index i
	  
**********************************************************************************************/

    
    





  end // end initial block

initial  // monoitor outputs here
  begin
    data_to_write = 256'b0;
	write_data = 1'b1;
	#20 write_data_pointer = 3'd2;
	#20 write_data_pointer = 3'd3;
	#20 write_data_pointer = 3'd4;
	#20 write_data_pointer = 3'd5;
	
	
	#20 write_data = 1'b0;
	read_data = 1'b1;
	pointer1 = 3'd0;
    pointer2 = 3'd0;
	#20 pointer1 = 3'd1;
	pointer2 = 3'd1;
	#20 pointer1 = 3'd2;
	pointer2 = 3'd2;
	#20 pointer1 = 3'd3;
	pointer2 = 3'd3;
	#20 pointer1 = 3'd4;
	pointer2 = 3'd4;
	#20 pointer1 = 3'd5;
	pointer2 = 3'd5;
  
  end // END initial block for monitoring outputs
  

endmodule
