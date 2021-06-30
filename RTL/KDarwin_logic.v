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
// Description: Pipelined adder.  This is an adder with pipelines before and
//   after the adder datapath.  The output is fed into a FIFO and prog_full is
//   used to signal ready.  This design allows for high Fmax.

// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1ps / 1ps

module KDarwin_logic #(
  parameter integer C_AXIS_TDATA_WIDTH = 512, // Data width of both input and output data
  parameter integer C_ADDER_BIT_WIDTH  = 256,
  parameter integer C_NUM_CLOCKS       = 1,
  
  //Darwin Parameters
    parameter PE_WIDTH = 10,
    parameter BLOCK_WIDTH = 3,
    parameter MAX_TILE_SIZE = 512,
    parameter NUM_PE = 4,
    parameter REF_FILENAME = "",
    parameter QUERY_FILENAME = "",
    parameter NUM_DIR_BLOCK = 32,
    parameter DIR_BRAM_ADDR_WIDTH = 5,
    parameter REQUEST_ID_WIDTH   = 16
)
(

  input wire  [C_ADDER_BIT_WIDTH-1:0]   ctrl_constant,

  input wire                             s_axis_aclk,
  input wire                             s_axis_areset,
  
  input wire                             s_axis_tvalid0,
  output wire                            s_axis_tready0,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata0,
  
    input wire                             s_axis_tvalid1,
  output wire                            s_axis_tready1,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata1,
  
    input wire                             s_axis_tvalid2,
  output wire                            s_axis_tready2,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata2,
  
    input wire                             s_axis_tvalid3,
  output wire                            s_axis_tready3,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata3,
  
    input wire                             s_axis_tvalid4,
  output wire                            s_axis_tready4,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata4,
  
    input wire                             s_axis_tvalid5,
  output wire                            s_axis_tready5,
  input wire  [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata5,
  
  input wire  [C_AXIS_TDATA_WIDTH/8-1:0] s_axis_tkeep,
  
  input wire                             s_axis_tlast0,
  input wire                             s_axis_tlast1,
  input wire                             s_axis_tlast2,
  input wire                             s_axis_tlast3,
  input wire                             s_axis_tlast4,
  input wire                             s_axis_tlast5,

  input wire                             m_axis_aclk,
  
  output wire                            m_axis_tvalid0,
  input  wire                            m_axis_tready0,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata0,
  
    output wire                            m_axis_tvalid1,
  input  wire                            m_axis_tready1,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata1,
  
    output wire                            m_axis_tvalid2,
  input  wire                            m_axis_tready2,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata2,
  
    output wire                            m_axis_tvalid3,
  input  wire                            m_axis_tready3,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata3,
  
    output wire                            m_axis_tvalid4,
  input  wire                            m_axis_tready4,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata4,

  output wire                            m_axis_tvalid5,
  input  wire                            m_axis_tready5,
  output wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata5,
  
  output wire [C_AXIS_TDATA_WIDTH/8-1:0] m_axis_tkeep,
  output wire                            m_axis_tlast,
  
  //input  wire [32-1:0]                     in_params_lite      ,
  input  wire [32-1:0]                     set_params_lite     ,
  input  wire [32-1:0]                     ref_wr_en_lite      ,
  input  wire [32-1:0]                     query_wr_en_lite    ,
  input  wire [32-1:0]                     max_tb_steps_lite   ,
  input  wire [32-1:0]                     ref_len_lite        ,
  input  wire [32-1:0]                     query_len_lite      ,
  input  wire [32-1:0]                     score_threshold_lite,
  input  wire [32-1:0]                     align_fields_lite   ,
  input  wire [32-1:0]                     start_lite          ,
  input  wire [32-1:0]                     clear_done_lite     ,
  input  wire [32-1:0]                     req_id_in_lite      

);

localparam integer LP_NUM_LOOPS = C_AXIS_TDATA_WIDTH/C_ADDER_BIT_WIDTH;
localparam         LP_CLOCKING_MODE = C_NUM_CLOCKS == 1 ? "common_clock" : "independent_clock";
/////////////////////////////////////////////////////////////////////////////
// Variables
/////////////////////////////////////////////////////////////////////////////
reg                              d1_tvalid0 = 1'b0;
reg                              d1_tready0 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata0;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep0;
reg                              d1_tlast0;

reg                              d1_tvalid1 = 1'b0;
reg                              d1_tready1 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata1;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep1;
reg                              d1_tlast1;

reg                              d1_tvalid2 = 1'b0;
reg                              d1_tready2 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata2;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep2;
reg                              d1_tlast2;

reg                              d1_tvalid3 = 1'b0;
reg                              d1_tready3 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata3;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep3;
reg                              d1_tlast3;

reg                              d1_tvalid4 = 1'b0;
reg                              d1_tready4 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata4;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep4;
reg                              d1_tlast4;

reg                              d1_tvalid5 = 1'b0;
reg                              d1_tready5 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d1_tdata5;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d1_tkeep5;
reg                              d1_tlast5;

reg   [C_ADDER_BIT_WIDTH-1:0]    d1_constant;

//integer i;

reg                              d2_tvalid0 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata0;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep0;
reg                              d2_tlast0;

reg                              d2_tvalid1 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata1;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep1;
reg                              d2_tlast1;

reg                              d2_tvalid2 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata2;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep2;
reg                              d2_tlast2;

reg                              d2_tvalid3 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata3;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep3;
reg                              d2_tlast3;

reg                              d2_tvalid4 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata4;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep4;
reg                              d2_tlast4;

reg                              d2_tvalid5 = 1'b0;
reg   [C_AXIS_TDATA_WIDTH-1:0]   d2_tdata5;
reg   [C_AXIS_TDATA_WIDTH/8-1:0] d2_tkeep5;
reg                              d2_tlast5;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb0;
wire  [0:0]                      d2_tid0;
wire  [0:0]                      d2_tdest0;
wire  [0:0]                      d2_tuser0;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb1;
wire  [0:0]                      d2_tid1;
wire  [0:0]                      d2_tdest1;
wire  [0:0]                      d2_tuser1;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb2;
wire  [0:0]                      d2_tid2;
wire  [0:0]                      d2_tdest2;
wire  [0:0]                      d2_tuser2;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb3;
wire  [0:0]                      d2_tid3;
wire  [0:0]                      d2_tdest3;
wire  [0:0]                      d2_tuser3;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb4;
wire  [0:0]                      d2_tid4;
wire  [0:0]                      d2_tdest4;
wire  [0:0]                      d2_tuser4;

wire  [C_AXIS_TDATA_WIDTH/8-1:0] d2_tstrb5;
wire  [0:0]                      d2_tid5;
wire  [0:0]                      d2_tdest5;
wire  [0:0]                      d2_tuser5;

wire                             prog_full_axis0;
reg                              fifo_ready_r0 = 1'b0;

wire                             prog_full_axis1;
reg                              fifo_ready_r1 = 1'b0;

wire                             prog_full_axis2;
reg                              fifo_ready_r2 = 1'b0;

wire                             prog_full_axis3;
reg                              fifo_ready_r3 = 1'b0;

wire                             prog_full_axis4;
reg                              fifo_ready_r4 = 1'b0;

wire                             prog_full_axis5;
reg                              fifo_ready_r5 = 1'b0;
/////////////////////////////////////////////////////////////////////////////
// RTL Logic
/////////////////////////////////////////////////////////////////////////////

// Register s_axis_interface/inputs
always @(posedge s_axis_aclk) begin
  d1_tvalid0 <= s_axis_tvalid0;
  d1_tready0 <= s_axis_tready0;
  d1_tdata0  <= s_axis_tdata0;
  d1_tkeep0  <= s_axis_tkeep;
  d1_tlast0  <= s_axis_tlast0;
  
    d1_tvalid1 <= s_axis_tvalid1;
  d1_tready1 <= s_axis_tready1;
  d1_tdata1  <= s_axis_tdata1;
  d1_tkeep1  <= s_axis_tkeep;
  d1_tlast1  <= s_axis_tlast1;
  
    d1_tvalid2 <= s_axis_tvalid2;
  d1_tready2 <= s_axis_tready2;
  d1_tdata2  <= s_axis_tdata2;
  d1_tkeep2  <= s_axis_tkeep;
  d1_tlast2  <= s_axis_tlast2;
  
    d1_tvalid3 <= s_axis_tvalid3;
  d1_tready3 <= s_axis_tready3;
  d1_tdata3  <= s_axis_tdata3;
  d1_tkeep3  <= s_axis_tkeep;
  d1_tlast3  <= s_axis_tlast3;
  
    d1_tvalid4 <= s_axis_tvalid4;
  d1_tready4 <= s_axis_tready4;
  d1_tdata4  <= s_axis_tdata4;
  d1_tkeep4  <= s_axis_tkeep;
  d1_tlast4  <= s_axis_tlast4;
  
  d1_tvalid5 <= s_axis_tvalid5;
  d1_tready5 <= s_axis_tready5;
  d1_tdata5  <= s_axis_tdata5;
  d1_tkeep5  <= s_axis_tkeep;
  d1_tlast5  <= s_axis_tlast5;
  
  d1_constant <= ctrl_constant;
end
/////////////////////////////////////////////////////////
//DARWIN LOGIC//
/////////////////////////////////////////////////////////
//inputs:
wire [12*PE_WIDTH-1:0] in_params;
assign in_params = d1_tdata0[12*PE_WIDTH-1:0];
wire [8*(2 ** BLOCK_WIDTH)-1:0] query_in;
assign query_in = d1_tdata1[8*(2 ** BLOCK_WIDTH)-1:0];
wire [8*(2 ** BLOCK_WIDTH)-1:0] ref_in;
assign ref_in = d1_tdata2[8*(2 ** BLOCK_WIDTH)-1:0];
wire [$clog2(MAX_TILE_SIZE)-BLOCK_WIDTH-1:0] ref_addr_in;
assign ref_addr_in = d1_tdata3[8*(2 ** BLOCK_WIDTH)-1:0];
wire [$clog2(MAX_TILE_SIZE)-BLOCK_WIDTH-1:0] query_addr_in;
assign query_addr_in = d1_tdata4[8*(2 ** BLOCK_WIDTH)-1:0];
wire [DIR_BRAM_ADDR_WIDTH-1:0] dir_rd_addr;
assign dir_rd_addr = d1_tdata5[8*(2 ** BLOCK_WIDTH)-1:0];
//assign dir_rd_addr = 0;

//outputs:
wire ready;
wire done;
reg [PE_WIDTH-1:0] tile_score;
initial tile_score = 0;
reg [$clog2(MAX_TILE_SIZE)-1:0] ref_max_pos;
reg [$clog2(MAX_TILE_SIZE)-1:0] query_max_pos;
reg [2*$clog2(MAX_TILE_SIZE)-1:0] num_tb_steps;
//initial ref_max_pos = 0;
//initial query_max_pos = 0;
//initial num_tb_steps = 0;
reg [$clog2(MAX_TILE_SIZE)-1:0] num_ref_bases;
reg [$clog2(MAX_TILE_SIZE)-1:0] num_query_bases;
//initial num_ref_bases = 0;
//initial num_query_bases = 0;
reg [DIR_BRAM_ADDR_WIDTH-1:0] dir_total_count;
wire [2*NUM_DIR_BLOCK-1:0] dir_data_out;
reg [2*NUM_DIR_BLOCK-1:0] dir_data_out_aux;
initial dir_data_out_aux = 0;
wire dir_valid;
wire [1:0] dir;
reg [REQUEST_ID_WIDTH-1:0] req_id_out;
//

//reg [9:0] params [0:11];
//reg [12*PE_WIDTH-1:0] in_params;
//  initial begin
//   params[11] = 1;
//      params[10] = -1;
//      params[9] = -1;
//      params[8] = -1;

//      params[7] = 1;
//      params[6] = -1;
//      params[5] = -1;

//      params[4] = 1;
//      params[3] = -1;

//      params[2] = 1;

//      params[1] = -1;
//      params[0] = -1;
//      in_params = {params[11], params[10], params[9], params[8], params[7], params[6], params[5], params[4], params[3], params[2], params[1], params[0]}; 
//      end


wire                      set_params;
wire                      ref_wr_en;    
wire                      query_wr_en;     
wire [$clog2(MAX_TILE_SIZE):0]                     max_tb_steps;   
wire [$clog2(MAX_TILE_SIZE)-1:0]                     ref_len;        
wire [$clog2(MAX_TILE_SIZE)-1:0]                     query_len;      
wire [PE_WIDTH-1:0]                     score_threshold;
wire [7:0]                     align_fields;   
wire                      start;          
wire                      clear_done;     
wire [REQUEST_ID_WIDTH-1:0]                     req_id_in;      

//assign set_params = 1;
//assign score_threshold = 0;
//assign clear_done = 1;
////assign query_len = 320;
////assign ref_len = 320;
//assign query_len = 20;
//assign ref_len = 20;
//assign ref_wr_en = 0;
//assign query_wr_en = 0;
//assign max_tb_steps = 400;
//assign align_fields = (1<<5);
//assign start = 1;

assign set_params = set_params_lite[0];
assign ref_wr_en = ref_wr_en_lite[0];
assign query_wr_en = query_wr_en_lite[0];
assign max_tb_steps = max_tb_steps_lite[$clog2(MAX_TILE_SIZE):0];
assign ref_len = ref_len_lite[$clog2(MAX_TILE_SIZE)-1:0];
assign query_len = query_len_lite[$clog2(MAX_TILE_SIZE)-1:0];
assign score_threshold = score_threshold_lite[PE_WIDTH-1:0];
assign align_fields = align_fields_lite[7:0];
assign start = start_lite[0];
assign clear_done = clear_done_lite[0];
assign req_id_in = req_id_in_lite[REQUEST_ID_WIDTH-1:0];

//Logic
 parameter LOG_NUM_PE = $clog2(NUM_PE);
  parameter NUM_BLOCK = (2 ** BLOCK_WIDTH);
  
  wire [$clog2(MAX_TILE_SIZE)-BLOCK_WIDTH-1:0] ref_bram_addr;
  wire [$clog2(MAX_TILE_SIZE)-BLOCK_WIDTH-1:0] query_bram_addr;
  
  wire [$clog2(MAX_TILE_SIZE)-1:0] ref_bram_rd_addr;
  wire [$clog2(MAX_TILE_SIZE)-1:0] query_bram_rd_addr;
  
  reg [$clog2(MAX_TILE_SIZE)-1:0] reg_ref_bram_rd_addr;
  reg [$clog2(MAX_TILE_SIZE)-1:0] reg_query_bram_rd_addr;

  reg [$clog2(MAX_TILE_SIZE)-1:0] ref_length;
  reg [$clog2(MAX_TILE_SIZE)-1:0] query_length;

  wire [8*NUM_BLOCK-1:0] ref_bram_data_out;
  wire [8*NUM_BLOCK-1:0] query_bram_data_out;

  reg [PE_WIDTH-1:0] max_score_threshold;
  reg [$clog2(MAX_TILE_SIZE)-1:0] max_H_offset;
  reg [$clog2(MAX_TILE_SIZE)-1:0] max_V_offset;

  wire [$clog2(MAX_TILE_SIZE)-1:0] ref_max_score_pos;
  wire [$clog2(MAX_TILE_SIZE)-1:0] query_max_score_pos;

  wire [PE_WIDTH-1:0] max_score;
  wire [$clog2(MAX_TILE_SIZE)-1:0] H_offset;
  wire [$clog2(MAX_TILE_SIZE)-1:0] V_offset;

  wire [2*$clog2(MAX_TILE_SIZE)-1:0] array_num_tb_steps;

  reg [12*PE_WIDTH-1:0] reg_in_params;

  reg [DIR_BRAM_ADDR_WIDTH-1:0] dir_count;
  reg dir_wr_en;
  reg [2*NUM_DIR_BLOCK-1:0] dir_data_in;
  wire [DIR_BRAM_ADDR_WIDTH-1:0] dir_wr_addr;

  wire array_done;
  reg rst_array;
  wire array_start;

  reg [2:0] state;
  reg [2:0] next_state;

  localparam READY=1, ARRAY_START=2, ARRAY_PROCESSING=3, BLOCK=4, DONE=5; 
  
//  assign dir_valid_axi = {511'b0, dir_valid};
//  assign dir_axi = {510'b0, dir};
//  assign dir_data_out_axi = {448'b0, dir_data_out};
  
  assign ref_bram_addr = (ref_wr_en) ? ref_addr_in - 1 : ref_bram_rd_addr[$clog2(MAX_TILE_SIZE)-1:BLOCK_WIDTH];
  assign query_bram_addr = (query_wr_en) ? query_addr_in - 1 : query_bram_rd_addr[$clog2(MAX_TILE_SIZE)-1:BLOCK_WIDTH];

  BRAM_QR #(
      .ADDR_WIDTH($clog2(MAX_TILE_SIZE)-BLOCK_WIDTH),
      .DATA_WIDTH(8*NUM_BLOCK),
      .MEM_INIT_FILE(REF_FILENAME)
  ) ref_bram (
      .clk(s_axis_aclk),
      .addr(ref_bram_addr),
      .write_en(ref_wr_en),
      .data_in(ref_in),
      .data_out(ref_bram_data_out)
  );

  BRAM_QR #(
      .ADDR_WIDTH($clog2(MAX_TILE_SIZE)-BLOCK_WIDTH),
      .DATA_WIDTH(8*NUM_BLOCK),
      .MEM_INIT_FILE(QUERY_FILENAME)
  ) query_bram (
      .clk(s_axis_aclk),
      .addr(query_bram_addr),
      .write_en(query_wr_en),
      .data_in(query_in),
      .data_out(query_bram_data_out)
  );

  DP_BRAM #(
      .DATA_WIDTH(2*NUM_DIR_BLOCK),
      .ADDR_WIDTH(DIR_BRAM_ADDR_WIDTH)
  ) dir_bram (
      .clk(s_axis_aclk),

      .raddr (dir_rd_addr),
      .wr_en (dir_wr_en),
      .waddr (dir_wr_addr),

      .data_in (dir_data_in),
      .data_out (dir_data_out)
  );
  
  reg [7:0] ref_array_in;
  reg [7:0] query_array_in;

  reg do_traceback_in;
  reg ref_complement;
  reg query_complement;
  reg ref_reverse;
  reg query_reverse;
  reg start_last;

 integer i, j;
  always @(*) begin
      ref_array_in = 0;
      for (i = 0; i < NUM_BLOCK; i=i+1) 
      begin:m
          if (reg_ref_bram_rd_addr[BLOCK_WIDTH-1:0] == i) begin
              ref_array_in = ref_bram_data_out[8*i+:8];
          end
      end
  end
  
  always @(*) begin
      query_array_in = 0;
      for (j = 0; j < NUM_BLOCK; j=j+1) 
      begin:n
          if (reg_query_bram_rd_addr[BLOCK_WIDTH-1:0] == j) begin
              query_array_in = (query_bram_rd_addr <= query_length) ? query_bram_data_out[8*j+:8] : 0;
          end
      end
  end
  

  always@(posedge s_axis_aclk) begin
      reg_ref_bram_rd_addr <= ref_bram_rd_addr;
      reg_query_bram_rd_addr <= query_bram_rd_addr;
  end
 
  SmithWatermanArray # (
      .NUM_PE(NUM_PE),
      .LOG_NUM_PE(LOG_NUM_PE),
      .REF_LEN_WIDTH($clog2(MAX_TILE_SIZE)),
      .QUERY_LEN_WIDTH($clog2(MAX_TILE_SIZE)),
      .REF_BLOCK_SIZE_WIDTH($clog2(MAX_TILE_SIZE)),
      .QUERY_BLOCK_SIZE_WIDTH($clog2(MAX_TILE_SIZE)),
      .PE_WIDTH(PE_WIDTH),
      .PARAM_ADDR_WIDTH($clog2(MAX_TILE_SIZE))
  ) array (
      .clk (s_axis_aclk),
      .rst (rst_array),
      .start (array_start),

      .reverse_ref_in(ref_reverse),
      .reverse_query_in(query_reverse),

      .complement_ref_in(ref_complement),
      .complement_query_in(query_complement),

      .in_param(reg_in_params),

      .do_traceback_in (do_traceback_in),
      .ref_length (ref_length),
      .query_length (query_length),

      .ref_bram_rd_start_addr(0),
      .ref_bram_rd_addr(ref_bram_rd_addr),
      .ref_bram_data_in (ref_array_in),

      .query_bram_rd_start_addr(0),
      .query_bram_rd_addr(query_bram_rd_addr),
      .query_bram_data_in (query_array_in),

      .max_score_threshold(max_score_threshold),
      .start_last(start_last),

      .max_score(max_score),
      .H_offset(H_offset),
      .max_H_offset(max_H_offset),
      .V_offset(V_offset),
      .max_V_offset(max_V_offset),

      .num_tb_steps(array_num_tb_steps),

      .ref_max_score_pos(ref_max_score_pos),
      .query_max_score_pos(query_max_score_pos),

      .dir(dir),
      .dir_valid(dir_valid),

      .done(array_done)
  );


  assign done = (state == DONE);
  assign ready = (state == READY) && (~start);
  assign array_start = (state == ARRAY_START);
  assign dir_wr_addr = (dir_total_count - 1);

  always @(posedge s_axis_aclk) begin
      if (s_axis_areset) begin
          dir_wr_en <= 0;
          rst_array <= 1;
          state <= READY;
      end
      else begin
          state <= next_state;
          if (state == READY) begin
              if (set_params) begin
                  rst_array <= 0;
                  reg_in_params <= in_params;
              end
              if (start) begin
                  do_traceback_in <= align_fields[5];
                  ref_reverse <= align_fields[4];
                  ref_complement <= align_fields[3];
                  query_reverse <= align_fields[2];
                  query_complement <= align_fields[1];
                  start_last <= align_fields[0];
                  max_H_offset <= max_tb_steps;
                  max_V_offset <= max_tb_steps;
                  max_score_threshold <= score_threshold;
                  ref_length <= ref_len;
                  query_length <= query_len;
                  //query_length <= 320;
                  req_id_out <= req_id_in;
                  dir_total_count <= 0;
                  dir_count <= 0;
                  dir_wr_en <= 0;
              end
          end
          if (state == ARRAY_PROCESSING) begin
              if (dir_valid) begin
                  // TODO
                  if (dir_valid) begin
                      if (dir_count == 0) begin
                          dir_data_in <= dir; 
                      end
                      else begin
                          dir_data_in <= (dir_data_in << 2) + dir;
                      end
                      if (dir_count == NUM_DIR_BLOCK-1) begin
                          dir_wr_en <= 1;
                          dir_total_count <= dir_total_count + 1;
                          dir_count <= dir_count + 1;
                          dir_count <= 0;
                      end
                      else begin
                          dir_wr_en <= 0;
                          dir_count <= dir_count + 1;
                      end
                  end
              end
              else if (array_done) begin
                  ref_max_pos <= ref_max_score_pos;
                  query_max_pos <= query_max_score_pos;
                  num_ref_bases <= H_offset;
                  num_query_bases <= V_offset;
                  num_tb_steps <= array_num_tb_steps;
                  tile_score <= max_score;
                  rst_array <= 1;
                  if (dir_count > 0) begin
                      dir_wr_en <= 1;
                      dir_total_count <= dir_total_count + 1;
                      dir_count <= dir_count + 1;
                  end
                  else begin
                      dir_wr_en <= 0;
                  end
              end
              else begin
                  dir_wr_en <= 0;
                  
