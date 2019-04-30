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
module instr_mem(data,         // outputs
                 data_instr,
				 data_dest,
				 data_src1,
				 data_src2,
				 data_scalar,
                 pointer,      // inputs
				 write_data,
				 read_data,
				 data_to_write,
				 reset, clk);

integer i; 

output reg [26:0] data; // large enough to hold a single opcode
output reg [4:0] data_instr;
output reg [6:0] data_dest;
output reg [6:0] data_src1;
output reg [6:0] data_src2;
output reg [7:0] data_scalar;



input wire [3:0] pointer; // pointer large enough to address 10 instructions
input wire write_data, read_data;
input wire [26:0] data_to_write;
input wire reset, clk;

reg [26:0] mem [9:0]; // create a 10x26 bit array to store 10 26 bit opcodes





/***********************HARD CODED OPCODES FOR PRESENTATION OF PROJECT ***********/
// this is a series of opcodes in a predefined order
// opcodes are stored as 27-bit numbers

/********************************************************************************/

// hard code predetermined opcodes
initial
  begin
    
    // operation 1: Add the first matrix (mem[0]) to the second matrix (mem[1]) and 
	//              store the result in memory mem[2]
	mem[0] = 27'b000000000010000000000000010;


	// operation 2: Subtract the first matrix (mem[0]) from the result in step 1 (mem[2]) and 
	//              store the result somewhere else in memory mem[3]
	mem[1] = 27'b001000000011000000000000100;


	// operation 3: Transpose the result from step 1 (mem[2])
	//              store in memory mem[4]
	mem[2] = 27'b100000000100000001000000000;


	// operation 4: Scale the result in step 3 (mem[4]) 
	//              store in the register
	mem[3] = 27'b010100000000000010000101010;


	// operation 5: Multiply the result from step 4 (reg) by the result in step 3 (mem[4])
	//              store in memory mem[5]
	mem[4] = 27'b011010000101000000000001000;
    
	
  
  
  
  end // end initial

always @ (posedge clk)
begin
	if(reset) // if reset is high
	  begin 
		data = 0;
	    i = 0;
	    mem[pointer] = 0;

	  end // IF END
	else // if reset is low advance with normal memory operation
	  begin
	    if(write_data) // write data
		  begin
		    
			mem[pointer] = data_to_write; // put incoming data into memory @ index pointer

		  end // IF END
		else if(read_data)           // read data
		  begin
		    
			data = mem[pointer]; // write contents of mem @ index pointer to data (output)
			
			//assign all the different parts of op_code for individual usage
			data_instr  = data[26:22];
			data_dest   = data[21:15];
			data_src1   = data[14:8];
			data_src2   = data[7:1];
			data_scalar = data[7:0];

		  end // ELSE IF END
	
	  end // ELSE END 
  end // ALWAYS END
endmodule