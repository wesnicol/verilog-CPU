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

Outputs: 
		m_out : output matrix
        done : flag -- set to 1 for one tick when operation is finished


This module does matrix multiply on the two input matricies and outputs 
the resulting matrix
Enable must be high for operation 
****************************************************************/

`timescale 1ns / 1ns

module matrix_mult (m_out,   //output
                    m1,      //inputs
				    m2, 
				    enable, reset, clk); 

output reg [255:0] m_out; // matracies input as single 256 bit variables (4row X 4col X 16bit)

input wire [255:0] m1; 
input wire [255:0] m2;
input wire enable, clk, reset;


// declare registers that do the actual operation
reg [15:0] mA [3:0][3:0]; // MATRIX A -- 4x4 matrix of 16 bit numbers
reg [15:0] mB [3:0][3:0]; // MATRIX B -- 4x4 matrix of 16 bit numbers
reg [15:0] mR [3:0][3:0]; // RESULT MATRIX -- 4x4 matrix of 16 bit numbers




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


integer row, col, i; // used as indicies in for loops
integer sum; // used in matrix multiplication loop

always @ (posedge enable) // inputs are unrolled only at the beginning of each use
  begin
  
    // unrolling m1 into mA
	for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			mA[col][row] = m1[ (col*16 + row*64) +15 -: 15 ]; // the extra +15 allows the first index to be the larger number
			
		  end // END FOR LOOP ROW
	  end // END FOR LOOP COL
	  
	  
	  
	  
	// unrolling m2 into mB
	for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			mB[col][row] = m2[ (col*16 + row*64) +15 -: 15 ]; // the extra +15 allows the first index to be the larger number
			
		  end // END FOR LOOP ROW
	  end // END FOR LOOP COL
  end // END ALWAYS @ ENABLE BLOCK
  
  
  
  
  
// actual matrix multiplication happens in the below block

always @ (posedge clk or posedge reset or posedge enable)
  begin
	
	if(enable) // only do operation if enable is high
	  begin
	    
	    // matrix multiplication
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
			    
				sum = 0;
				
		    	for(i = 0; i < 4; i=i+1)
				  begin
				    sum = sum + mA[row][i] * mB[i][col];
					mR[row][col] = sum;
					
				  end // END FOR LOOP i
		      end // END FOR LOOP ROW
	      end // END FOR LOOP COL
	  
	  
	  
	  
	  
	  
	  
	  
	    // rerolling result matrix into m_out
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
		    	m_out[ (col*16 + row*64) +15 -: 15] = mR[col][row];
			
		      end // END FOR LOOP ROW
	      end // END FOR LOOP COL
		  
		  
	  end // END IF(ENABLE)
  end // END ALWAYS @ CLK OR RESET OR ENABLE
endmodule
