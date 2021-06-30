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
module KDarwin_block #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 512,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH = 512,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M02_AXI_DATA_WIDTH = 512,
  parameter integer C_M03_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M03_AXI_DATA_WIDTH = 512,
  parameter integer C_M04_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M04_AXI_DATA_WIDTH = 512,
  parameter integer C_M05_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M05_AXI_DATA_WIDTH = 512
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // AXI4 master interface m01_axi
  output wire                              m01_axi_awvalid,
  input  wire                              m01_axi_awready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_awaddr ,
  output wire [8-1:0]                      m01_axi_awlen  ,
  output wire                              m01_axi_wvalid ,
  input  wire                              m01_axi_wready ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_wdata  ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb  ,
  output wire                              m01_axi_wlast  ,
  input  wire                              m01_axi_bvalid ,
  output wire                              m01_axi_bready ,
  output wire                              m01_axi_arvalid,
  input  wire                              m01_axi_arready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_araddr ,
  output wire [8-1:0]                      m01_axi_arlen  ,
  input  wire                              m01_axi_rvalid ,
  output wire                              m01_axi_rready ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_rdata  ,
  input  wire                              m01_axi_rlast  ,
  // AXI4 master interface m02_axi
  output wire                              m02_axi_awvalid,
  input  wire                              m02_axi_awready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_awaddr ,
  output wire [8-1:0]                      m02_axi_awlen  ,
  output wire                              m02_axi_wvalid ,
  input  wire                              m02_axi_wready ,
  output wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_wdata  ,
  output wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb  ,
  output wire                              m02_axi_wlast  ,
  input  wire                              m02_axi_bvalid ,
  output wire                              m02_axi_bready ,
  output wire                              m02_axi_arvalid,
  input  wire                              m02_axi_arready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_araddr ,
  output wire [8-1:0]                      m02_axi_arlen  ,
  input  wire                              m02_axi_rvalid ,
  output wire                              m02_axi_rready ,
  input  wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_rdata  ,
  input  wire                              m02_axi_rlast  ,
  // AXI4 master interface m03_axi
  output wire                              m03_axi_awvalid,
  input  wire                              m03_axi_awready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_awaddr ,
  output wire [8-1:0]                      m03_axi_awlen  ,
  output wire                              m03_axi_wvalid ,
  input  wire                              m03_axi_wready ,
  output wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_wdata  ,
  output wire [C_M03_AXI_DATA_WIDTH/8-1:0] m03_axi_wstrb  ,
  output wire                              m03_axi_wlast  ,
  input  wire                              m03_axi_bvalid ,
  output wire                              m03_axi_bready ,
  output wire                              m03_axi_arvalid,
  input  wire                              m03_axi_arready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_araddr ,
  output wire [8-1:0]                      m03_axi_arlen  ,
  input  wire                              m03_axi_rvalid ,
  output wire                              m03_axi_rready ,
  input  wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_rdata  ,
  input  wire                              m03_axi_rlast  ,
  // AXI4 master interface m04_axi
  output wire                              m04_axi_awvalid,
  input  wire                              m04_axi_awready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_awaddr ,
  output wire [8-1:0]                      m04_axi_awlen  ,
  output wire                              m04_axi_wvalid ,
  input  wire                              m04_axi_wready ,
  output wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_wdata  ,
  output wire [C_M04_AXI_DATA_WIDTH/8-1:0] m04_axi_wstrb  ,
  output wire                              m04_axi_wlast  ,
  input  wire                              m04_axi_bvalid ,
  output wire                              m04_axi_bready ,
  output wire                              m04_axi_arvalid,
  input  wire                              m04_axi_arready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_araddr ,
  output wire [8-1:0]                      m04_axi_arlen  ,
  input  wire                              m04_axi_rvalid ,
  output wire                              m04_axi_rready ,
  input  wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_rdata  ,
  input  wire                              m04_axi_rlast  ,
  // AXI4 master interface m05_axi
  output wire                              m05_axi_awvalid,
  input  wire                              m05_axi_awready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_awaddr ,
  output wire [8-1:0]                      m05_axi_awlen  ,
  output wire                              m05_axi_wvalid ,
  input  wire                              m05_axi_wready ,
  output wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_wdata  ,
  output wire [C_M05_AXI_DATA_WIDTH/8-1:0] m05_axi_wstrb  ,
  output wire                              m05_axi_wlast  ,
  input  wire                              m05_axi_bvalid ,
  output wire                              m05_axi_bready ,
  output wire                              m05_axi_arvalid,
  input  wire                              m05_axi_arready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_araddr ,
  output wire [8-1:0]                      m05_axi_arlen  ,
  input  wire                              m05_axi_rvalid ,
  output wire                              m05_axi_rready ,
  input  wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_rdata  ,
  input  wire                              m05_axi_rlast  ,
  // Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  output wire                              ap_ready       ,
  input  wire [32-1:0]                     set_params     ,
  input  wire [32-1:0]                     ref_wr_en      ,
  input  wire [32-1:0]                     query_wr_en    ,
  input  wire [32-1:0]                     max_tb_steps   ,
  input  wire [32-1:0]                     ref_len        ,
  input  wire [32-1:0]                     query_len      ,
  input  wire [32-1:0]                     score_threshold,
  input  wire [32-1:0]                     align_fields   ,
  input  wire [32-1:0]                     start          ,
  input  wire [32-1:0]                     clear_done     ,
  input  wire [32-1:0]                     req_id_in      ,
  input  wire [64-1:0]                     in_params      ,
  input  wire [64-1:0]                     query_in       ,
  input  wire [64-1:0]                     ref_in         ,
  input  wire [64-1:0]                     ref_addr_in    ,
  input  wire [64-1:0]                     query_addr_in  ,
  input  wire [64-1:0]                     dir_rd_addr    
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 6;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [32-1:0]                       ctrl_constant                  = 32'd1;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r;

