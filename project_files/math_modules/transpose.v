/****************************************************************
Author: Wes Nicol
Date  : 2019-04-16
Class : HDL
Professor: Mark Welker

Module: transpose

Inputs: 
		matrix : 4x4 matrix to be transposed
		enable : signal from instruction decode
		clk    : 
		
		
Outputs: 
		m_out : output matrix

This module will transpose the input matrix and put the resulting matrix on the databus.
Transposing a matrix simply means flipping the row and column of each spot in the matrix
****************************************************************/

`timescale 1ns / 1ns

module transpose (m_out,     //outputs
                  matrix,    //inputs
			      enable, reset, clk); 



// declare inputs, these are 1-dimensional to allow transfer between modules
input wire [255:0] matrix; 
input wire enable, reset, clk;



// declare registers that do the actual operation
reg [15:0] m [3:0][3:0]; // MATRIX -- 4x4 matrix of 16 bit numbers

reg [15:0] m_result [3:0][3:0]; // this is the result matrix that is created from the math
// will need to be rolled back into the ouput matrix (m_out)



output reg [255:0] m_out; // matrix as single 256 bit variables (4row X 4col X 16bit)
// the above matrix is the 1-dimensional output matrix (to allow transfer between modules)







integer row, col; // used as indicies in for loops
//integer product; // result of multiplication that is then stored in the output matrix


always @ (posedge clk)
  begin
  
	
	
	if(enable) // only do operation if enable is high
	  begin
	  
	  
		// unroll matrix into useable variable

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
				
		
		// unrolling matrix into m
		for(row = 0; row < 4; row=row+1)  
		  begin
			for(col = 0; col < 4; col=col+1)
			  begin
				m[row][col] = matrix[ (col*16 + row*64) +15 -: 16 ]; // the extra +15 allows the first index to be the larger number
				
			  end // END FOR LOOP COL
		  end // END FOR LOOP ROW
	  
		







	    // actual math; scaling individual spots in matrix
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
			  
			    m_result[row][col] = m[col][row]; // just need to flip row and column of each spot

		      end // END FOR LOOP COL
	      end // END FOR LOOP ROW
	  
	  
	  
	  
	  
	  
	  
	    // rerolling result matrix into m_out
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
		    	m_out[ (col*16 + row*64) +15 -: 16 ] = m_result[row][col];
			
		      end // END FOR LOOP COL
	      end // END FOR LOOP ROW
		

	  end // END IF(ENABLE)
	else // if enable = 0
	  begin
	    
	    m_out = 256'bz; // assign output to z (undriven)
	  
	  end // END ELSE
  end // END ALWAYS @ CLK
endmodule


