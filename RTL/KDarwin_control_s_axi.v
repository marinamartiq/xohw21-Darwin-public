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
// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.2 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1ns/1ps
module KDarwin_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 8,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire                          interrupt,
    output wire                          ap_start,
    input  wire                          ap_done,
    input  wire                          ap_ready,
    input  wire                          ap_idle,
    output wire [31:0]                   set_params,
    output wire [31:0]                   ref_wr_en,
    output wire [31:0]                   query_wr_en,
    output wire [31:0]                   max_tb_steps,
    output wire [31:0]                   ref_len,
    output wire [31:0]                   query_len,
    output wire [31:0]                   score_threshold,
    output wire [31:0]                   align_fields,
    output wire [31:0]                   start_r,
    output wire [31:0]                   clear_done,
    output wire [31:0]                   req_id_in,
    output wire [63:0]                   in_params,
    output wire [63:0]                   query_in,
    output wire [63:0]                   ref_in,
    output wire [63:0]                   ref_addr_in,
    output wire [63:0]                   query_addr_in,
    output wire [63:0]                   dir_rd_addr
);
//------------------------Address Info-------------------
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : Data signal of set_params
//        bit 31~0 - set_params[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of ref_wr_en
//        bit 31~0 - ref_wr_en[31:0] (Read/Write)
// 0x1c : reserved
// 0x20 : Data signal of query_wr_en
//        bit 31~0 - query_wr_en[31:0] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of max_tb_steps
//        bit 31~0 - max_tb_steps[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of ref_len
//        bit 31~0 - ref_len[31:0] (Read/Write)
// 0x34 : reserved
// 0x38 : Data signal of query_len
//        bit 31~0 - query_len[31:0] (Read/Write)
// 0x3c : reserved
// 0x40 : Data signal of score_threshold
//        bit 31~0 - score_threshold[31:0] (Read/Write)
// 0x44 : reserved
// 0x48 : Data signal of align_fields
//        bit 31~0 - align_fields[31:0] (Read/Write)
// 0x4c : reserved
// 0x50 : Data signal of start
//        bit 31~0 - start[31:0] (Read/Write)
// 0x54 : reserved
// 0x58 : Data signal of clear_done
//        bit 31~0 - clear_done[31:0] (Read/Write)
// 0x5c : reserved
// 0x60 : Data signal of req_id_in
//        bit 31~0 - req_id_in[31:0] (Read/Write)
// 0x64 : reserved
// 0x68 : Data signal of in_params
//        bit 31~0 - in_params[31:0] (Read/Write)
// 0x6c : Data signal of in_params
//        bit 31~0 - in_params[63:32] (Read/Write)
// 0x70 : reserved
// 0x74 : Data signal of query_in
//        bit 31~0 - query_in[31:0] (Read/Write)
// 0x78 : Data signal of query_in
//        bit 31~0 - query_in[63:32] (Read/Write)
// 0x7c : reserved
// 0x80 : Data signal of ref_in
//        bit 31~0 - ref_in[31:0] (Read/Write)
// 0x84 : Data signal of ref_in
//        bit 31~0 - ref_in[63:32] (Read/Write)
// 0x88 : reserved
// 0x8c : Data signal of ref_addr_in
//        bit 31~0 - ref_addr_in[31:0] (Read/Write)
// 0x90 : Data signal of ref_addr_in
//        bit 31~0 - ref_addr_in[63:32] (Read/Write)
// 0x94 : reserved
// 0x98 : Data signal of query_addr_in
//        bit 31~0 - query_addr_in[31:0] (Read/Write)
// 0x9c : Data signal of query_addr_in
//        bit 31~0 - query_addr_in[63:32] (Read/Write)
// 0xa0 : reserved
// 0xa4 : Data signal of dir_rd_addr
//        bit 31~0 - dir_rd_addr[31:0] (Read/Write)
// 0xa8 : Data signal of dir_rd_addr
//        bit 31~0 - dir_rd_addr[63:32] (Read/Write)
// 0xac : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_AP_CTRL                = 8'h00,
    ADDR_GIE                    = 8'h04,
    ADDR_IER                    = 8'h08,
    ADDR_ISR                    = 8'h0c,
    ADDR_SET_PARAMS_DATA_0      = 8'h10,
    ADDR_SET_PARAMS_CTRL        = 8'h14,
    ADDR_REF_WR_EN_DATA_0       = 8'h18,
    ADDR_REF_WR_EN_CTRL         = 8'h1c,
    ADDR_QUERY_WR_EN_DATA_0     = 8'h20,
    ADDR_QUERY_WR_EN_CTRL       = 8'h24,
    ADDR_MAX_TB_STEPS_DATA_0    = 8'h28,
    ADDR_MAX_TB_STEPS_CTRL      = 8'h2c,
    ADDR_REF_LEN_DATA_0         = 8'h30,
    ADDR_REF_LEN_CTRL           = 8'h34,
    ADDR_QUERY_LEN_DATA_0       = 8'h38,
    ADDR_QUERY_LEN_CTRL         = 8'h3c,
    ADDR_SCORE_THRESHOLD_DATA_0 = 8'h40,
    ADDR_SCORE_THRESHOLD_CTRL   = 8'h44,
    ADDR_ALIGN_FIELDS_DATA_0    = 8'h48,
    ADDR_ALIGN_FIELDS_CTRL      = 8'h4c,
    ADDR_START_DATA_0           = 8'h50,
    ADDR_START_CTRL             = 8'h54,
    ADDR_CLEAR_DONE_DATA_0      = 8'h58,
    ADDR_CLEAR_DONE_CTRL        = 8'h5c,
    ADDR_REQ_ID_IN_DATA_0       = 8'h60,
    ADDR_REQ_ID_IN_CTRL         = 8'h64,
    ADDR_IN_PARAMS_DATA_0       = 8'h68,
    ADDR_IN_PARAMS_DATA_1       = 8'h6c,
    ADDR_IN_PARAMS_CTRL         = 8'h70,
    ADDR_QUERY_IN_DATA_0        = 8'h74,
    ADDR_QUERY_IN_DATA_1        = 8'h78,
    ADDR_QUERY_IN_CTRL          = 8'h7c,
    ADDR_REF_IN_DATA_0          = 8'h80,
    ADDR_REF_IN_DATA_1          = 8'h84,
    ADDR_REF_IN_CTRL            = 8'h88,
    ADDR_REF_ADDR_IN_DATA_0     = 8'h8c,
    ADDR_REF_ADDR_IN_DATA_1     = 8'h90,
    ADDR_REF_ADDR_IN_CTRL       = 8'h94,
    ADDR_QUERY_ADDR_IN_DATA_0   = 8'h98,
    ADDR_QUERY_ADDR_IN_DATA_1   = 8'h9c,
    ADDR_QUERY_ADDR_IN_CTRL     = 8'ha0,
    ADDR_DIR_RD_ADDR_DATA_0     = 8'ha4,
    ADDR_DIR_RD_ADDR_DATA_1     = 8'ha8,
    ADDR_DIR_RD_ADDR_CTRL       = 8'hac,
    WRIDLE                      = 2'd0,
    WRDATA                      = 2'd1,
    WRRESP                      = 2'd2,
    WRRESET                     = 2'd3,
    RDIDLE                      = 2'd0,
    RDDATA                      = 2'd1,
    RDRESET                     = 2'd2,
    ADDR_BITS         = 8;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [31:0]                   wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [31:0]                   rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg                           int_ap_idle;
    reg                           int_ap_ready;
    reg                           int_ap_done = 1'b0;
    reg                           int_ap_start = 1'b0;
    reg                           int_auto_restart = 1'b0;
    reg                           int_gie = 1'b0;
    reg  [1:0]                    int_ier = 2'b0;
    reg  [1:0]                    int_isr = 2'b0;
    reg  [31:0]                   int_set_params = 'b0;
    reg  [31:0]                   int_ref_wr_en = 'b0;
    reg  [31:0]                   int_query_wr_en = 'b0;
    reg  [31:0]                   int_max_tb_steps = 'b0;
    reg  [31:0]                   int_ref_len = 'b0;
    reg  [31:0]                   int_query_len = 'b0;
    reg  [31:0]                   int_score_threshold = 'b0;
    reg  [31:0]                   int_align_fields = 'b0;
    reg  [31:0]                   int_start = 'b0;
    reg  [31:0]                   int_clear_done = 'b0;
    reg  [31:0]                   int_req_id_in = 'b0;
    reg  [63:0]                   int_in_params = 'b0;
    reg  [63:0]                   int_query_in = 'b0;
    reg  [63:0]                   int_ref_in = 'b0;
    reg  [63:0]                   int_ref_addr_in = 'b0;
    reg  [63:0]                   int_query_addr_in = 'b0;
    reg  [63:0]                   int_dir_rd_addr = 'b0;

