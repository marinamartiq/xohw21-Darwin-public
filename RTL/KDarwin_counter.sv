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

// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module KDarwin_counter #(
  parameter integer C_WIDTH  = 4,
  parameter [C_WIDTH-1:0] C_INIT = {C_WIDTH{1'b0}}
)
(
  input  wire               clk,
  input  wire               clken,
  input  wire               rst,
  input  wire               load,
  input  wire               incr,
  input  wire               decr,
  input  wire [C_WIDTH-1:0] load_value,
  output wire [C_WIDTH-1:0] count,
  output wire               is_zero
);

timeunit 1ps;
timeprecision 1ps;

/////////////////////////////////////////////////////////////////////////////
// Local Parameters
/////////////////////////////////////////////////////////////////////////////
localparam [C_WIDTH-1:0] LP_ZERO = {C_WIDTH{1'b0}};
localparam [C_WIDTH-1:0] LP_ONE = {{C_WIDTH-1{1'b0}},1'b1};
localparam [C_WIDTH-1:0] LP_MAX = {C_WIDTH{1'b1}};

/////////////////////////////////////////////////////////////////////////////
// Variables
/////////////////////////////////////////////////////////////////////////////
reg [C_WIDTH-1:0] count_r = C_INIT;
reg   is_zero_r = (C_INIT == LP_ZERO);

/////////////////////////////////////////////////////////////////////////////
// Begin RTL
/////////////////////////////////////////////////////////////////////////////
assign count = count_r;

always @(posedge clk) begin
  if (rst) begin
    count_r <= C_INIT;
  end
  else if (clken) begin
    if (load) begin
      count_r <= load_value;
    end
    else if (incr & ~decr) begin
      count_r <= count_r + 1'b1;
    end
    else if (~incr & decr) begin
      count_r <= count_r - 1'b1;
    end
    else
      count_r <= count_r;
  end
end

assign is_zero = is_zero_r;

always @(posedge clk) begin
  if (rst) begin
    is_zero_r <= (C_INIT == LP_ZERO);
  end
  else if (clken) begin
    if (load) begin
      is_zero_r <= (load_value == LP_ZERO);
    end
    else begin
      is_zero_r <= incr ^ decr ? (decr && (count_r == LP_ONE)) || (incr && (count_r == LP_MAX)) : is_zero_r;
    end
  end
  else begin
    is_zero_r <= is_zero_r;
  end
end


endmodule : KDarwin_counter
`default_nettype wire