// Ready Logic (non-pipelined case)
assign ap_ready = ap_done;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters VADD modification (0)
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_DW_BYTES             = C_M00_AXI_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN        = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN        = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_BRAM_DEPTH           = 512;
localparam integer LP_RD_MAX_OUTSTANDING   = LP_BRAM_DEPTH / LP_AXI_BURST_LEN;
localparam integer LP_WR_MAX_OUTSTANDING   = 32;

// Control logic
logic                          done0 = 1'b0;
logic                          done1 = 1'b0;
logic                          done2 = 1'b0;
logic                          done3 = 1'b0;
logic                          done4 = 1'b0;
logic                          done5 = 1'b0;
// AXI read master stage
logic                          read_done0;
logic                          rd_tvalid0;
logic                          rd_tready0;
logic                          rd_tlast0;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata0;

logic                          read_done1;
logic                          rd_tvalid1;
logic                          rd_tready1;
logic                          rd_tlast1;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata1;

logic                          read_done2;
logic                          rd_tvalid2;
logic                          rd_tready2;
logic                          rd_tlast2;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata2;

logic                          read_done3;
logic                          rd_tvalid3;
logic                          rd_tready3;
logic                          rd_tlast3;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata3;

logic                          read_done4;
logic                          rd_tvalid4;
logic                          rd_tready4;
logic                          rd_tlast4;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata4;

logic                          read_done5;
logic                          rd_tvalid5;
logic                          rd_tready5;
logic                          rd_tlast5;
logic [C_M00_AXI_DATA_WIDTH-1:0] rd_tdata5;

// Adder stage
logic                          adder_tvalid0;
logic                          adder_tready0;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata0;

logic                          adder_tvalid1;
logic                          adder_tready1;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata1;

logic                          adder_tvalid2;
logic                          adder_tready2;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata2;

logic                          adder_tvalid3;
logic                          adder_tready3;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata3;

logic                          adder_tvalid4;
logic                          adder_tready4;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata4;

logic                          adder_tvalid5;
logic                          adder_tready5;
logic [C_M00_AXI_DATA_WIDTH-1:0] adder_tdata5;

