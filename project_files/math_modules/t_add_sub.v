/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker 

Module: t_add_sub (test bench)
	
Purpose: Test Bench for the add_sub module. This test bench provides 
         two matricies to be added or subtracted, an operation select (select_op),
		 a clock, and an enable

Expected Result: The two input matricies should be added or subtracted and the result
                 should be seen as an output of the module.
				 First an addition will be preformed and the resulting matrix displayed,
				 then a subtraction will be preformed and the resulting matrix displayed.
*****************************************************************/

`timescale 1ns / 1ns
module t_add_sub;

// test bench generates & supplies these values to the module being tested
reg select_op, enable, clk, reset;
reg [255:0] m1;
reg [255:0] m2;


// test bench monitors these values (outputs of module being tested)
wire [255:0] m_out;


// define the input matracies 
reg [15:0] matrix1 [3:0][3:0]; 
reg [15:0] matrix2 [3:0][3:0];

 
reg [15:0] out_matrix [3:0][3:0]; // used to display output matrix





integer row, col; //  for-loop indicies 

add_sub foo (m_out, //outputs
             m1,    //inputs
			 m2, 
			 select_op, enable, reset, clk); 


initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INITIAL END


/*************************
initial	// Reset test
  begin
    reset = 0;
    #1 reset = 1;
    #1 reset = 0;
  end // INTIAL END
*************************/


initial // set up initial conditions
  begin
  
    // define the contents of input matracies
	

	// MATRIX 1
	matrix1[0][0] = 16'd11; matrix1[0][1] = 16'd14; matrix1[0][2] = 16'd19; matrix1[0][3] = 16'd18;
	matrix1[1][0] = 16'd08; matrix1[1][1] = 16'd09; matrix1[1][2] = 16'd15; matrix1[1][3] = 16'd05;
	matrix1[2][0] = 16'd12; matrix1[2][1] = 16'd10; matrix1[2][2] = 16'd15; matrix1[2][3] = 16'd14;
	matrix1[3][0] = 16'd10; matrix1[3][1] = 16'd07; matrix1[3][2] = 16'd08; matrix1[3][3] = 16'd07;
	
	
    
  
    // MATRIX 2
	matrix2[0][0] = 16'd5; matrix2[0][1] = 16'd8; matrix2[0][2] = 16'd9; matrix2[0][3] = 16'd2;
	matrix2[1][0] = 16'd7; matrix2[1][1] = 16'd3; matrix2[1][2] = 16'd8; matrix2[1][3] = 16'd4;
	matrix2[2][0] = 16'd6; matrix2[2][1] = 16'd5; matrix2[2][2] = 16'd4; matrix2[2][3] = 16'd3;
	matrix2[3][0] = 16'd8; matrix2[3][1] = 16'd5; matrix2[3][2] = 16'd7; matrix2[3][3] = 16'd6;
  
  
  
  
  
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
	
	
	
	
  end // INITIAL END
 
always @ (posedge clk) // cycle through instructions
  begin
    
	select_op = 1'b0; // start by selecting addition
	
    #5 enable = 1'b1; //enable the module after the reset test

	#50 // give ample time for addition to shake out and be displayed
	
	enable = 1'b0; // turn off the module to set up for subtraction
	
	select_op = 1'b1; // select subtraction
	
	#5 enable = 1'b1; // now tell module to begin subtration
	
  end // ALWAYS END

always @ (posedge enable) // trigger a display loop whenever the module enable goes high
  begin
  
    #20 // allow everything to settle before you display addition result
			 
			 
			 
	// display the resulting matricies
  
	// set values of out_matrix1 from m_out
    for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			
			out_matrix[row][col] = m_out[ (col*16 + row*64) +15 -: 16 ]; // the extra +15 allows the first index to be the larger number
			
		  end // END FOR LOOP col
	  end // END FOR LOOP row
	
    $display("Result matrix:\n");
	
	$display("%d %d %d %d", out_matrix[0][0], out_matrix[0][1], out_matrix[0][2], out_matrix[0][3]);

	$display("%d %d %d %d", out_matrix[1][0], out_matrix[1][1], out_matrix[1][2], out_matrix[1][3]);
	
	$display("%d %d %d %d", out_matrix[2][0], out_matrix[2][1], out_matrix[2][2], out_matrix[2][3]);
	
	$display("%d %d %d %d", out_matrix[3][0], out_matrix[3][1], out_matrix[3][2], out_matrix[3][3]);
	
	
  end // END ALWAYS BLOCK USED FOR DISPLAYING
	
endmodule

