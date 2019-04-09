/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: instr_mem(data, pointer, write_data, data_to_write, clk)

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
module instr_mem(data, pointer, write_data, read_data, data_to_write, reset, clk);

integer i; 

output reg [25:0] data; // large enough to hold a single data


input wire [3:0] pointer; // pointer large enough to address 10 instructions
input wire write_data, read_data;
input wire [25:0] data_to_write;
input wire reset, clk;

reg mem [9:0][25:0]; // create a 10x26 bit array to store 10 26 bit opcodes


always @ (posedge clk or posedge write_data or posedge read_data or posedge reset)
begin
	if(reset) // if reset is high
	  begin 
		data = 0;
	    i = 0;
		while(i < 26) // iterate through all spots in memory
		  begin
			mem[pointer][i] = 0;
			i = i+1;
	      end // WHILE END
	  end // IF END
	else // if reset is low advance with normal memory operation
	  begin
	    if(write_data) // write data
		  begin
		    i = 0; // make sure index starts from 0
			while(i < 256) // iterate through all places in the matrix
			  begin
				mem[pointer][i] = data_to_write[i]; // put incoming data into memory @ index pointer
				i = i+1; // increment index
			  end // WHILE END
		  end // IF END
		else if(read_data)           // read data
		  begin
		    i = 0; // make sure index starts from 0
		    while(i < 256) // iterate through all places in the matrix
			  begin
				data[i] = mem[pointer][i]; // write contents of mem @ index pointer to data (output)
				i = i+1; // increment index
			  end // WHILE END 
		  end // ELSE IF END
	
	  end // ELSE END 
  end // ALWAYS END
endmodule