/****************************************************************
Author: Wes Nicol
Date  : 2019-04-16
Class : HDL
Professor: Mark Welker

Module: add_sub

Inputs: 
		m1        : first matrix
		m2        : second matrix
		select_op : selects whether additoin or subtraction will be preformed
		            (0 = add)
					(1 = sub)	
		enable    : signal from instruction decode
		reset     : currently unused

Outputs: 
		m_out : matrix resluting from the operation
        

This module will add or subtract two matracies and put the resulting matrix on the databus.
The operation must be selected with the select_op input
****************************************************************/

`timescale 1ns / 1ns

module add_sub (m_out, //outputs   
                m1,    //inputs
				m2, 
				select_op, enable, reset, clk); 

output reg [255:0] m_out; // matracies input as single 256 bit variables (4row X 4col X 16bit)



input wire [255:0] m1; 
input wire [255:0] m2;
input wire select_op, enable, clk, reset;


// declare registers that do the actual operation
reg [15:0] mA [3:0][3:0]; // MATRIX A -- 4x4 matrix of 16 bit numbers
reg [15:0] mB [3:0][3:0]; // MATRIX B -- 4x4 matrix of 16 bit numbers
reg [15:0] mR [3:0][3:0]; // RESULT MATRIX -- 4x4 matrix of 16 bit numbers







integer row, col; // used as indicies in for loops
integer sum; // used in addition/subtraction loop


always @ (posedge clk)
  begin
  
	
	
	if(enable) // only do operation if enable is high
	  begin
	  	    
		// unrolling for matrix operations

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
				
		
		// unrolling m1 into mA
		for(row = 0; row < 4; row=row+1)  
		  begin
			for(col = 0; col < 4; col=col+1)
			  begin
				mA[row][col] = m1[ (col*16 + row*64) +15 -: 16 ]; // the extra +15 allows the first index to be the larger number
				
			  end // END FOR LOOP COL
		  end // END FOR LOOP ROW
	  
		// unrolling m2 into mB
		for(row = 0; row < 4; row=row+1)  
		  begin
			for(col = 0; col < 4; col=col+1)
			  begin
				mB[row][col] = m2[ (col*16 + row*64) +15 -: 16 ]; // the extra +15 allows the first index to be the larger number
				
			  end // END FOR LOOP COL
		  end // END FOR LOOP ROW







	    // matrix addition/subtraction
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
			  
			    if(select_op)             
				  begin
				    // SUBTRACTION (op_enable = 1)
				    
				    mR[row][col] = mA[row][col] - mB[row][col]; //where the magic happens
				  
				  end //END if(op_enable)
			    else                      
				  begin
				    // ADDITION (op_enable = 0)
					
					mR[row][col] = mA[row][col] + mB[row][col]; //where the magic happens
				  
				  end // END else (op_enable)

		      end // END FOR LOOP COL
	      end // END FOR LOOP ROW
	  
	  
	  
	  
	  
	  
	  
	    // rerolling result matrix into m_out
	    for(row = 0; row < 4; row=row+1)  
	      begin
		    for(col = 0; col < 4; col=col+1)
		      begin
		    	m_out[ (col*16 + row*64) +15 -: 16 ] = mR[row][col];
			
		      end // END FOR LOOP COL
	      end // END FOR LOOP ROW
		
		  
	  end // END IF(ENABLE)
	else // IF ENABLE = 0
	  begin
		// when enable = 0, don't drive anything, all output should = z
		m_out = 256'bz; // assign all spots to z (undriven)
	  
	  
	  end // END else 
	  
	  
  end // END ALWAYS @ CLK OR RESET OR ENABLE
endmodule
