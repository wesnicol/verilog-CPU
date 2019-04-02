/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: data_mem(data, pointer, write_data, data_to_write, clk)

// output: data          | will be sent to the exe_engine
// inputs: pointer       | addresses the memory (points to section that will be used)
//         write_data    | if write_data = 1, data is written, else data won't be written
//         read_data     | if read_data = 1, data is read, otherwise output is held constant
//         data_to_write | if the write data bit = 1, then this data is written to the block pointed to by the program pointer
//		   reset		 | will reset all memory to 0s
//         clk           | the clock signal of the entire system
	
Purpose: This is the memory module that contains the datas that will be exectued
         by the execution engine. A program coutner input will dictate what data 
		 is driving the output.

Expected Result: Given different program counter inputs, datas corresponding to that
                 program count will be output.


*****************************************************************/

`timescale 1ns / 1ns
module data_mem(data, pointer, write_data, read_data, data_to_write, reset, clk);

integer i; 

output reg [255:0] data; // large enough to hold a single matrix


input wire [2:0] pointer; // pointer large enough to address 6 matracies
input wire write_data, read_data;
input wire [255:0] data_to_write;
input wire reset, clk;

reg mem [5:0][255:0]; // create a 6x256 bit array to store 6 256 bit matracies


always @ (posedge clk or posedge write_data or posedge read_data or posedge reset)
begin
	if(reset) // if reset is high
	  begin 
		data = 0;
	    i = 0;
		while(i < 256) // iterate through all spots in memory
		  begin
			mem[pointer][i] = 0;
			i = i+1;
	      end
	  end
	else // if reset is low advance with normal memory operation
	  begin
	    if(write_data) // write data
		  begin
		    i = 0; // make sure index starts from 0
			while(i < 256) // iterate through all places in the matrix
			  begin
				mem[pointer][i] = data_to_write[i]; // put incoming data into memory @ index pointer
				i = i+1; // increment index
			  end
		  end	
		else if(read_data)           // read data
		  begin
		    i = 0; // make sure index starts from 0
		    while(i < 256) // iterate through all places in the matrix
			  begin
				data[i] = mem[pointer][i]; // write contents of mem @ index pointer to data (output)
				i = i+1; // increment index
			  end
		  end
	
	  end
  end
endmodule