//------------------------Instantiation------------------

//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 1'b0;
            case (raddr)
                ADDR_AP_CTRL: begin
                    rdata[0] <= int_ap_start;
                    rdata[1] <= int_ap_done;
                    rdata[2] <= int_ap_idle;
                    rdata[3] <= int_ap_ready;
                    rdata[7] <= int_auto_restart;
                end
                ADDR_GIE: begin
                    rdata <= int_gie;
                end
                ADDR_IER: begin
                    rdata <= int_ier;
                end
                ADDR_ISR: begin
                    rdata <= int_isr;
                end
                ADDR_SET_PARAMS_DATA_0: begin
                    rdata <= int_set_params[31:0];
                end
                ADDR_REF_WR_EN_DATA_0: begin
                    rdata <= int_ref_wr_en[31:0];
                end
                ADDR_QUERY_WR_EN_DATA_0: begin
                    rdata <= int_query_wr_en[31:0];
                end
                ADDR_MAX_TB_STEPS_DATA_0: begin
                    rdata <= int_max_tb_steps[31:0];
                end
                ADDR_REF_LEN_DATA_0: begin
                    rdata <= int_ref_len[31:0];
                end
                ADDR_QUERY_LEN_DATA_0: begin
                    rdata <= int_query_len[31:0];
                end
                ADDR_SCORE_THRESHOLD_DATA_0: begin
                    rdata <= int_score_threshold[31:0];
                end
                ADDR_ALIGN_FIELDS_DATA_0: begin
                    rdata <= int_align_fields[31:0];
                end
                ADDR_START_DATA_0: begin
                    rdata <= int_start[31:0];
                end
                ADDR_CLEAR_DONE_DATA_0: begin
                    rdata <= int_clear_done[31:0];
                end
                ADDR_REQ_ID_IN_DATA_0: begin
                    rdata <= int_req_id_in[31:0];
                end
                ADDR_IN_PARAMS_DATA_0: begin
                    rdata <= int_in_params[31:0];
                end
                ADDR_IN_PARAMS_DATA_1: begin
                    rdata <= int_in_params[63:32];
                end
                ADDR_QUERY_IN_DATA_0: begin
                    rdata <= int_query_in[31:0];
                end
                ADDR_QUERY_IN_DATA_1: begin
                    rdata <= int_query_in[63:32];
                end
                ADDR_REF_IN_DATA_0: begin
                    rdata <= int_ref_in[31:0];
                end
                ADDR_REF_IN_DATA_1: begin
                    rdata <= int_ref_in[63:32];
                end
                ADDR_REF_ADDR_IN_DATA_0: begin
                    rdata <= int_ref_addr_in[31:0];
                end
                ADDR_REF_ADDR_IN_DATA_1: begin
                    rdata <= int_ref_addr_in[63:32];
                end
                ADDR_QUERY_ADDR_IN_DATA_0: begin
                    rdata <= int_query_addr_in[31:0];
                end
                ADDR_QUERY_ADDR_IN_DATA_1: begin
                    rdata <= int_query_addr_in[63:32];
                end
                ADDR_DIR_RD_ADDR_DATA_0: begin
                    rdata <= int_dir_rd_addr[31:0];
                end
                ADDR_DIR_RD_ADDR_DATA_1: begin
                    rdata <= int_dir_rd_addr[63:32];
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign interrupt       = int_gie & (|int_isr);
assign ap_start        = int_ap_start;
assign set_params      = int_set_params;
assign ref_wr_en       = int_ref_wr_en;
assign query_wr_en     = int_query_wr_en;
assign max_tb_steps    = int_max_tb_steps;
assign ref_len         = int_ref_len;
assign query_len       = int_query_len;
assign score_threshold = int_score_threshold;
assign align_fields    = int_align_fields;
assign start           = int_start;
assign clear_done      = int_clear_done;
assign req_id_in       = int_req_id_in;
assign in_params       = int_in_params;
assign query_in        = int_query_in;
assign ref_in          = int_ref_in;
assign ref_addr_in     = int_ref_addr_in;
assign query_addr_in   = int_query_addr_in;
assign dir_rd_addr     = int_dir_rd_addr;
// int_ap_start
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_start <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0] && WDATA[0])
            int_ap_start <= 1'b1;
        else if (ap_ready)
            int_ap_start <= int_auto_restart; // clear on handshake/auto restart
    end
