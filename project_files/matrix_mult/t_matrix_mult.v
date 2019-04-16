/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker 

Module: t_matrix_mult (test bench)
	
Purpose: Test Bench for the matrix_mult module. This test bench provides 
         two matricies to be multiplied together, a clock, and an enable

Expected Result: The two input matricies should be multiplied and the result
                 should be seen as an output of the module.
				 Also a done flag should be seen as an output that goes high
				 once the operation has completed
*****************************************************************/

`timescale 1ns / 1ns
module t_matrix_mult;

// test bench generates & supplies these values to the module being tested
reg enable, clk, reset;
reg [255:0] m1;
reg [255:0] m2;


// test bench monitors these values (outputs of module being tested)
wire [255:0] m_out;
wire done;

// define the input matracies 
reg [15:0] matrix1 [3:0][3:0]; 
reg [15:0] matrix2 [3:0][3:0];

 
reg [15:0] out_matrix [3:0][3:0]; // used to display output matrix





integer row, col; //  for-loop indicies 

matrix_mult foo (m_out, //outputs
                 done,   
                 m1,    //inputs
				 m2, 
				 enable, reset, clk); 


initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INITIAL END

initial	// Reset test
  begin
    reset = 0;
    #1 reset = 1;
    #1 reset = 0;
  end // INTIAL END
 
initial // set up initial conditions
  begin
  
    // define the contents of input matracies
	

	// MATRIX 1
    matrix1[0][0] = 16'd5; matrix1[0][1] = 16'd8; matrix1[0][2] = 16'd9; matrix1[0][3] = 16'd2;
	matrix1[1][0] = 16'd7; matrix1[1][1] = 16'd3; matrix1[1][2] = 16'd8; matrix1[1][3] = 16'd4;
	matrix1[2][0] = 16'd6; matrix1[2][1] = 16'd5; matrix1[2][2] = 16'd4; matrix1[2][3] = 16'd3;
	matrix1[3][0] = 16'd8; matrix1[3][1] = 16'd5; matrix1[3][2] = 16'd7; matrix1[3][3] = 16'd6;
  
    // MATRIX 2
	matrix2[0][0] = 16'd11; matrix2[0][1] = 16'd14; matrix2[0][2] = 16'd19; matrix2[0][3] = 16'd18;
	matrix2[1][0] = 16'd06; matrix2[1][1] = 16'd09; matrix2[1][2] = 16'd03; matrix2[1][3] = 16'd05;
	matrix2[2][0] = 16'd12; matrix2[2][1] = 16'd10; matrix2[2][2] = 16'd15; matrix2[2][3] = 16'd14;
	matrix2[3][0] = 16'd01; matrix2[3][1] = 16'd03; matrix2[3][2] = 16'd05; matrix2[3][3] = 16'd07;
  
  
  
  
  
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
  
    #5 enable = 1'b1; //enable the module after the reset test
	// can't say exactly why, but this always block is so satisfying 
	
  end // ALWAYS END

initial
  begin
    #20 // allow everything to settle before you display 
			 
			 
			 
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
	
	
  end // END INITIAL BLOCK USED FOR DISPLAYING
	
endmodule

