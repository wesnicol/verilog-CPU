
`timescale 1ns / 1ns
module t_program_counter;

reg clk, reset;
reg [15:0] offset; //arbitrarily set to 16 bits until a different requirement is realized
wire [31:0] address;

program_counter foo (address, offset, clk, reset);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end // INITIAL END
  

initial // block to set conditions of counter
  begin
    reset = 0;
    offset = 16'hA; //set the size of the offset here
    #1 reset = 1; // forces the address to start at 0
    #1 reset = 0;
  end // INITIAL END

initial
    $monitor($stime,, reset,, clk,,, address, offset); 
    
endmodule 