// AXI write master stage
logic                          write_done0;
logic                          write_done1;
logic                          write_done2;
logic                          write_done3;
logic                          write_done4;
logic                          write_done5;

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master00 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done0               ) ,
  .ctrl_addr_offset        ( in_params        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m00_axi_arvalid           ) ,
  .m_axi_arready           ( m00_axi_arready           ) ,
  .m_axi_araddr            ( m00_axi_araddr            ) ,
  .m_axi_arlen             ( m00_axi_arlen             ) ,
  .m_axi_rvalid            ( m00_axi_rvalid            ) ,
  .m_axi_rready            ( m00_axi_rready            ) ,
  .m_axi_rdata             ( m00_axi_rdata             ) ,
  .m_axi_rlast             ( m00_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid0               ) ,
  .m_axis_tready           ( rd_tready0               ) ,
  .m_axis_tlast            ( rd_tlast0                ) ,
  .m_axis_tdata            ( rd_tdata0                )
);

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master01 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done1               ) ,
  .ctrl_addr_offset        ( query_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m01_axi_arvalid           ) ,
  .m_axi_arready           ( m01_axi_arready           ) ,
  .m_axi_araddr            ( m01_axi_araddr            ) ,
  .m_axi_arlen             ( m01_axi_arlen             ) ,
  .m_axi_rvalid            ( m01_axi_rvalid            ) ,
  .m_axi_rready            ( m01_axi_rready            ) ,
  .m_axi_rdata             ( m01_axi_rdata             ) ,
  .m_axi_rlast             ( m01_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid1               ) ,
  .m_axis_tready           ( rd_tready1               ) ,
  .m_axis_tlast            ( rd_tlast1                ) ,
  .m_axis_tdata            ( rd_tdata1                )
);

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master02 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done2               ) ,
  .ctrl_addr_offset        ( ref_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m02_axi_arvalid           ) ,
  .m_axi_arready           ( m02_axi_arready           ) ,
  .m_axi_araddr            ( m02_axi_araddr            ) ,
  .m_axi_arlen             ( m02_axi_arlen             ) ,
  .m_axi_rvalid            ( m02_axi_rvalid            ) ,
  .m_axi_rready            ( m02_axi_rready            ) ,
  .m_axi_rdata             ( m02_axi_rdata             ) ,
  .m_axi_rlast             ( m02_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid2               ) ,
  .m_axis_tready           ( rd_tready2               ) ,
  .m_axis_tlast            ( rd_tlast2                ) ,
  .m_axis_tdata            ( rd_tdata2                )
);

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master03 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done3               ) ,
  .ctrl_addr_offset        ( ref_addr_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m03_axi_arvalid           ) ,
  .m_axi_arready           ( m03_axi_arready           ) ,
  .m_axi_araddr            ( m03_axi_araddr            ) ,
  .m_axi_arlen             ( m03_axi_arlen             ) ,
  .m_axi_rvalid            ( m03_axi_rvalid            ) ,
  .m_axi_rready            ( m03_axi_rready            ) ,
  .m_axi_rdata             ( m03_axi_rdata             ) ,
  .m_axi_rlast             ( m03_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid3               ) ,
  .m_axis_tready           ( rd_tready3               ) ,
  .m_axis_tlast            ( rd_tlast3                ) ,
  .m_axis_tdata            ( rd_tdata3                )
);

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master04 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done4               ) ,
  .ctrl_addr_offset        ( query_addr_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m04_axi_arvalid           ) ,
  .m_axi_arready           ( m04_axi_arready           ) ,
  .m_axi_araddr            ( m04_axi_araddr            ) ,
  .m_axi_arlen             ( m04_axi_arlen             ) ,
  .m_axi_rvalid            ( m04_axi_rvalid            ) ,
  .m_axi_rready            ( m04_axi_rready            ) ,
  .m_axi_rdata             ( m04_axi_rdata             ) ,
  .m_axi_rlast             ( m04_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid4               ) ,
  .m_axis_tready           ( rd_tready4               ) ,
  .m_axis_tlast            ( rd_tlast4                ) ,
  .m_axis_tdata            ( rd_tdata4                )
);

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
KDarwin_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master05 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( read_done5               ) ,
  .ctrl_addr_offset        ( dir_rd_addr        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m05_axi_arvalid           ) ,
  .m_axi_arready           ( m05_axi_arready           ) ,
  .m_axi_araddr            ( m05_axi_araddr            ) ,
  .m_axi_arlen             ( m05_axi_arlen             ) ,
  .m_axi_rvalid            ( m05_axi_rvalid            ) ,
  .m_axi_rready            ( m05_axi_rready            ) ,
  .m_axi_rdata             ( m05_axi_rdata             ) ,
  .m_axi_rlast             ( m05_axi_rlast             ) ,
  .m_axis_aclk             ( ap_clk              ) ,
  .m_axis_areset           ( areset              ) ,
  .m_axis_tvalid           ( rd_tvalid5               ) ,
  .m_axis_tready           ( rd_tready5               ) ,
  .m_axis_tlast            ( rd_tlast5                ) ,
  .m_axis_tdata            ( rd_tdata5                )
);

