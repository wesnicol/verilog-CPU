/****************************************************************
Author: Wes Nicol
Date  : 2019-04-16
Class : HDL
Professor: Mark Welker

Module: matrix_mult

Inputs: 
		m1     : first matrix
		m2     : second matrix
		enable : signal from instruction decode

Output: m_out : output matrix

This module does matrix multiply on the two input matricies and outputs 
the resulting matrix
Enable must be high for operation 

****************************************************************/

`timescale 1ns / 1ns

module matrix_mult (m_out,   //output
                    m1,      //inputs
				    m2, 
				    reset, clk); 

output reg [255:0] m_out; // matracies stored as single 256 bit variables (4row X 4col X 16bit)

input wire [255:0] m1; 
input wire [255:0] m2;
input wire clk, reset;



// unrolling for matrix multiplication

/******UNROLLING PROCESES*************
mA [row0][col0] = m1[15:0];
mA [row0][col1] = m1[31:16];
mA [row0][col2] = m1[47:32];
mA [row0][col3] = m1[63:48];
...
...
...
...etc...
*************************************/


integer row, col; // used as indicies in for loops

initial
  begin
  
	for(row = 0; row < num_rows; row++)  // unrolling m1 into mA
	  begin
		
		for(col = 0; col < num_cols; col++)
		  begin
			mA[col][row] = m1[ (col*16 + row*64) +15 : col*16 + row*64]
			
		  end // END FOR LOOP ROW
	  end // END FOR LOOP COL

  end // END INITIAL BLOCK

always @ (posedge clk or posedge reset)
begin




end // ALWAYS END
endmodule
