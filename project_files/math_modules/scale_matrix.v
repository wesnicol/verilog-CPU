/****************************************************************
Author: Wes Nicol
Date  : 2019-04-16
Class : HDL
Professor: Mark Welker

Module: scale_matrix

Inputs: 
		matrix : 4x4 matrix to be scaled
		scalar : 8-bit number that will be multiplied by every spot in the matrix
		enable : signal from instruction decode
		clk    : 
		
		
Outputs: 
		m_out : output matrix
        done  : flag -- set to 0 before operation, returned to 1 when finished

This module will scale every number in a 4x4 matrix by the input scalar.
The output will be the input matrix scaled up by the input scalar
****************************************************************/

`timescale 1ns / 1ns

module scale_matrix (m_out,     //outputs
                     done,   
                     matrix,    //inputs
				     scalar, 
				     enable, clk); 



// declare inputs, these are 1-dimensional to allow transfer between modules
input wire [255:0] matrix; 
input wire [7:0]   scalar;
input wire enable, clk;



// declare registers that do the actual operation
reg [15:0] m [3:0][3:0]; // MATRIX -- 4x4 matrix of 16 bit numbers

reg [15:0] m_result [3:0][3:0]; // this is the result matrix that is created from the math
// will need to be rolled back into the ouput matrix (m_out)



output reg [255:0] m_out; // matrix as single 256 bit variables (4row X 4col X 16bit)
// the above matrix is the 1-dimensional output matrix (to allow transfer between modules)


output reg done; // flag goes low when operation begins, returns high when finished








integer row, col; // used as indicies in for loops
//integer product; // result of multiplication that is then stored in the output matrix


always @ (posedge clk)
  begin
  
	
	
	if(enable) // only do operation if enable is high
	  begin
	  
	  
	    done = 1'b0; // set done flag to false before operation (set back after completion)
	    
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
			  
			    m_result[row][col] = (scalar) * (m[row][col]);

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
		
		done = 1'b1; // set done flag
		  
	  end // END IF(ENABLE)
  end // END ALWAYS @ CLK
endmodule

