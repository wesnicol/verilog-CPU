/***************************************************************** 
Author: Wes Nicol
Date  : 2019-03-05
Class : HDL
Professor: Mark Welker 

Module: t_scale_matrix (test bench)
	
Purpose: Test Bench for the scale_matrix module. This test bench provides 
         a matrix to be scaled, the scalar number, a clock, and an enable

Expected Result: The output matrix will be identical to the input matrix, 
                 however every spot in the matrix will be scaled by the 
				 input scalar.
*****************************************************************/

`timescale 1ns / 1ns
module t_scale_matrix;

// test bench generates & supplies these values to the module being tested
reg enable, clk;
reg [255:0] matrix;
reg [7:0] scalar;


// test bench monitors these values (outputs of module being tested)
wire [255:0] m_out;

// define the input matrix
reg [15:0] input_matrix [3:0][3:0]; 


 
reg [15:0] out_matrix [3:0][3:0]; // used to display output matrix





integer row, col; //  for-loop indicies 

scale_matrix foo (m_out,     //outputs
                  matrix,    //inputs
				  scalar, 
				  enable, clk); 


initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INITIAL END


/****************************************
initial	// Reset test
  begin
    reset = 0;
    #1 reset = 1;
    #1 reset = 0;
  end // INTIAL END
****************************************/


initial // set up initial conditions
  begin
  
    // initialize the contents of input matrix
	
	// MATRIX 1
    input_matrix[0][0] = 16'd05; input_matrix[0][1] = 16'd08; input_matrix[0][2] = 16'd09; input_matrix[0][3] = 16'd02;
	input_matrix[1][0] = 16'd07; input_matrix[1][1] = 16'd03; input_matrix[1][2] = 16'd08; input_matrix[1][3] = 16'd04;
	input_matrix[2][0] = 16'd06; input_matrix[2][1] = 16'd05; input_matrix[2][2] = 16'd04; input_matrix[2][3] = 16'd03;
	input_matrix[3][0] = 16'd08; input_matrix[3][1] = 16'd05; input_matrix[3][2] = 16'd07; input_matrix[3][3] = 16'd06;
  
    //initialize scalar
    scalar = 8'd5; 
  
  
    // set values of m from matrix
    for(row = 0; row < 4; row=row+1)  
	  begin
		for(col = 0; col < 4; col=col+1)
		  begin
			
			matrix[ (col*16 + row*64) +15 -: 16 ] = input_matrix[row][col]; // the extra +15 allows the first index to be the larger number
			
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
    #50 // allow everything to settle before you display 
			 
			 
			 
	// display the resulting matricies
  
	// set values of out_matrix from m_out
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