KDarwin_logic #(
  .C_AXIS_TDATA_WIDTH ( C_M00_AXI_DATA_WIDTH ) ,
  .C_ADDER_BIT_WIDTH  ( 256  ) ,
  .C_NUM_CLOCKS       ( 1                  )
)
inst_darwin_logic  (
  .s_axis_aclk   ( ap_clk                   ) ,
  .s_axis_areset ( areset                   ) ,
  .ctrl_constant ( ctrl_constant                ) ,
  
  .s_axis_tvalid0 ( rd_tvalid0                    ) ,
  .s_axis_tready0 ( rd_tready0                    ) ,
  .s_axis_tdata0  ( rd_tdata0                     ) ,
  
    .s_axis_tvalid1 ( rd_tvalid1                    ) ,
  .s_axis_tready1 ( rd_tready1                    ) ,
  .s_axis_tdata1  ( rd_tdata1                     ) ,
  
    .s_axis_tvalid2 ( rd_tvalid2                    ) ,
  .s_axis_tready2 ( rd_tready2                    ) ,
  .s_axis_tdata2  ( rd_tdata2                     ) ,
  
    .s_axis_tvalid3 ( rd_tvalid3                    ) ,
  .s_axis_tready3 ( rd_tready3                    ) ,
  .s_axis_tdata3  ( rd_tdata3                     ) ,
  
    .s_axis_tvalid4 ( rd_tvalid4                    ) ,
  .s_axis_tready4 ( rd_tready4                    ) ,
  .s_axis_tdata4  ( rd_tdata4                     ) ,
  
  .s_axis_tvalid5 ( rd_tvalid5                    ) ,
  .s_axis_tready5 ( rd_tready5                    ) ,
  .s_axis_tdata5  ( rd_tdata5                     ) ,
  
  .s_axis_tkeep  ( {C_M00_AXI_DATA_WIDTH/8{1'b1}} ) ,
  
  .s_axis_tlast0  ( rd_tlast0                     ) ,
  .s_axis_tlast1  ( rd_tlast1                     ) ,
  .s_axis_tlast2  ( rd_tlast2                     ) ,
  .s_axis_tlast3  ( rd_tlast3                     ) ,
  .s_axis_tlast4  ( rd_tlast4                     ) ,
  .s_axis_tlast5  ( rd_tlast5                     ) ,
  
  .m_axis_aclk   ( ap_clk                   ) ,
  
  .m_axis_tvalid0 ( adder_tvalid0                 ) ,
  .m_axis_tready0 ( adder_tready0                 ) ,
  .m_axis_tdata0  ( adder_tdata0                  ) ,
  
  .m_axis_tvalid1 ( adder_tvalid1                 ) ,
  .m_axis_tready1 ( adder_tready1                 ) ,
  .m_axis_tdata1  ( adder_tdata1                  ) ,
  
  .m_axis_tvalid2 ( adder_tvalid2                 ) ,
  .m_axis_tready2 ( adder_tready2                 ) ,
  .m_axis_tdata2  ( adder_tdata2                  ) ,
  
  .m_axis_tvalid3 ( adder_tvalid3                 ) ,
  .m_axis_tready3 ( adder_tready3                 ) ,
  .m_axis_tdata3  ( adder_tdata3                  ) ,
  
  .m_axis_tvalid4 ( adder_tvalid4                 ) ,
  .m_axis_tready4 ( adder_tready4                 ) ,
  .m_axis_tdata4  ( adder_tdata4                  ) ,
  
  .m_axis_tvalid5 ( adder_tvalid5                 ) ,
  .m_axis_tready5 ( adder_tready5                 ) ,
  .m_axis_tdata5  ( adder_tdata5                  ) ,
  
  .m_axis_tkeep  (                              ) , // Not used
  .m_axis_tlast  (                              ) , // Not used
  
  //.in_params_lite (   in_params),
  .set_params_lite (   set_params),
  .ref_wr_en_lite (   ref_wr_en),
  .query_wr_en_lite (   query_wr_en),
  .max_tb_steps_lite (   max_tb_steps),
  .ref_len_lite (   ref_len),
  .query_len_lite (   query_len),
  .score_threshold_lite (   score_threshold),
  .align_fields_lite (   align_fields),
  .start_lite (   start),
  .clear_done_lite (   clear_done),
  .req_id_in_lite (   req_id_in)
);

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master00 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done0              ) ,
  .ctrl_addr_offset        ( in_params        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m00_axi_awvalid           ) ,
  .m_axi_awready           ( m00_axi_awready           ) ,
  .m_axi_awaddr            ( m00_axi_awaddr            ) ,
  .m_axi_awlen             ( m00_axi_awlen             ) ,
  .m_axi_wvalid            ( m00_axi_wvalid            ) ,
  .m_axi_wready            ( m00_axi_wready            ) ,
  .m_axi_wdata             ( m00_axi_wdata             ) ,
  .m_axi_wstrb             ( m00_axi_wstrb             ) ,
  .m_axi_wlast             ( m00_axi_wlast             ) ,
  .m_axi_bvalid            ( m00_axi_bvalid            ) ,
  .m_axi_bready            ( m00_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid0            ) ,
  .s_axis_tready           ( adder_tready0            ) ,
  .s_axis_tdata            ( adder_tdata0             )
);

assign ap_done_i[0] = write_done0;

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master01 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done1              ) ,
  .ctrl_addr_offset        ( query_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m01_axi_awvalid           ) ,
  .m_axi_awready           ( m01_axi_awready           ) ,
  .m_axi_awaddr            ( m01_axi_awaddr            ) ,
  .m_axi_awlen             ( m01_axi_awlen             ) ,
  .m_axi_wvalid            ( m01_axi_wvalid            ) ,
  .m_axi_wready            ( m01_axi_wready            ) ,
  .m_axi_wdata             ( m01_axi_wdata             ) ,
  .m_axi_wstrb             ( m01_axi_wstrb             ) ,
  .m_axi_wlast             ( m01_axi_wlast             ) ,
  .m_axi_bvalid            ( m01_axi_bvalid            ) ,
  .m_axi_bready            ( m01_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid1            ) ,
  .s_axis_tready           ( adder_tready1            ) ,
  .s_axis_tdata            ( adder_tdata1             )
);