end

// int_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_done <= 1'b0;
    else if (ACLK_EN) begin
        if (ap_done)
            int_ap_done <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_ap_done <= 1'b0; // clear on read
    end
end

// int_ap_idle
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_idle <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_idle <= ap_idle;
    end
end

// int_ap_ready
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_ready <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_ready <= ap_ready;
    end
end

// int_auto_restart
always @(posedge ACLK) begin
    if (ARESET)
        int_auto_restart <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0])
            int_auto_restart <=  WDATA[7];
    end
end

// int_gie
always @(posedge ACLK) begin
    if (ARESET)
        int_gie <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_GIE && WSTRB[0])
            int_gie <= WDATA[0];
    end
end

// int_ier
always @(posedge ACLK) begin
    if (ARESET)
        int_ier <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IER && WSTRB[0])
            int_ier <= WDATA[1:0];
    end
end

// int_isr[0]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[0] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[0] & ap_done)
            int_isr[0] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[0] <= int_isr[0] ^ WDATA[0]; // toggle on write
    end
end

// int_isr[1]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[1] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[1] & ap_ready)
            int_isr[1] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[1] <= int_isr[1] ^ WDATA[1]; // toggle on write
    end
end

// int_set_params[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_set_params[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SET_PARAMS_DATA_0)
            int_set_params[31:0] <= (WDATA[31:0] & wmask) | (int_set_params[31:0] & ~wmask);
    end
