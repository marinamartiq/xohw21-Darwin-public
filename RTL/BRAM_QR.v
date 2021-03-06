/*
*MIT License
*
# *Copyright (c) [2020] [Marina Marti, Alberto Zeni, Marco Domenico Santambrogio]
*
*Permission is hereby granted, free of charge, to any person obtaining a copy
*of this software and associated documentation files (the "Software"), to deal
*in the Software without restriction, including without limitation the rights
*to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*copies of the Software, and to permit persons to whom the Software is
*furnished to do so, subject to the following conditions:
*
*The above copyright notice and this permission notice shall be included in all
*copies or substantial portions of the Software.
*
*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*SOFTWARE.
******************************************/
*/

module BRAM_QR #(
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 8,
  parameter MEM_INIT_FILE = ""
)
(
  input clk,
  input [ADDR_WIDTH-1:0] addr,
  input write_en,
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out);

  reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

  integer i;

  initial begin
      for ( i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
          mem[i] <= 0;
      end

  end


  always @(posedge clk) begin
      if (write_en == 1)
          mem[addr] <= data_in;
      data_out <= mem[addr];
  end

endmodule