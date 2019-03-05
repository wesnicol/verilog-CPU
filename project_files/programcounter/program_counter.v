





// this module is intended to function as a program counter for a 32-bit system

// output: address      | represents the sum of offset and the address value stored in the register
// inputs: offset       | the size of the jump taken in memory
//         clk          | the clock signal of the entire system
//         reset        | address is reset to 0 when reset==1

`timescale 1ns / 1ns

module program_counter (address, offset, clk, reset);
output reg [31:0] address;
input wire clk, reset;
input wire [15:0] offset; //arbitrarily set to 16 bits until a different requirement is realized


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


always @ (posedge clk or posedge reset)
  if (reset)
     address = #tpd_reset_to_count 32'h00;
  else
     address <= #tpd_clk_to_count address + offset;

endmodule