end

// int_ref_wr_en[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_wr_en[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_WR_EN_DATA_0)
            int_ref_wr_en[31:0] <= (WDATA[31:0] & wmask) | (int_ref_wr_en[31:0] & ~wmask);
    end
end

// int_query_wr_en[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_wr_en[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_WR_EN_DATA_0)
            int_query_wr_en[31:0] <= (WDATA[31:0] & wmask) | (int_query_wr_en[31:0] & ~wmask);
    end
end

// int_max_tb_steps[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_max_tb_steps[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_MAX_TB_STEPS_DATA_0)
            int_max_tb_steps[31:0] <= (WDATA[31:0] & wmask) | (int_max_tb_steps[31:0] & ~wmask);
    end
end

// int_ref_len[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_len[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_LEN_DATA_0)
            int_ref_len[31:0] <= (WDATA[31:0] & wmask) | (int_ref_len[31:0] & ~wmask);
    end
end

// int_query_len[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_len[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_LEN_DATA_0)
            int_query_len[31:0] <= (WDATA[31:0] & wmask) | (int_query_len[31:0] & ~wmask);
    end
end

// int_score_threshold[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_score_threshold[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SCORE_THRESHOLD_DATA_0)
            int_score_threshold[31:0] <= (WDATA[31:0] & wmask) | (int_score_threshold[31:0] & ~wmask);
    end
