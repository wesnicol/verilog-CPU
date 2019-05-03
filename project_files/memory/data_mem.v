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
module data_mem(data1,
                data2,
				pointer1,
                pointer2,
				write_data_pointer,
				data_to_write,
                write_data,				
				read_data, 
				reset, clk);

integer i,row,col; 

output reg [255:0] data1; // large enough to hold a single matrix
output reg [255:0] data2; // large enough to hold a single matrix


input wire [2:0] pointer1; // pointer large enough to address 6 matracies
input wire [2:0] pointer2; // pointer large enough to address 6 matracies
input wire [2:0] write_data_pointer;
input wire [255:0] data_to_write;
input wire write_data, 
           read_data,
		   reset, clk;


reg [255:0] mem [5:0]; // create a 6x256 bit array to store 6 256 bit matracies



// hard code in matracies for demonstration of project
reg [15:0] matrix1 [3:0][3:0]; 
reg [15:0] matrix2 [3:0][3:0];
reg [255:0] m1;
reg [255:0] m2;

initial // assign predetermined matricies and unroll them
  begin
	// MATRIX 1
    matrix1[0][0] = 16'd04; matrix1[0][1] = 16'd12; matrix1[0][2] = 16'd04; matrix1[0][3] = 16'd34;
	matrix1[1][0] = 16'd07; matrix1[1][1] = 16'd06; matrix1[1][2] = 16'd11; matrix1[1][3] = 16'd09;
	matrix1[2][0] = 16'd09; matrix1[2][1] = 16'd02; matrix1[2][2] = 16'd08; matrix1[2][3] = 16'd13;
	matrix1[3][0] = 16'd02; matrix1[3][1] = 16'd15; matrix1[3][2] = 16'd16; matrix1[3][3] = 16'd03;
  
    // MATRIX 2
	matrix2[0][0] = 16'd23; matrix2[0][1] = 16'd45; matrix2[0][2] = 16'd67; matrix2[0][3] = 16'd22;
	matrix2[1][0] = 16'd07; matrix2[1][1] = 16'd06; matrix2[1][2] = 16'd04; matrix2[1][3] = 16'd01;
	matrix2[2][0] = 16'd18; matrix2[2][1] = 16'd56; matrix2[2][2] = 16'd13; matrix2[2][3] = 16'd12;
	matrix2[3][0] = 16'd03; matrix2[3][1] = 16'd05; matrix2[3][2] = 16'd07; matrix2[3][3] = 16'd09;
  
  
  
  	// set values of m1 from matrix1
    for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			
			m1[ (col*16 + row*64) +15 -: 16 ] = matrix1[row][col]; // the extra +15 allows the first index to be the larger number
			
		  end // END FOR LOOP COL
	  end // END FOR LOOP ROW
	
	
	// set values of m2 from matrix2
    for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			
			m2[ (col*16 + row*64) +15 -: 16 ] = matrix2[row][col]; // the extra +15 allows the first index to be the larger number
		  
		  end // END FOR LOOP COL
	  end // END FOR LOOP ROW
	  
	  
	// now physically place matricies in memory
	mem[0] = m1;
	mem[1] = m2;
	  

  end // END INITIAL


always @ (posedge clk)
  begin
	if(reset) // if reset is high
	  begin 
		data1 = 0;
		data2 = 0;
		mem[pointer1] = 0;
		mem[pointer2] = 0;
		
	  end // IF END
	else // if reset is low advance with normal memory operation
	  begin
	    
		//always drive data2 output

        data2 = mem[pointer2]; // put incoming data into memory @ index pointer

	    if(write_data) 
		  begin
			
			mem[write_data_pointer] = data_to_write; // put incoming data into memory @ index pointer

		  end	// IF END
		if(read_data)
		  begin

			data1 = mem[pointer1]; // write contents of mem @ index pointer to data (output)

		  end // IF END
		else // if not reading data
		  begin
		    // do not drive data1 output
			
				data1 = 256'bz; 

		  end // END ELSE   (read_data=0)
	  end // ELSE END
  end // END ALWAYS





reg [15:0] out_matrix [3:0][3:0]; // matrix for displaying memory contents
reg [255:0] m_out; 

initial // output the contents of matrix memory at the end of execution
  begin 
    #1000; // wait long enough for all instructions to be carried out


    for(i=0;i<6;i=i+1)
	  begin
		// set values of out_matrix1 from m_out
		for(row = 0; row < 4; row=row+1)  
		  begin
			for(col = 0; col < 4; col=col+1)
			  begin
				
				m_out = mem[i];
				out_matrix[row][col] = m_out[ (col*16 + row*64) +15 -: 16 ]; // the extra +15 allows the first index to be the larger number
				
			  end // END FOR LOOP col
		  end // END FOR LOOP row
		
		$display("Result matrix (mem[%d]:\n",i);
		
		$display("%d %d %d %d", out_matrix[0][0], out_matrix[0][1], out_matrix[0][2], out_matrix[0][3]);

		$display("%d %d %d %d", out_matrix[1][0], out_matrix[1][1], out_matrix[1][2], out_matrix[1][3]);
		
		$display("%d %d %d %d", out_matrix[2][0], out_matrix[2][1], out_matrix[2][2], out_matrix[2][3]);
		
		$display("%d %d %d %d", out_matrix[3][0], out_matrix[3][1], out_matrix[3][2], out_matrix[3][3]);
		
      end // END FOR LOOP i
  end // END INITIAL (for displaying memory contents)
  
  
  
endmodule
