/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-25
Class : HDL
Professor: Mark Welker 

Module: output_reg(data, pointer, write_data, data_to_write, clk)

// output: data          | will be retrieved when read is selected. This will be a 16x16 bit array
                           the array will represent a matrix with 16 bit numbers at each location
						   the first 16 bits represent row0 col0, the next 16 bits represent row0, col1 and so on
// inputs: write_data    | if write_data = 1, data is written, else data is read
//         data_to_write | if the write data bit = 1, then this data is written to the block pointed to by the program pointer
//         clk           | the clock signal of the entire system
	
Purpose: This is the memory module that represents the output register. Same as other memory 
         moduals, only difference is naming and size
Expected Result: Data will either be written to the single register or be read from it


*****************************************************************/

`timescale 1ns / 1ns
module output_reg(data, write_data, data_to_write, reset, clk);

integer i; // used as an index in the while loop

output reg [255:0] data; // large enough to hold a single 4x4 matrix of 16 bit numbers


input wire write_data;
input wire [255:0] data_to_write;
input wire reset, clk;

reg mem [255:0]; // create a 16x16 bit array to store 1 matrix


always @ (posedge clk or write_data or posedge reset)
  begin
	if(reset)
	  begin
	    i = 0; // make sure index starts from 0
		while(i < 256)
		  begin 
		    mem[i] = 0; // reset all bits 
			i = i+1; // increment index
		  end
	  end
	else
	  begin
		if(write_data) // write data
		  begin
		    i = 0; // make sure index starts from 0
			while(i < 256) // iterate through all places in the matrix
			  begin
				mem[i] = data_to_write[i]; // put incoming data into memory @ index pointer
				i = i+1; // increment index
			  end
		  end	
		else           // read data
		  begin
		    i = 0; // make sure index starts from 0
		    while(i < 256) // iterate through all places in the matrix
			  begin
				data[i] = mem[i]; // write contents of mem @ index pointer to data (output)
				i = i+1; // increment index
			  end
		  end
	  end
  end
endmodule