assign ap_done_i[1] = write_done1;

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master02 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done2              ) ,
  .ctrl_addr_offset        ( ref_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m02_axi_awvalid           ) ,
  .m_axi_awready           ( m02_axi_awready           ) ,
  .m_axi_awaddr            ( m02_axi_awaddr            ) ,
  .m_axi_awlen             ( m02_axi_awlen             ) ,
  .m_axi_wvalid            ( m02_axi_wvalid            ) ,
  .m_axi_wready            ( m02_axi_wready            ) ,
  .m_axi_wdata             ( m02_axi_wdata             ) ,
  .m_axi_wstrb             ( m02_axi_wstrb             ) ,
  .m_axi_wlast             ( m02_axi_wlast             ) ,
  .m_axi_bvalid            ( m02_axi_bvalid            ) ,
  .m_axi_bready            ( m02_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid2            ) ,
  .s_axis_tready           ( adder_tready2            ) ,
  .s_axis_tdata            ( adder_tdata2             )
);

assign ap_done_i[2] = write_done2;

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master03 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done3              ) ,
  .ctrl_addr_offset        ( ref_addr_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m03_axi_awvalid           ) ,
  .m_axi_awready           ( m03_axi_awready           ) ,
  .m_axi_awaddr            ( m03_axi_awaddr            ) ,
  .m_axi_awlen             ( m03_axi_awlen             ) ,
  .m_axi_wvalid            ( m03_axi_wvalid            ) ,
  .m_axi_wready            ( m03_axi_wready            ) ,
  .m_axi_wdata             ( m03_axi_wdata             ) ,
  .m_axi_wstrb             ( m03_axi_wstrb             ) ,
  .m_axi_wlast             ( m03_axi_wlast             ) ,
  .m_axi_bvalid            ( m03_axi_bvalid            ) ,
  .m_axi_bready            ( m03_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid3            ) ,
  .s_axis_tready           ( adder_tready3            ) ,
  .s_axis_tdata            ( adder_tdata3             )
);

