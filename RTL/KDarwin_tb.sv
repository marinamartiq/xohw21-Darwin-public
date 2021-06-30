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
`timescale 1 ps / 1 ps
import axi_vip_pkg::*;
import slv_m00_axi_vip_pkg::*;
import slv_m01_axi_vip_pkg::*;
import slv_m02_axi_vip_pkg::*;
import slv_m03_axi_vip_pkg::*;
import slv_m04_axi_vip_pkg::*;
import slv_m05_axi_vip_pkg::*;
import control_KDarwin_vip_pkg::*;

module KDarwin_tb ();
parameter integer LP_MAX_LENGTH = 8192;
parameter integer LP_MAX_TRANSFER_LENGTH = 16384 / 4;
parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12;
parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32;
parameter integer C_M00_AXI_ADDR_WIDTH = 64;
parameter integer C_M00_AXI_DATA_WIDTH = 512;
parameter integer C_M01_AXI_ADDR_WIDTH = 64;
parameter integer C_M01_AXI_DATA_WIDTH = 512;
parameter integer C_M02_AXI_ADDR_WIDTH = 64;
parameter integer C_M02_AXI_DATA_WIDTH = 512;
parameter integer C_M03_AXI_ADDR_WIDTH = 64;
parameter integer C_M03_AXI_DATA_WIDTH = 512;
parameter integer C_M04_AXI_ADDR_WIDTH = 64;
parameter integer C_M04_AXI_DATA_WIDTH = 512;
parameter integer C_M05_AXI_ADDR_WIDTH = 64;
parameter integer C_M05_AXI_DATA_WIDTH = 512;

// Control Register
parameter KRNL_CTRL_REG_ADDR     = 32'h00000000;
parameter CTRL_START_MASK        = 32'h00000001;
parameter CTRL_DONE_MASK         = 32'h00000002;
parameter CTRL_IDLE_MASK         = 32'h00000004;
parameter CTRL_READY_MASK        = 32'h00000008;
parameter CTRL_CONTINUE_MASK     = 32'h00000010; // Only ap_ctrl_chain
parameter CTRL_AUTO_RESTART_MASK = 32'h00000080; // Not used

// Global Interrupt Enable Register
parameter KRNL_GIE_REG_ADDR      = 32'h00000004;
parameter GIE_GIE_MASK           = 32'h00000001;
// IP Interrupt Enable Register
parameter KRNL_IER_REG_ADDR      = 32'h00000008;
parameter IER_DONE_MASK          = 32'h00000001;
parameter IER_READY_MASK         = 32'h00000002;
// IP Interrupt Status Register
parameter KRNL_ISR_REG_ADDR      = 32'h0000000c;
parameter ISR_DONE_MASK          = 32'h00000001;
parameter ISR_READY_MASK         = 32'h00000002;

parameter integer LP_CLK_PERIOD_PS = 4000; // 250 MHz

//System Signals
logic ap_clk = 0;

initial begin: AP_CLK
  forever begin
    ap_clk = #(LP_CLK_PERIOD_PS/2) ~ap_clk;
  end
end
 
//System Signals
logic ap_rst_n = 0;
logic initial_reset  =0;

task automatic ap_rst_n_sequence(input integer unsigned width = 20);
  @(posedge ap_clk);
  #1ps;
  ap_rst_n = 0;
  repeat (width) @(posedge ap_clk);
  #1ps;
  ap_rst_n = 1;
endtask

initial begin: AP_RST
  ap_rst_n_sequence(50);
  initial_reset =1;
end
//AXI4 master interface m00_axi
wire [1-1:0] m00_axi_awvalid;
wire [1-1:0] m00_axi_awready;
wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_awaddr;
wire [8-1:0] m00_axi_awlen;
wire [1-1:0] m00_axi_wvalid;
wire [1-1:0] m00_axi_wready;
wire [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_wdata;
wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb;
wire [1-1:0] m00_axi_wlast;
wire [1-1:0] m00_axi_bvalid;
wire [1-1:0] m00_axi_bready;
wire [1-1:0] m00_axi_arvalid;
wire [1-1:0] m00_axi_arready;
wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_araddr;
wire [8-1:0] m00_axi_arlen;
wire [1-1:0] m00_axi_rvalid;
wire [1-1:0] m00_axi_rready;
wire [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_rdata;
wire [1-1:0] m00_axi_rlast;
//AXI4 master interface m01_axi
wire [1-1:0] m01_axi_awvalid;
wire [1-1:0] m01_axi_awready;
wire [C_M01_AXI_ADDR_WIDTH-1:0] m01_axi_awaddr;
wire [8-1:0] m01_axi_awlen;
wire [1-1:0] m01_axi_wvalid;
wire [1-1:0] m01_axi_wready;
wire [C_M01_AXI_DATA_WIDTH-1:0] m01_axi_wdata;
wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb;
wire [1-1:0] m01_axi_wlast;
wire [1-1:0] m01_axi_bvalid;
wire [1-1:0] m01_axi_bready;
wire [1-1:0] m01_axi_arvalid;
wire [1-1:0] m01_axi_arready;
wire [C_M01_AXI_ADDR_WIDTH-1:0] m01_axi_araddr;
wire [8-1:0] m01_axi_arlen;
wire [1-1:0] m01_axi_rvalid;
wire [1-1:0] m01_axi_rready;
wire [C_M01_AXI_DATA_WIDTH-1:0] m01_axi_rdata;
wire [1-1:0] m01_axi_rlast;
//AXI4 master interface m02_axi
wire [1-1:0] m02_axi_awvalid;
wire [1-1:0] m02_axi_awready;
wire [C_M02_AXI_ADDR_WIDTH-1:0] m02_axi_awaddr;
wire [8-1:0] m02_axi_awlen;
wire [1-1:0] m02_axi_wvalid;
wire [1-1:0] m02_axi_wready;
wire [C_M02_AXI_DATA_WIDTH-1:0] m02_axi_wdata;
wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb;
wire [1-1:0] m02_axi_wlast;
wire [1-1:0] m02_axi_bvalid;
wire [1-1:0] m02_axi_bready;
wire [1-1:0] m02_axi_arvalid;
wire [1-1:0] m02_axi_arready;
wire [C_M02_AXI_ADDR_WIDTH-1:0] m02_axi_araddr;
wire [8-1:0] m02_axi_arlen;
wire [1-1:0] m02_axi_rvalid;
wire [1-1:0] m02_axi_rready;
wire [C_M02_AXI_DATA_WIDTH-1:0] m02_axi_rdata;
wire [1-1:0] m02_axi_rlast;
//AXI4 master interface m03_axi
wire [1-1:0] m03_axi_awvalid;
wire [1-1:0] m03_axi_awready;
wire [C_M03_AXI_ADDR_WIDTH-1:0] m03_axi_awaddr;
wire [8-1:0] m03_axi_awlen;
wire [1-1:0] m03_axi_wvalid;
wire [1-1:0] m03_axi_wready;
wire [C_M03_AXI_DATA_WIDTH-1:0] m03_axi_wdata;
wire [C_M03_AXI_DATA_WIDTH/8-1:0] m03_axi_wstrb;
wire [1-1:0] m03_axi_wlast;
wire [1-1:0] m03_axi_bvalid;
wire [1-1:0] m03_axi_bready;
wire [1-1:0] m03_axi_arvalid;
wire [1-1:0] m03_axi_arready;
wire [C_M03_AXI_ADDR_WIDTH-1:0] m03_axi_araddr;
wire [8-1:0] m03_axi_arlen;
wire [1-1:0] m03_axi_rvalid;
wire [1-1:0] m03_axi_rready;
wire [C_M03_AXI_DATA_WIDTH-1:0] m03_axi_rdata;
wire [1-1:0] m03_axi_rlast;
//AXI4 master interface m04_axi
wire [1-1:0] m04_axi_awvalid;
wire [1-1:0] m04_axi_awready;
wire [C_M04_AXI_ADDR_WIDTH-1:0] m04_axi_awaddr;
wire [8-1:0] m04_axi_awlen;
wire [1-1:0] m04_axi_wvalid;
wire [1-1:0] m04_axi_wready;
wire [C_M04_AXI_DATA_WIDTH-1:0] m04_axi_wdata;
wire [C_M04_AXI_DATA_WIDTH/8-1:0] m04_axi_wstrb;
wire [1-1:0] m04_axi_wlast;
wire [1-1:0] m04_axi_bvalid;
wire [1-1:0] m04_axi_bready;
wire [1-1:0] m04_axi_arvalid;
wire [1-1:0] m04_axi_arready;
wire [C_M04_AXI_ADDR_WIDTH-1:0] m04_axi_araddr;
wire [8-1:0] m04_axi_arlen;
wire [1-1:0] m04_axi_rvalid;
wire [1-1:0] m04_axi_rready;
wire [C_M04_AXI_DATA_WIDTH-1:0] m04_axi_rdata;
wire [1-1:0] m04_axi_rlast;
//AXI4 master interface m05_axi
wire [1-1:0] m05_axi_awvalid;
wire [1-1:0] m05_axi_awready;
wire [C_M05_AXI_ADDR_WIDTH-1:0] m05_axi_awaddr;
wire [8-1:0] m05_axi_awlen;
wire [1-1:0] m05_axi_wvalid;
wire [1-1:0] m05_axi_wready;
wire [C_M05_AXI_DATA_WIDTH-1:0] m05_axi_wdata;
wire [C_M05_AXI_DATA_WIDTH/8-1:0] m05_axi_wstrb;
wire [1-1:0] m05_axi_wlast;
wire [1-1:0] m05_axi_bvalid;
wire [1-1:0] m05_axi_bready;
wire [1-1:0] m05_axi_arvalid;
wire [1-1:0] m05_axi_arready;
wire [C_M05_AXI_ADDR_WIDTH-1:0] m05_axi_araddr;
wire [8-1:0] m05_axi_arlen;
wire [1-1:0] m05_axi_rvalid;
wire [1-1:0] m05_axi_rready;
wire [C_M05_AXI_DATA_WIDTH-1:0] m05_axi_rdata;
wire [1-1:0] m05_axi_rlast;
//AXI4LITE control signals
wire [1-1:0] s_axi_control_awvalid;
wire [1-1:0] s_axi_control_awready;
wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0] s_axi_control_awaddr;
wire [1-1:0] s_axi_control_wvalid;
wire [1-1:0] s_axi_control_wready;
wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0] s_axi_control_wdata;
wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb;
wire [1-1:0] s_axi_control_arvalid;
wire [1-1:0] s_axi_control_arready;
wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0] s_axi_control_araddr;
wire [1-1:0] s_axi_control_rvalid;
wire [1-1:0] s_axi_control_rready;
wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0] s_axi_control_rdata;
wire [2-1:0] s_axi_control_rresp;
wire [1-1:0] s_axi_control_bvalid;
wire [1-1:0] s_axi_control_bready;
wire [2-1:0] s_axi_control_bresp;
wire interrupt;

// DUT instantiation
KDarwin #(
  .C_S_AXI_CONTROL_ADDR_WIDTH ( C_S_AXI_CONTROL_ADDR_WIDTH ),
  .C_S_AXI_CONTROL_DATA_WIDTH ( C_S_AXI_CONTROL_DATA_WIDTH ),
  .C_M00_AXI_ADDR_WIDTH       ( C_M00_AXI_ADDR_WIDTH       ),
  .C_M00_AXI_DATA_WIDTH       ( C_M00_AXI_DATA_WIDTH       ),
  .C_M01_AXI_ADDR_WIDTH       ( C_M01_AXI_ADDR_WIDTH       ),
  .C_M01_AXI_DATA_WIDTH       ( C_M01_AXI_DATA_WIDTH       ),
  .C_M02_AXI_ADDR_WIDTH       ( C_M02_AXI_ADDR_WIDTH       ),
  .C_M02_AXI_DATA_WIDTH       ( C_M02_AXI_DATA_WIDTH       ),
  .C_M03_AXI_ADDR_WIDTH       ( C_M03_AXI_ADDR_WIDTH       ),
  .C_M03_AXI_DATA_WIDTH       ( C_M03_AXI_DATA_WIDTH       ),
  .C_M04_AXI_ADDR_WIDTH       ( C_M04_AXI_ADDR_WIDTH       ),
  .C_M04_AXI_DATA_WIDTH       ( C_M04_AXI_DATA_WIDTH       ),
  .C_M05_AXI_ADDR_WIDTH       ( C_M05_AXI_ADDR_WIDTH       ),
  .C_M05_AXI_DATA_WIDTH       ( C_M05_AXI_DATA_WIDTH       )
)
inst_dut (
  .ap_clk                ( ap_clk                ),
  .ap_rst_n              ( ap_rst_n              ),
  .m00_axi_awvalid       ( m00_axi_awvalid       ),
  .m00_axi_awready       ( m00_axi_awready       ),
  .m00_axi_awaddr        ( m00_axi_awaddr        ),
  .m00_axi_awlen         ( m00_axi_awlen         ),
  .m00_axi_wvalid        ( m00_axi_wvalid        ),
  .m00_axi_wready        ( m00_axi_wready        ),
  .m00_axi_wdata         ( m00_axi_wdata         ),
  .m00_axi_wstrb         ( m00_axi_wstrb         ),
  .m00_axi_wlast         ( m00_axi_wlast         ),
  .m00_axi_bvalid        ( m00_axi_bvalid        ),
  .m00_axi_bready        ( m00_axi_bready        ),
  .m00_axi_arvalid       ( m00_axi_arvalid       ),
  .m00_axi_arready       ( m00_axi_arready       ),
  .m00_axi_araddr        ( m00_axi_araddr        ),
  .m00_axi_arlen         ( m00_axi_arlen         ),
  .m00_axi_rvalid        ( m00_axi_rvalid        ),
  .m00_axi_rready        ( m00_axi_rready        ),
  .m00_axi_rdata         ( m00_axi_rdata         ),
  .m00_axi_rlast         ( m00_axi_rlast         ),
  .m01_axi_awvalid       ( m01_axi_awvalid       ),
  .m01_axi_awready       ( m01_axi_awready       ),
  .m01_axi_awaddr        ( m01_axi_awaddr        ),
  .m01_axi_awlen         ( m01_axi_awlen         ),
  .m01_axi_wvalid        ( m01_axi_wvalid        ),
  .m01_axi_wready        ( m01_axi_wready        ),
  .m01_axi_wdata         ( m01_axi_wdata         ),
  .m01_axi_wstrb         ( m01_axi_wstrb         ),
  .m01_axi_wlast         ( m01_axi_wlast         ),
  .m01_axi_bvalid        ( m01_axi_bvalid        ),
  .m01_axi_bready        ( m01_axi_bready        ),
  .m01_axi_arvalid       ( m01_axi_arvalid       ),
  .m01_axi_arready       ( m01_axi_arready       ),
  .m01_axi_araddr        ( m01_axi_araddr        ),
  .m01_axi_arlen         ( m01_axi_arlen         ),
  .m01_axi_rvalid        ( m01_axi_rvalid        ),
  .m01_axi_rready        ( m01_axi_rready        ),
  .m01_axi_rdata         ( m01_axi_rdata         ),
  .m01_axi_rlast         ( m01_axi_rlast         ),
  .m02_axi_awvalid       ( m02_axi_awvalid       ),
  .m02_axi_awready       ( m02_axi_awready       ),
  .m02_axi_awaddr        ( m02_axi_awaddr        ),
  .m02_axi_awlen         ( m02_axi_awlen         ),
  .m02_axi_wvalid        ( m02_axi_wvalid        ),
  .m02_axi_wready        ( m02_axi_wready        ),
  .m02_axi_wdata         ( m02_axi_wdata         ),
  .m02_axi_wstrb         ( m02_axi_wstrb         ),
  .m02_axi_wlast         ( m02_axi_wlast         ),
  .m02_axi_bvalid        ( m02_axi_bvalid        ),
  .m02_axi_bready        ( m02_axi_bready        ),
  .m02_axi_arvalid       ( m02_axi_arvalid       ),
  .m02_axi_arready       ( m02_axi_arready       ),
  .m02_axi_araddr        ( m02_axi_araddr        ),
  .m02_axi_arlen         ( m02_axi_arlen         ),
  .m02_axi_rvalid        ( m02_axi_rvalid        ),
  .m02_axi_rready        ( m02_axi_rready        ),
  .m02_axi_rdata         ( m02_axi_rdata         ),
  .m02_axi_rlast         ( m02_axi_rlast         ),
  .m03_axi_awvalid       ( m03_axi_awvalid       ),
  .m03_axi_awready       ( m03_axi_awready       ),
  .m03_axi_awaddr        ( m03_axi_awaddr        ),
  .m03_axi_awlen         ( m03_axi_awlen         ),
  .m03_axi_wvalid        ( m03_axi_wvalid        ),
  .m03_axi_wready        ( m03_axi_wready        ),
  .m03_axi_wdata         ( m03_axi_wdata         ),
  .m03_axi_wstrb         ( m03_axi_wstrb         ),
  .m03_axi_wlast         ( m03_axi_wlast         ),
  .m03_axi_bvalid        ( m03_axi_bvalid        ),
  .m03_axi_bready        ( m03_axi_bready        ),
  .m03_axi_arvalid       ( m03_axi_arvalid       ),
  .m03_axi_arready       ( m03_axi_arready       ),
  .m03_axi_araddr        ( m03_axi_araddr        ),
  .m03_axi_arlen         ( m03_axi_arlen         ),
  .m03_axi_rvalid        ( m03_axi_rvalid        ),
  .m03_axi_rready        ( m03_axi_rready        ),
  .m03_axi_rdata         ( m03_axi_rdata         ),
  .m03_axi_rlast         ( m03_axi_rlast         ),
  .m04_axi_awvalid       ( m04_axi_awvalid       ),
  .m04_axi_awready       ( m04_axi_awready       ),
  .m04_axi_awaddr        ( m04_axi_awaddr        ),
  .m04_axi_awlen         ( m04_axi_awlen         ),
  .m04_axi_wvalid        ( m04_axi_wvalid        ),
  .m04_axi_wready        ( m04_axi_wready        ),
  .m04_axi_wdata         ( m04_axi_wdata         ),
  .m04_axi_wstrb         ( m04_axi_wstrb         ),
  .m04_axi_wlast         ( m04_axi_wlast         ),
  .m04_axi_bvalid        ( m04_axi_bvalid        ),
  .m04_axi_bready        ( m04_axi_bready        ),
  .m04_axi_arvalid       ( m04_axi_arvalid       ),
  .m04_axi_arready       ( m04_axi_arready       ),
  .m04_axi_araddr        ( m04_axi_araddr        ),
  .m04_axi_arlen         ( m04_axi_arlen         ),
  .m04_axi_rvalid        ( m04_axi_rvalid        ),
  .m04_axi_rready        ( m04_axi_rready        ),
  .m04_axi_rdata         ( m04_axi_rdata         ),
  .m04_axi_rlast         ( m04_axi_rlast         ),
  .m05_axi_awvalid       ( m05_axi_awvalid       ),
  .m05_axi_awready       ( m05_axi_awready       ),
  .m05_axi_awaddr        ( m05_axi_awaddr        ),
  .m05_axi_awlen         ( m05_axi_awlen         ),
  .m05_axi_wvalid        ( m05_axi_wvalid        ),
  .m05_axi_wready        ( m05_axi_wready        ),
  .m05_axi_wdata         ( m05_axi_wdata         ),
  .m05_axi_wstrb         ( m05_axi_wstrb         ),
  .m05_axi_wlast         ( m05_axi_wlast         ),
  .m05_axi_bvalid        ( m05_axi_bvalid        ),
  .m05_axi_bready        ( m05_axi_bready        ),
  .m05_axi_arvalid       ( m05_axi_arvalid       ),
  .m05_axi_arready       ( m05_axi_arready       ),
  .m05_axi_araddr        ( m05_axi_araddr        ),
  .m05_axi_arlen         ( m05_axi_arlen         ),
  .m05_axi_rvalid        ( m05_axi_rvalid        ),
  .m05_axi_rready        ( m05_axi_rready        ),
  .m05_axi_rdata         ( m05_axi_rdata         ),
  .m05_axi_rlast         ( m05_axi_rlast         ),
  .s_axi_control_awvalid ( s_axi_control_awvalid ),
  .s_axi_control_awready ( s_axi_control_awready ),
  .s_axi_control_awaddr  ( s_axi_control_awaddr  ),
  .s_axi_control_wvalid  ( s_axi_control_wvalid  ),
  .s_axi_control_wready  ( s_axi_control_wready  ),
  .s_axi_control_wdata   ( s_axi_control_wdata   ),
  .s_axi_control_wstrb   ( s_axi_control_wstrb   ),
  .s_axi_control_arvalid ( s_axi_control_arvalid ),
  .s_axi_control_arready ( s_axi_control_arready ),
  .s_axi_control_araddr  ( s_axi_control_araddr  ),
  .s_axi_control_rvalid  ( s_axi_control_rvalid  ),
  .s_axi_control_rready  ( s_axi_control_rready  ),
  .s_axi_control_rdata   ( s_axi_control_rdata   ),
  .s_axi_control_rresp   ( s_axi_control_rresp   ),
  .s_axi_control_bvalid  ( s_axi_control_bvalid  ),
  .s_axi_control_bready  ( s_axi_control_bready  ),
  .s_axi_control_bresp   ( s_axi_control_bresp   ),
  .interrupt             ( interrupt             )
);

// Master Control instantiation
control_KDarwin_vip inst_control_KDarwin_vip (
  .aclk          ( ap_clk                ),
  .aresetn       ( ap_rst_n              ),
  .m_axi_awvalid ( s_axi_control_awvalid ),
  .m_axi_awready ( s_axi_control_awready ),
  .m_axi_awaddr  ( s_axi_control_awaddr  ),
  .m_axi_wvalid  ( s_axi_control_wvalid  ),
  .m_axi_wready  ( s_axi_control_wready  ),
  .m_axi_wdata   ( s_axi_control_wdata   ),
  .m_axi_wstrb   ( s_axi_control_wstrb   ),
  .m_axi_arvalid ( s_axi_control_arvalid ),
  .m_axi_arready ( s_axi_control_arready ),
  .m_axi_araddr  ( s_axi_control_araddr  ),
  .m_axi_rvalid  ( s_axi_control_rvalid  ),
  .m_axi_rready  ( s_axi_control_rready  ),
  .m_axi_rdata   ( s_axi_control_rdata   ),
  .m_axi_rresp   ( s_axi_control_rresp   ),
  .m_axi_bvalid  ( s_axi_control_bvalid  ),
  .m_axi_bready  ( s_axi_control_bready  ),
  .m_axi_bresp   ( s_axi_control_bresp   )
);

control_KDarwin_vip_mst_t  ctrl;

// Slave MM VIP instantiation
slv_m00_axi_vip inst_slv_m00_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m00_axi_awvalid ),
  .s_axi_awready ( m00_axi_awready ),
  .s_axi_awaddr  ( m00_axi_awaddr  ),
  .s_axi_awlen   ( m00_axi_awlen   ),
  .s_axi_wvalid  ( m00_axi_wvalid  ),
  .s_axi_wready  ( m00_axi_wready  ),
  .s_axi_wdata   ( m00_axi_wdata   ),
  .s_axi_wstrb   ( m00_axi_wstrb   ),
  .s_axi_wlast   ( m00_axi_wlast   ),
  .s_axi_bvalid  ( m00_axi_bvalid  ),
  .s_axi_bready  ( m00_axi_bready  ),
  .s_axi_arvalid ( m00_axi_arvalid ),
  .s_axi_arready ( m00_axi_arready ),
  .s_axi_araddr  ( m00_axi_araddr  ),
  .s_axi_arlen   ( m00_axi_arlen   ),
  .s_axi_rvalid  ( m00_axi_rvalid  ),
  .s_axi_rready  ( m00_axi_rready  ),
  .s_axi_rdata   (    ),
  //.s_axi_rdata   ( m00_axi_rdata   ),
  .s_axi_rlast   ( m00_axi_rlast   )
);
reg [9:0] params [0:11];

//  initial begin
assign   params[11] = 1;
assign      params[10] = -1;
assign      params[9] = -1;
assign      params[8] = -1;

assign     params[7] = 1;
assign      params[6] = -1;
assign      params[5] = -1;

assign      params[4] = 1;
assign     params[3] = -1;

assign      params[2] = 1;

assign      params[1] = -1;
assign      params[0] = -1;
//      in_params = {params[11], params[10], params[9], params[8], params[7], params[6], params[5], params[4], params[3], params[2], params[1], params[0]}; 
//      end
assign m00_axi_rdata = {392'd0, params[11], params[10], params[9], params[8], params[7], params[6], params[5], params[4], params[3], params[2], params[1], params[0]}; 
slv_m00_axi_vip_slv_mem_t   m00_axi;
slv_m00_axi_vip_slv_t   m00_axi_slv;

// Slave MM VIP instantiation
slv_m01_axi_vip inst_slv_m01_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m01_axi_awvalid ),
  .s_axi_awready ( m01_axi_awready ),
  .s_axi_awaddr  ( m01_axi_awaddr  ),
  .s_axi_awlen   ( m01_axi_awlen   ),
  .s_axi_wvalid  ( m01_axi_wvalid  ),
  .s_axi_wready  ( m01_axi_wready  ),
  .s_axi_wdata   ( m01_axi_wdata   ),
  .s_axi_wstrb   ( m01_axi_wstrb   ),
  .s_axi_wlast   ( m01_axi_wlast   ),
  .s_axi_bvalid  ( m01_axi_bvalid  ),
  .s_axi_bready  ( m01_axi_bready  ),
  .s_axi_arvalid ( m01_axi_arvalid ),
  .s_axi_arready ( m01_axi_arready ),
  .s_axi_araddr  ( m01_axi_araddr  ),
  .s_axi_arlen   ( m01_axi_arlen   ),
  .s_axi_rvalid  ( m01_axi_rvalid  ),
  .s_axi_rready  ( m01_axi_rready  ),
  .s_axi_rdata   (    ),
  //.s_axi_rdata   ( m01_axi_rdata   ),
  .s_axi_rlast   ( m01_axi_rlast   )
);

assign m01_axi_rdata = {448'd0, 64'h4154474354000000};
slv_m01_axi_vip_slv_mem_t   m01_axi;
slv_m01_axi_vip_slv_t   m01_axi_slv;

// Slave MM VIP instantiation
slv_m02_axi_vip inst_slv_m02_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m02_axi_awvalid ),
  .s_axi_awready ( m02_axi_awready ),
  .s_axi_awaddr  ( m02_axi_awaddr  ),
  .s_axi_awlen   ( m02_axi_awlen   ),
  .s_axi_wvalid  ( m02_axi_wvalid  ),
  .s_axi_wready  ( m02_axi_wready  ),
  .s_axi_wdata   ( m02_axi_wdata   ),
  .s_axi_wstrb   ( m02_axi_wstrb   ),
  .s_axi_wlast   ( m02_axi_wlast   ),
  .s_axi_bvalid  ( m02_axi_bvalid  ),
  .s_axi_bready  ( m02_axi_bready  ),
  .s_axi_arvalid ( m02_axi_arvalid ),
  .s_axi_arready ( m02_axi_arready ),
  .s_axi_araddr  ( m02_axi_araddr  ),
  .s_axi_arlen   ( m02_axi_arlen   ),
  .s_axi_rvalid  ( m02_axi_rvalid  ),
  .s_axi_rready  ( m02_axi_rready  ),
  .s_axi_rdata   (    ),
  //.s_axi_rdata   ( m02_axi_rdata   ),
  .s_axi_rlast   ( m02_axi_rlast   )
);

assign m02_axi_rdata = {448'd0, 64'h4147435400000000};
slv_m02_axi_vip_slv_mem_t   m02_axi;
slv_m02_axi_vip_slv_t   m02_axi_slv;

// Slave MM VIP instantiation
slv_m03_axi_vip inst_slv_m03_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m03_axi_awvalid ),
  .s_axi_awready ( m03_axi_awready ),
  .s_axi_awaddr  ( m03_axi_awaddr  ),
  .s_axi_awlen   ( m03_axi_awlen   ),
  .s_axi_wvalid  ( m03_axi_wvalid  ),
  .s_axi_wready  ( m03_axi_wready  ),
  .s_axi_wdata   ( m03_axi_wdata   ),
  .s_axi_wstrb   ( m03_axi_wstrb   ),
  .s_axi_wlast   ( m03_axi_wlast   ),
  .s_axi_bvalid  ( m03_axi_bvalid  ),
  .s_axi_bready  ( m03_axi_bready  ),
  .s_axi_arvalid ( m03_axi_arvalid ),
  .s_axi_arready ( m03_axi_arready ),
  .s_axi_araddr  ( m03_axi_araddr  ),
  .s_axi_arlen   ( m03_axi_arlen   ),
  .s_axi_rvalid  ( m03_axi_rvalid  ),
  .s_axi_rready  ( m03_axi_rready  ),
  .s_axi_rdata   (    ),
  //.s_axi_rdata   ( m03_axi_rdata   ),
  .s_axi_rlast   ( m03_axi_rlast   )
);

assign m03_axi_rdata = 1;
slv_m03_axi_vip_slv_mem_t   m03_axi;
slv_m03_axi_vip_slv_t   m03_axi_slv;

// Slave MM VIP instantiation
slv_m04_axi_vip inst_slv_m04_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m04_axi_awvalid ),
  .s_axi_awready ( m04_axi_awready ),
  .s_axi_awaddr  ( m04_axi_awaddr  ),
  .s_axi_awlen   ( m04_axi_awlen   ),
  .s_axi_wvalid  ( m04_axi_wvalid  ),
  .s_axi_wready  ( m04_axi_wready  ),
  .s_axi_wdata   ( m04_axi_wdata   ),
  .s_axi_wstrb   ( m04_axi_wstrb   ),
  .s_axi_wlast   ( m04_axi_wlast   ),
  .s_axi_bvalid  ( m04_axi_bvalid  ),
  .s_axi_bready  ( m04_axi_bready  ),
  .s_axi_arvalid ( m04_axi_arvalid ),
  .s_axi_arready ( m04_axi_arready ),
  .s_axi_araddr  ( m04_axi_araddr  ),
  .s_axi_arlen   ( m04_axi_arlen   ),
  .s_axi_rvalid  ( m04_axi_rvalid  ),
  .s_axi_rready  ( m04_axi_rready  ),
  //.s_axi_rdata   ( m04_axi_rdata   ),
  .s_axi_rdata   (    ),
  .s_axi_rlast   ( m04_axi_rlast   )
);

assign m04_axi_rdata = 1;
slv_m04_axi_vip_slv_mem_t   m04_axi;
slv_m04_axi_vip_slv_t   m04_axi_slv;

// Slave MM VIP instantiation
slv_m05_axi_vip inst_slv_m05_axi_vip (
  .aclk          ( ap_clk          ),
  .aresetn       ( ap_rst_n        ),
  .s_axi_awvalid ( m05_axi_awvalid ),
  .s_axi_awready ( m05_axi_awready ),
  .s_axi_awaddr  ( m05_axi_awaddr  ),
  .s_axi_awlen   ( m05_axi_awlen   ),
  .s_axi_wvalid  ( m05_axi_wvalid  ),
  .s_axi_wready  ( m05_axi_wready  ),
  .s_axi_wdata   ( m05_axi_wdata   ),
  .s_axi_wstrb   ( m05_axi_wstrb   ),
  .s_axi_wlast   ( m05_axi_wlast   ),
  .s_axi_bvalid  ( m05_axi_bvalid  ),
  .s_axi_bready  ( m05_axi_bready  ),
  .s_axi_arvalid ( m05_axi_arvalid ),
  .s_axi_arready ( m05_axi_arready ),
  .s_axi_araddr  ( m05_axi_araddr  ),
  .s_axi_arlen   ( m05_axi_arlen   ),
  .s_axi_rvalid  ( m05_axi_rvalid  ),
  .s_axi_rready  ( m05_axi_rready  ),
  .s_axi_rdata   ( m05_axi_rdata   ),
  .s_axi_rlast   ( m05_axi_rlast   )
);


slv_m05_axi_vip_slv_mem_t   m05_axi;
slv_m05_axi_vip_slv_t   m05_axi_slv;

parameter NUM_AXIS_MST = 0;
parameter NUM_AXIS_SLV = 0;

bit               error_found = 0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m00_axi
bit [63:0] in_params_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m01_axi
bit [63:0] query_in_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m02_axi
bit [63:0] ref_in_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m03_axi
bit [63:0] ref_addr_in_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m04_axi
bit [63:0] query_addr_in_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m05_axi
bit [63:0] dir_rd_addr_ptr = 64'h0;

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m00_axi memory.
function void m00_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m00_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m01_axi memory.
function void m01_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m01_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m02_axi memory.
function void m02_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m02_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m03_axi memory.
function void m03_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m03_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m04_axi memory.
function void m04_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m04_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m05_axi memory.
function void m05_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m05_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

task automatic system_reset_sequence(input integer unsigned width = 20);
  $display("%t : Starting System Reset Sequence", $time);
  fork
    ap_rst_n_sequence(25);
    
  join

endtask


/////////////////////////////////////////////////////////////////////////////////////////////////
// Generate a random 32bit number
function bit [31:0] get_random_4bytes();
  bit [31:0] rptr;
  ptr_random_failed: assert(std::randomize(rptr));
  return(rptr);
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Generate a random 64bit 4k aligned address pointer.
function bit [63:0] get_random_ptr();
  bit [63:0] rptr;
  ptr_random_failed: assert(std::randomize(rptr));
  rptr[31:0] &= ~(32'h00000fff);
  return(rptr);
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface non-blocking write
// The task will return when the transaction has been accepted by the driver. It will be some
// amount of time before it will appear on the interface.
task automatic write_register (input bit [31:0] addr_in, input bit [31:0] data);
  axi_transaction   wr_xfer;
  wr_xfer = ctrl.wr_driver.create_transaction("wr_xfer");
  assert(wr_xfer.randomize() with {addr == addr_in;});
  wr_xfer.set_data_beat(0, data);
  ctrl.wr_driver.send(wr_xfer);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface blocking write
// The task will return when the BRESP has been returned from the kernel.
task automatic blocking_write_register (input bit [31:0] addr_in, input bit [31:0] data);
  axi_transaction   wr_xfer;
  axi_transaction   wr_rsp;
  wr_xfer = ctrl.wr_driver.create_transaction("wr_xfer");
  wr_xfer.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
  assert(wr_xfer.randomize() with {addr == addr_in;});
  wr_xfer.set_data_beat(0, data);
  ctrl.wr_driver.send(wr_xfer);
  ctrl.wr_driver.wait_rsp(wr_rsp);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface blocking read
// The task will return when the BRESP has been returned from the kernel.
task automatic read_register (input bit [31:0] addr, output bit [31:0] rddata);
  axi_transaction   rd_xfer;
  axi_transaction   rd_rsp;
  bit [31:0] rd_value;
  rd_xfer = ctrl.rd_driver.create_transaction("rd_xfer");
  rd_xfer.set_addr(addr);
  rd_xfer.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
  ctrl.rd_driver.send(rd_xfer);
  ctrl.rd_driver.wait_rsp(rd_rsp);
  rd_value = rd_rsp.get_data_beat(0);
  rddata = rd_value;
endtask



/////////////////////////////////////////////////////////////////////////////////////////////////
// Poll the Control interface status register.
// This will poll until the DONE flag in the status register is asserted.
task automatic poll_done_register ();
  bit [31:0] rd_value;
  do begin
    read_register(KRNL_CTRL_REG_ADDR, rd_value);
  end while ((rd_value & CTRL_DONE_MASK) == 0);
endtask

// This will poll until the IDLE flag in the status register is asserted.
task automatic poll_idle_register ();
  bit [31:0] rd_value;
  do begin
    read_register(KRNL_CTRL_REG_ADDR, rd_value);
  end while ((rd_value & CTRL_IDLE_MASK) == 0);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Write to the control registers to enable the triggering of interrupts for the kernel
task automatic enable_interrupts();
  $display("Starting: Enabling Interrupts....");
  write_register(KRNL_GIE_REG_ADDR, GIE_GIE_MASK);
  write_register(KRNL_IER_REG_ADDR, IER_DONE_MASK);
  $display("Finished: Interrupts enabled.");
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Disabled the interrupts.
task automatic disable_interrupts();
  $display("Starting: Disable Interrupts....");
  write_register(KRNL_GIE_REG_ADDR, 32'h0);
  write_register(KRNL_IER_REG_ADDR, 32'h0);
  $display("Finished: Interrupts disabled.");
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
//When the interrupt is asserted, read the correct registers and clear the asserted interrupt.
task automatic service_interrupts();
  bit [31:0] rd_value;
  $display("Starting Servicing interrupts....");
  read_register(KRNL_CTRL_REG_ADDR, rd_value);
  $display("Control Register: 0x%0x", rd_value);

  blocking_write_register(KRNL_CTRL_REG_ADDR, rd_value);

  if ((rd_value & CTRL_DONE_MASK) == 0) begin
    $error("%t : DONE bit not asserted. Register value: (0x%0x)", $time, rd_value);
  end
  read_register(KRNL_ISR_REG_ADDR, rd_value);
  $display("Interrupt Status Register: 0x%0x", rd_value);
  blocking_write_register(KRNL_ISR_REG_ADDR, rd_value);
  $display("Finished Servicing interrupts");
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Start the control VIP, SLAVE memory models and AXI4-Stream.
task automatic start_vips();
  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Control Master: ctrl");
  ctrl = new("ctrl", KDarwin_tb.inst_control_KDarwin_vip.inst.IF);
  ctrl.start_master();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m00_axi");
  m00_axi = new("m00_axi", KDarwin_tb.inst_slv_m00_axi_vip.inst.IF);
  m00_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m01_axi");
  m01_axi = new("m01_axi", KDarwin_tb.inst_slv_m01_axi_vip.inst.IF);
  m01_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m02_axi");
  m02_axi = new("m02_axi", KDarwin_tb.inst_slv_m02_axi_vip.inst.IF);
  m02_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m03_axi");
  m03_axi = new("m03_axi", KDarwin_tb.inst_slv_m03_axi_vip.inst.IF);
  m03_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m04_axi");
  m04_axi = new("m04_axi", KDarwin_tb.inst_slv_m04_axi_vip.inst.IF);
  m04_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m05_axi");
  m05_axi = new("m05_axi", KDarwin_tb.inst_slv_m05_axi_vip.inst.IF);
  m05_axi.start_slave();

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, set the Slave to not de-assert WREADY at any time.
// This will show the fastest outbound bandwidth from the WRITE channel.
task automatic slv_no_backpressure_wready();
  axi_ready_gen     rgen;
  $display("%t - Applying slv_no_backpressure_wready", $time);

  rgen = new("m00_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m00_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m01_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m01_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m02_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m02_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m03_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m03_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m04_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m04_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m05_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m05_axi.wr_driver.set_wready_gen(rgen);

endtask


/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, apply a WREADY policy to introduce backpressure.
// Based on the simulation seed the order/shape of the WREADY per-channel will be different.
task automatic slv_random_backpressure_wready();
  axi_ready_gen     rgen;
  $display("%t - Applying slv_random_backpressure_wready", $time);

  rgen = new("m00_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m00_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m01_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m01_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m02_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m02_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m03_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m03_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m04_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m04_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m05_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m05_axi.wr_driver.set_wready_gen(rgen);

endtask


/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, force the memory model to not insert any inter-beat
// gaps on the READ channel.
task automatic slv_no_delay_rvalid();
  $display("%t - Applying slv_no_delay_rvalid", $time);

  m00_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m00_axi.mem_model.set_inter_beat_gap(0);

  m01_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m01_axi.mem_model.set_inter_beat_gap(0);

  m02_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m02_axi.mem_model.set_inter_beat_gap(0);

  m03_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m03_axi.mem_model.set_inter_beat_gap(0);

  m04_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m04_axi.mem_model.set_inter_beat_gap(0);

  m05_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m05_axi.mem_model.set_inter_beat_gap(0);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, Allow the memory model to insert any inter-beat
// gaps on the READ channel.
task automatic slv_random_delay_rvalid();
  $display("%t - Applying slv_random_delay_rvalid", $time);

  m00_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m00_axi.mem_model.set_inter_beat_gap_range(0,10);

  m01_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m01_axi.mem_model.set_inter_beat_gap_range(0,10);

  m02_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m02_axi.mem_model.set_inter_beat_gap_range(0,10);

  m03_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m03_axi.mem_model.set_inter_beat_gap_range(0,10);

  m04_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m04_axi.mem_model.set_inter_beat_gap_range(0,10);

  m05_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m05_axi.mem_model.set_inter_beat_gap_range(0,10);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Check to ensure, following reset the value of the register is 0.
// Check that only the width of the register bits can be written.
task automatic check_register_value(input bit [31:0] addr_in, input integer unsigned register_width, output bit error_found);
  bit [31:0] rddata;
  bit [31:0] mask_data;
  error_found = 0;
  if (register_width < 32) begin
    mask_data = (1 << register_width) - 1;
  end else begin
    mask_data = 32'h00000000;
    //mask_data = 32'hffffffff;
  end
  read_register(addr_in, rddata);
  if (rddata != 32'h0) begin
    $error("Initial value mismatch: A:0x%0x : Expected 0x%x -> Got 0x%x", addr_in, 0, rddata);
    error_found = 1;
  end
  //blocking_write_register(addr_in, 32'hffffffff);
  blocking_write_register(addr_in, 32'h00000000);
  read_register(addr_in, rddata);
  if (rddata != mask_data) begin
    $error("Initial value mismatch: A:0x%0x : Expected 0x%x -> Got 0x%x", addr_in, mask_data, rddata);
    error_found = 1;
  end
endtask


/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the scalar registers, check:
// * reset value
// * correct number bits set on a write
task automatic check_scalar_registers(output bit error_found);
  bit tmp_error_found = 0;
  error_found = 0;
  $display("%t : Checking post reset values of scalar registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 0: set_params (0x010)
  check_register_value(32'h010, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 1: ref_wr_en (0x018)
  check_register_value(32'h018, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 2: query_wr_en (0x020)
  check_register_value(32'h020, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 3: max_tb_steps (0x028)
  check_register_value(32'h028, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 4: ref_len (0x030)
  check_register_value(32'h030, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 5: query_len (0x038)
  check_register_value(32'h038, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 6: score_threshold (0x040)
  check_register_value(32'h040, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 7: align_fields (0x048)
  check_register_value(32'h048, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 8: start (0x050)
  check_register_value(32'h050, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 9: clear_done (0x058)
  check_register_value(32'h058, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 10: req_id_in (0x060)
  check_register_value(32'h060, 32, tmp_error_found);
  error_found |= tmp_error_found;

endtask

task automatic set_scalar_registers();
  $display("%t : Setting Scalar Registers registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 0: set_params (0x010) -> 32'hffffffff (scalar)
  write_register(32'h010, 32'hffffffff);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 1: ref_wr_en (0x018) -> 32'hffffffff (scalar)
  write_register(32'h018, 32'hffffffff);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 2: query_wr_en (0x020) -> 32'hffffffff (scalar)
  write_register(32'h020, 32'hffffffff);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 3: max_tb_steps (0x028) -> 32'hffffffff (scalar)
  write_register(32'h028, 400);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 4: ref_len (0x030) -> 32'hffffffff (scalar)
  write_register(32'h030, 12);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 5: query_len (0x038) -> 32'hffffffff (scalar)
  write_register(32'h038, 12);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 6: score_threshold (0x040) -> 32'hffffffff (scalar)
  write_register(32'h040, 32'h00000000);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 7: align_fields (0x048) -> 32'hffffffff (scalar)
  write_register(32'h048, (1<<5));

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 8: start (0x050) -> 32'hffffffff (scalar)
  write_register(32'h050, 32'hffffffff);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 9: clear_done (0x058) -> 32'hffffffff (scalar)
  write_register(32'h058, 32'hffffffff);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 10: req_id_in (0x060) -> 32'hffffffff (scalar)
  write_register(32'h060, 32'hffffffff);

endtask

task automatic check_pointer_registers(output bit error_found);
  bit tmp_error_found = 0;
  ///////////////////////////////////////////////////////////////////////////
  //Check the reset states of the pointer registers.
  $display("%t : Checking post reset values of pointer registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 11: in_params (0x068)
  check_register_value(32'h068, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 11: in_params (0x06c)
  check_register_value(32'h06c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 12: query_in (0x074)
  check_register_value(32'h074, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 12: query_in (0x078)
  check_register_value(32'h078, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 13: ref_in (0x080)
  check_register_value(32'h080, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 13: ref_in (0x084)
  check_register_value(32'h084, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 14: ref_addr_in (0x08c)
  check_register_value(32'h08c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 14: ref_addr_in (0x090)
  check_register_value(32'h090, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 15: query_addr_in (0x098)
  check_register_value(32'h098, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 15: query_addr_in (0x09c)
  check_register_value(32'h09c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 16: dir_rd_addr (0x0a4)
  check_register_value(32'h0a4, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 16: dir_rd_addr (0x0a8)
  check_register_value(32'h0a8, 32, tmp_error_found);
  error_found |= tmp_error_found;

endtask

task automatic set_memory_pointers();
  ///////////////////////////////////////////////////////////////////////////
  //Randomly generate memory pointers.
  in_params_ptr = get_random_ptr();
  query_in_ptr = get_random_ptr();
  ref_in_ptr = get_random_ptr();
  ref_addr_in_ptr = get_random_ptr();
  query_addr_in_ptr = get_random_ptr();
  dir_rd_addr_ptr = get_random_ptr();

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 11: in_params (0x068) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h068, in_params_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 11: in_params (0x06c) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h06c, in_params_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 12: query_in (0x074) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h074, query_in_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 12: query_in (0x078) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h078, query_in_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 13: ref_in (0x080) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h080, ref_in_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 13: ref_in (0x084) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h084, ref_in_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 14: ref_addr_in (0x08c) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h08c, ref_addr_in_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 14: ref_addr_in (0x090) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h090, ref_addr_in_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 15: query_addr_in (0x098) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h098, query_addr_in_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 15: query_addr_in (0x09c) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h09c, query_addr_in_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 16: dir_rd_addr (0x0a4) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h0a4, dir_rd_addr_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 16: dir_rd_addr (0x0a8) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h0a8, dir_rd_addr_ptr[63:32]);

endtask

task automatic backdoor_fill_memories();

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m00_axi_fill_memory(in_params_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m01_axi_fill_memory(query_in_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m02_axi_fill_memory(ref_in_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m03_axi_fill_memory(ref_addr_in_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m04_axi_fill_memory(query_addr_in_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m05_axi_fill_memory(dir_rd_addr_ptr, LP_MAX_LENGTH);

endtask

function automatic bit check_kernel_result();
  bit [31:0]        ret_rd_value = 32'h0;
  bit error_found = 0;
  integer error_counter;
  error_counter = 0;
/*
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m00_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m00_axi.mem_model.backdoor_memory_read_4byte(in_params_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m00_axi : @0x%x : Expected 0x%x -> Got 0x%x ", in_params_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m00_axi : @0x%x : Expected 0x%x -> Got 0x%x ", in_params_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m00_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m01_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m01_axi.mem_model.backdoor_memory_read_4byte(query_in_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m01_axi : @0x%x : Expected 0x%x -> Got 0x%x ", query_in_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m01_axi : @0x%x : Expected 0x%x -> Got 0x%x ", query_in_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m01_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m02_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m02_axi.mem_model.backdoor_memory_read_4byte(ref_in_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m02_axi : @0x%x : Expected 0x%x -> Got 0x%x ", ref_in_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m02_axi : @0x%x : Expected 0x%x -> Got 0x%x ", ref_in_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m02_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m03_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m03_axi.mem_model.backdoor_memory_read_4byte(ref_addr_in_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m03_axi : @0x%x : Expected 0x%x -> Got 0x%x ", ref_addr_in_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m03_axi : @0x%x : Expected 0x%x -> Got 0x%x ", ref_addr_in_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m03_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m04_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m04_axi.mem_model.backdoor_memory_read_4byte(query_addr_in_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m04_axi : @0x%x : Expected 0x%x -> Got 0x%x ", query_addr_in_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m04_axi : @0x%x : Expected 0x%x -> Got 0x%x ", query_addr_in_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m04_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m05_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m05_axi.mem_model.backdoor_memory_read_4byte(dir_rd_addr_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m05_axi : @0x%x : Expected 0x%x -> Got 0x%x ", dir_rd_addr_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m05_axi : @0x%x : Expected 0x%x -> Got 0x%x ", dir_rd_addr_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m05_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;*/

  return(error_found);
endfunction

bit choose_pressure_type = 0;
bit axis_choose_pressure_type = 0;
bit [0-1:0] axis_tlast_received;

/////////////////////////////////////////////////////////////////////////////////////////////////
// Set up the kernel for operation and set the kernel START bit.
// The task will poll the DONE bit and check the results when complete.
task automatic multiple_iteration(input integer unsigned num_iterations, output bit error_found);
  error_found = 0;

  $display("Starting: multiple_iteration");
  for (integer unsigned iter = 0; iter < num_iterations; iter++) begin

    
    $display("Starting iteration: %d / %d", iter+1, num_iterations);
    RAND_WREADY_PRESSURE_FAILED: assert(std::randomize(choose_pressure_type));
    case(choose_pressure_type)
      0: slv_no_backpressure_wready();
      1: slv_random_backpressure_wready();
    endcase
    RAND_RVALID_PRESSURE_FAILED: assert(std::randomize(choose_pressure_type));
    case(choose_pressure_type)
      0: slv_no_delay_rvalid();
      1: slv_random_delay_rvalid();
    endcase

    set_scalar_registers();
    set_memory_pointers();
    backdoor_fill_memories();
    // Check that Kernel is IDLE before starting.
    poll_idle_register();
    ///////////////////////////////////////////////////////////////////////////
    //Start transfers
    blocking_write_register(KRNL_CTRL_REG_ADDR, CTRL_START_MASK);

    ctrl.wait_drivers_idle();
    ///////////////////////////////////////////////////////////////////////////
    //Wait for interrupt being asserted or poll done register
    @(posedge interrupt);

    ///////////////////////////////////////////////////////////////////////////
    // Service the interrupt
    service_interrupts();
    wait(interrupt == 0);

    ///////////////////////////////////////////////////////////////////////////
    error_found |= check_kernel_result()   ;

    $display("Finished iteration: %d / %d", iter+1, num_iterations);
  end
 endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
//Instantiate AXI4 LITE VIP
initial begin : STIMULUS
  #200000;
  start_vips();
  check_scalar_registers(error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end

  check_pointer_registers(error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end

  enable_interrupts();

  multiple_iteration(1, error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end

  multiple_iteration(5, error_found);

  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end else begin
    $display( "Test completed successfully");
  end
  $finish;
end

endmodule
`default_nettype wire