//                  tile_score <= 0;
//                  ref_max_pos <= 0;
//                  query_max_pos <= 0;
//                  num_ref_bases <= 0;
//                  num_query_bases <= 0;
//                  num_tb_steps <= 0;
              end
          end
          if (state == BLOCK) begin
              dir_wr_en <= 0;
          end
          if (state == DONE) begin
              rst_array <= 0;
              dir_wr_en <= 0;
          end
      end
  end

  always @(*) 
  begin
      next_state = state;
      case (state)
          READY: begin
              if (start) begin
                  next_state = ARRAY_START;
              end
          end
          ARRAY_START: begin
              next_state = ARRAY_PROCESSING;
          end
          ARRAY_PROCESSING: begin
              if (array_done) begin
                  next_state = BLOCK;
              end
          end
          BLOCK: begin
              next_state = DONE;
          end
          DONE: begin
              if (clear_done) begin
                  next_state = READY;
              end
          end
      endcase
  end
/////////////////////////////////////////////////////////
// Adder function
integer k;
//integer q;
always @(posedge s_axis_aclk) begin
  for (k = 0; k < LP_NUM_LOOPS; k = k + 1) begin
  
    d2_tdata0[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= tile_score;
    d2_tdata0[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= {ready, done};
    //d2_tdata0[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= done;
    //d2_tdata0[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= num_tb_steps;
    
    d2_tdata1[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= num_tb_steps;
    d2_tdata1[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= ref_max_pos;
    //d2_tdata1[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= num_tb_steps;
    //d2_tdata1[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= {num_ref_bases, num_query_bases};
    
    dir_data_out_aux <= dir_data_out;
//    if (dir_wr_en == 0) 
//    dir_data_out_aux <= 0;
//    else
//    dir_data_out_aux <= dir_data_out;
    
//    d2_tdata2[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_data_out[31:0];
//    d2_tdata2[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_data_out[63:32];
    d2_tdata2[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= query_max_pos;
    d2_tdata2[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= num_ref_bases;
    //d2_tdata2[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
    
    d2_tdata3[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= num_query_bases;
    d2_tdata3[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_data_out;
    //d2_tdata3[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_total_count;
    
    d2_tdata4[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_total_count;
    d2_tdata4[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= req_id_out;
    //d2_tdata4[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir;
    
    d2_tdata5[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir_valid;
    d2_tdata5[1*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= dir;
    //d2_tdata5[2*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
    //d2_tdata0[i*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= d1_tdata0[C_ADDER_BIT_WIDTH*i+:C_ADDER_BIT_WIDTH] + d1_constant;
    //d2_tdata1[0*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'h12341234;
    //d2_tdata1[i*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= d1_tdata1[C_ADDER_BIT_WIDTH*i+:C_ADDER_BIT_WIDTH] + d1_constant;
    //d2_tdata2[k*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= d1_tdata2[C_ADDER_BIT_WIDTH*k+:C_ADDER_BIT_WIDTH] + d1_constant;
    //d2_tdata3[k*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= d1_tdata3[C_ADDER_BIT_WIDTH*k+:C_ADDER_BIT_WIDTH] + d1_constant;
    //d2_tdata4[k*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= d1_tdata4[C_ADDER_BIT_WIDTH*k+:C_ADDER_BIT_WIDTH] + d1_constant;
    
      
  end
//  for (q = 3; q < LP_NUM_LOOPS; q = q + 1) begin
//    d2_tdata0[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//    d2_tdata1[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//    d2_tdata2[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//    d2_tdata3[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//    d2_tdata4[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//    d2_tdata5[q*C_ADDER_BIT_WIDTH+:C_ADDER_BIT_WIDTH] <= 32'd0;
//  end
end

// Register inputs to fifo
always @(posedge s_axis_aclk) begin
  d2_tvalid0 <= d1_tvalid0 & d1_tready0;
  d2_tkeep0  <= d1_tkeep0;
  d2_tlast0  <= d1_tlast0;
  
    d2_tvalid1 <= d1_tvalid1 & d1_tready1;
  d2_tkeep1  <= d1_tkeep1;
  d2_tlast1  <= d1_tlast1;
  
    d2_tvalid2 <= d1_tvalid2 & d1_tready2;
  d2_tkeep2  <= d1_tkeep2;
  d2_tlast2  <= d1_tlast2;
  
    d2_tvalid3 <= d1_tvalid3 & d1_tready3;
  d2_tkeep3  <= d1_tkeep3;
  d2_tlast3  <= d1_tlast3;
  
    d2_tvalid4 <= d1_tvalid4 & d1_tready4;
  d2_tkeep4  <= d1_tkeep4;
  d2_tlast4  <= d1_tlast4;
  
  d2_tvalid5 <= d1_tvalid5 & d1_tready5;
  d2_tkeep5  <= d1_tkeep5;
  d2_tlast5  <= d1_tlast5;
end

// Tie-off unused inputs to FIFO.
assign d2_tstrb0 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid0   = 1'b0;
assign d2_tdest0 = 1'b0;
assign d2_tuser0 = 1'b0;

assign d2_tstrb1 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid1   = 1'b0;
assign d2_tdest1 = 1'b0;
assign d2_tuser1 = 1'b0;

assign d2_tstrb2 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid2   = 1'b0;
assign d2_tdest2 = 1'b0;
assign d2_tuser2 = 1'b0;

assign d2_tstrb3 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid3   = 1'b0;
assign d2_tdest3 = 1'b0;
assign d2_tuser3 = 1'b0;

assign d2_tstrb4 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid4   = 1'b0;
assign d2_tdest4 = 1'b0;
assign d2_tuser4 = 1'b0;

assign d2_tstrb5 = {C_AXIS_TDATA_WIDTH/8{1'b1}};
assign d2_tid5   = 1'b0;
assign d2_tdest5 = 1'b0;
assign d2_tuser5 = 1'b0;

always @(posedge s_axis_aclk) begin
  fifo_ready_r0 <= ~prog_full_axis0;
  fifo_ready_r1 <= ~prog_full_axis1;
  fifo_ready_r2 <= ~prog_full_axis2;
  fifo_ready_r3 <= ~prog_full_axis3;
  fifo_ready_r4 <= ~prog_full_axis4;
  fifo_ready_r5 <= ~prog_full_axis5;
end

assign s_axis_tready0 = fifo_ready_r0;
assign s_axis_tready1 = fifo_ready_r1;
assign s_axis_tready2 = fifo_ready_r2;
assign s_axis_tready3 = fifo_ready_r3;
assign s_axis_tready4 = fifo_ready_r4;
assign s_axis_tready5 = fifo_ready_r5;

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis0 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid0      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata0       ) ,
   .s_axis_tstrb       ( d2_tstrb0       ) ,
   .s_axis_tkeep       ( d2_tkeep0       ) ,
   .s_axis_tlast       ( d2_tlast0       ) ,
   .s_axis_tid         ( d2_tid0         ) ,
   .s_axis_tdest       ( d2_tdest0       ) ,
   .s_axis_tuser       ( d2_tuser0       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis0 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid0 ) ,
   .m_axis_tready      ( m_axis_tready0 ) ,
   .m_axis_tdata       ( m_axis_tdata0  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis1 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid1      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata1       ) ,
   .s_axis_tstrb       ( d2_tstrb1       ) ,
   .s_axis_tkeep       ( d2_tkeep1       ) ,
   .s_axis_tlast       ( d2_tlast1       ) ,
   .s_axis_tid         ( d2_tid1         ) ,
   .s_axis_tdest       ( d2_tdest1       ) ,
   .s_axis_tuser       ( d2_tuser1       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis1 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid1 ) ,
   .m_axis_tready      ( m_axis_tready1 ) ,
   .m_axis_tdata       ( m_axis_tdata1  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis2 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid2      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata2       ) ,
   .s_axis_tstrb       ( d2_tstrb2       ) ,
   .s_axis_tkeep       ( d2_tkeep2       ) ,
   .s_axis_tlast       ( d2_tlast2       ) ,
   .s_axis_tid         ( d2_tid2         ) ,
   .s_axis_tdest       ( d2_tdest2       ) ,
   .s_axis_tuser       ( d2_tuser2       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis2 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid2 ) ,
   .m_axis_tready      ( m_axis_tready2 ) ,
   .m_axis_tdata       ( m_axis_tdata2  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis3 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid3      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata3       ) ,
   .s_axis_tstrb       ( d2_tstrb3       ) ,
   .s_axis_tkeep       ( d2_tkeep3       ) ,
   .s_axis_tlast       ( d2_tlast3       ) ,
   .s_axis_tid         ( d2_tid3         ) ,
   .s_axis_tdest       ( d2_tdest3       ) ,
   .s_axis_tuser       ( d2_tuser3       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis3 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid3 ) ,
   .m_axis_tready      ( m_axis_tready3 ) ,
   .m_axis_tdata       ( m_axis_tdata3  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis4 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid4      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata4       ) ,
   .s_axis_tstrb       ( d2_tstrb4       ) ,
   .s_axis_tkeep       ( d2_tkeep4       ) ,
   .s_axis_tlast       ( d2_tlast4       ) ,
   .s_axis_tid         ( d2_tid4         ) ,
   .s_axis_tdest       ( d2_tdest4       ) ,
   .s_axis_tuser       ( d2_tuser4       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis4 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid4 ) ,
   .m_axis_tready      ( m_axis_tready4 ) ,
   .m_axis_tdata       ( m_axis_tdata4  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);

xpm_fifo_axis #(
   .CDC_SYNC_STAGES     ( 2                      ) , // DECIMAL
   .CLOCKING_MODE       ( LP_CLOCKING_MODE       ) , // String
   .ECC_MODE            ( "no_ecc"               ) , // String
   .FIFO_DEPTH          ( 32                     ) , // DECIMAL
   .FIFO_MEMORY_TYPE    ( "distributed"          ) , // String
   .PACKET_FIFO         ( "false"                ) , // String
   .PROG_EMPTY_THRESH   ( 5                      ) , // DECIMAL
   .PROG_FULL_THRESH    ( 32-5                   ) , // DECIMAL
   .RD_DATA_COUNT_WIDTH ( 6                      ) , // DECIMAL
   .RELATED_CLOCKS      ( 0                      ) , // DECIMAL
   .TDATA_WIDTH         ( C_AXIS_TDATA_WIDTH     ) , // DECIMAL
   .TDEST_WIDTH         ( 1                      ) , // DECIMAL
   .TID_WIDTH           ( 1                      ) , // DECIMAL
   .TUSER_WIDTH         ( 1                      ) , // DECIMAL
   .USE_ADV_FEATURES    ( "1002"                 ) , // String: Only use prog_full
   .WR_DATA_COUNT_WIDTH ( 6                      )   // DECIMAL
)
inst_xpm_fifo_axis5 (
   .s_aclk             ( s_axis_aclk    ) ,
   .s_aresetn          ( ~s_axis_areset ) ,
   .s_axis_tvalid      ( d2_tvalid5      ) ,
   .s_axis_tready      (                ) ,
   .s_axis_tdata       ( d2_tdata5       ) ,
   .s_axis_tstrb       ( d2_tstrb5       ) ,
   .s_axis_tkeep       ( d2_tkeep5       ) ,
   .s_axis_tlast       ( d2_tlast5       ) ,
   .s_axis_tid         ( d2_tid5         ) ,
   .s_axis_tdest       ( d2_tdest5       ) ,
   .s_axis_tuser       ( d2_tuser5       ) ,
   .almost_full_axis   (                ) ,
   .prog_full_axis     ( prog_full_axis5 ) ,
   .wr_data_count_axis (                ) ,
   .injectdbiterr_axis ( 1'b0           ) ,
   .injectsbiterr_axis ( 1'b0           ) ,

   .m_aclk             ( m_axis_aclk   ) ,
   .m_axis_tvalid      ( m_axis_tvalid5 ) ,
   .m_axis_tready      ( m_axis_tready5 ) ,
   .m_axis_tdata       ( m_axis_tdata5  ) ,
   .m_axis_tstrb       (               ) ,
   .m_axis_tkeep       ( m_axis_tkeep  ) ,
   .m_axis_tlast       ( m_axis_tlast  ) ,
   .m_axis_tid         (               ) ,
   .m_axis_tdest       (               ) ,
   .m_axis_tuser       (               ) ,
   .almost_empty_axis  (               ) ,
   .prog_empty_axis    (               ) ,
   .rd_data_count_axis (               ) ,
   .sbiterr_axis       (               ) ,
   .dbiterr_axis       (               )
);


endmodule

`default_nettype wire
