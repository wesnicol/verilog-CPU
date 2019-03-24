/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-21
Class : HDL
Professor: Mark Welker 

Module: instr_mem(opcode, prog_pointer, write_data, data_to_write, clk)

// output: opcode        | will be sent to the exe_engine
// inputs: prog_pointer  | addresses the memory (points to section that will be used)
//         write_data    | if write_data = 1, data is written, else data is read
//         data_to_write | if the write data bit = 1, then this data is written to the block pointed to by the program pointer
//         clk           | the clock signal of the entire system
	
Purpose: This is the memory module that contains the opcodes that will be exectued
         by the execution engine. A program coutner input will dictate what opcode 
		 is driving the output.

Expected Result: Given different program counter inputs, opcodes corresponding to that
                 program count will be output.


*****************************************************************/

`timescale 1ns / 1ns
module instr_mem(opcode, prog_pointer, write_data, data_to_write, clk);

output reg [25:0] opcode; // large enough to hold a single opcode


input wire [3:0] prog_pointer;
input wire write_data;
input wire [25:0] data_to_write;
input wire clk;

reg [25:0] mem [9:0]; // create a 10x26 bit array to store 10 26 bit opcodes


always @ (posedge clk or write_data)
begin

	if(write_data) // write data
		mem [prog_pointer] = data_to_write; // put incoming data into memory @ index prog_pointer
	else           // read data
		opcode = mem [prog_pointer]; // write contents of mem @ index prog_pointer to opcode (output)

end
endmodule