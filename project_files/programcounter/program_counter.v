





// this module is intended to function as a program counter for a 32-bit system

// output: address      | represents the sum of offset and the address value stored in the register
// inputs: 
//         clk          | the clock signal of the entire system
//         reset        | address is reset to 0 when reset==1

`timescale 1ns / 1ns

module program_counter (address, clk, reset);
output reg [3:0] address;
input wire clk, reset;
reg [3:0] offset; 


parameter tpd_reset_to_count = 0; // delay parameters are assumed to be zero until a design constraint is given
parameter tpd_clk_to_count   = 0; // delay parameters are assumed to be zero until a design constraint is given

/***************************************
function [31:0] increment;
input change;
//reg [15:0] offset;
  begin
    increment = address + change;
  end       
endfunction
***************************************/
initial // set initial address
  begin
    address = 4'b0000;
	offset = 4'b0001;
  end // end initial

always @ (posedge clk or posedge reset)
  if (reset)
     address = #tpd_reset_to_count 4'b0000;
  else
     address <= #tpd_clk_to_count address + offset;

endmodule