end

// int_align_fields[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_align_fields[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ALIGN_FIELDS_DATA_0)
            int_align_fields[31:0] <= (WDATA[31:0] & wmask) | (int_align_fields[31:0] & ~wmask);
    end
end

// int_start[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_start[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_START_DATA_0)
            int_start[31:0] <= (WDATA[31:0] & wmask) | (int_start[31:0] & ~wmask);
    end
end

// int_clear_done[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_clear_done[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_CLEAR_DONE_DATA_0)
            int_clear_done[31:0] <= (WDATA[31:0] & wmask) | (int_clear_done[31:0] & ~wmask);
    end
end

// int_req_id_in[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_req_id_in[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REQ_ID_IN_DATA_0)
            int_req_id_in[31:0] <= (WDATA[31:0] & wmask) | (int_req_id_in[31:0] & ~wmask);
    end
end

// int_in_params[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_in_params[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IN_PARAMS_DATA_0)
            int_in_params[31:0] <= (WDATA[31:0] & wmask) | (int_in_params[31:0] & ~wmask);
    end
end

// int_in_params[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_in_params[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IN_PARAMS_DATA_1)
            int_in_params[63:32] <= (WDATA[31:0] & wmask) | (int_in_params[63:32] & ~wmask);
    end
end

// int_query_in[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_in[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_IN_DATA_0)
            int_query_in[31:0] <= (WDATA[31:0] & wmask) | (int_query_in[31:0] & ~wmask);
    end
end

// int_query_in[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_in[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_IN_DATA_1)
            int_query_in[63:32] <= (WDATA[31:0] & wmask) | (int_query_in[63:32] & ~wmask);
    end
end

// int_ref_in[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_in[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_IN_DATA_0)
            int_ref_in[31:0] <= (WDATA[31:0] & wmask) | (int_ref_in[31:0] & ~wmask);
    end
end

// int_ref_in[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_in[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_IN_DATA_1)
            int_ref_in[63:32] <= (WDATA[31:0] & wmask) | (int_ref_in[63:32] & ~wmask);
    end
end

// int_ref_addr_in[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_addr_in[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_ADDR_IN_DATA_0)
            int_ref_addr_in[31:0] <= (WDATA[31:0] & wmask) | (int_ref_addr_in[31:0] & ~wmask);
    end
end

// int_ref_addr_in[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_ref_addr_in[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_REF_ADDR_IN_DATA_1)
            int_ref_addr_in[63:32] <= (WDATA[31:0] & wmask) | (int_ref_addr_in[63:32] & ~wmask);
    end
end

// int_query_addr_in[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_addr_in[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_ADDR_IN_DATA_0)
            int_query_addr_in[31:0] <= (WDATA[31:0] & wmask) | (int_query_addr_in[31:0] & ~wmask);
    end
end

// int_query_addr_in[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_query_addr_in[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_QUERY_ADDR_IN_DATA_1)
            int_query_addr_in[63:32] <= (WDATA[31:0] & wmask) | (int_query_addr_in[63:32] & ~wmask);
    end
end

// int_dir_rd_addr[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_dir_rd_addr[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_DIR_RD_ADDR_DATA_0)
            int_dir_rd_addr[31:0] <= (WDATA[31:0] & wmask) | (int_dir_rd_addr[31:0] & ~wmask);
    end
end

// int_dir_rd_addr[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_dir_rd_addr[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_DIR_RD_ADDR_DATA_1)
            int_dir_rd_addr[63:32] <= (WDATA[31:0] & wmask) | (int_dir_rd_addr[63:32] & ~wmask);
    end
end


//------------------------Memory logic-------------------

endmodule