assign ap_done_i[3] = write_done3;

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master04 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done4              ) ,
  .ctrl_addr_offset        ( query_addr_in        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m04_axi_awvalid           ) ,
  .m_axi_awready           ( m04_axi_awready           ) ,
  .m_axi_awaddr            ( m04_axi_awaddr            ) ,
  .m_axi_awlen             ( m04_axi_awlen             ) ,
  .m_axi_wvalid            ( m04_axi_wvalid            ) ,
  .m_axi_wready            ( m04_axi_wready            ) ,
  .m_axi_wdata             ( m04_axi_wdata             ) ,
  .m_axi_wstrb             ( m04_axi_wstrb             ) ,
  .m_axi_wlast             ( m04_axi_wlast             ) ,
  .m_axi_bvalid            ( m04_axi_bvalid            ) ,
  .m_axi_bready            ( m04_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid4            ) ,
  .s_axis_tready           ( adder_tready4            ) ,
  .s_axis_tdata            ( adder_tdata4             )
);

assign ap_done_i[4] = write_done4;

// AXI4 Write Master
KDarwin_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( 32     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master05 (
  .aclk                    ( ap_clk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start_pulse                ) ,
  .ctrl_done               ( write_done5              ) ,
  .ctrl_addr_offset        ( dir_rd_addr        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m05_axi_awvalid           ) ,
  .m_axi_awready           ( m05_axi_awready           ) ,
  .m_axi_awaddr            ( m05_axi_awaddr            ) ,
  .m_axi_awlen             ( m05_axi_awlen             ) ,
  .m_axi_wvalid            ( m05_axi_wvalid            ) ,
  .m_axi_wready            ( m05_axi_wready            ) ,
  .m_axi_wdata             ( m05_axi_wdata             ) ,
  .m_axi_wstrb             ( m05_axi_wstrb             ) ,
  .m_axi_wlast             ( m05_axi_wlast             ) ,
  .m_axi_bvalid            ( m05_axi_bvalid            ) ,
  .m_axi_bready            ( m05_axi_bready            ) ,
  .s_axis_aclk             ( ap_clk              ) ,
  .s_axis_areset           ( areset              ) ,
  .s_axis_tvalid           ( adder_tvalid5            ) ,
  .s_axis_tready           ( adder_tready5            ) ,
  .s_axis_tdata            ( adder_tdata5             )
);

assign ap_done_i[5] = write_done5;



endmodule : KDarwin_block
`default_nettype wire
