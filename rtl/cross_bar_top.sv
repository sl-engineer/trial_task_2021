//===============================================================================================================
// Module: cross_bar_top.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_top
#(
    localparam MASTER_N    = cross_bar_pkg::MASTER_N,
    localparam MASTER_W    = cross_bar_pkg::MASTER_W,
    localparam SLAVE_N     = cross_bar_pkg::SLAVE_N,
    localparam SLAVE_W     = cross_bar_pkg::SLAVE_W,
    localparam ADDR_W      = cross_bar_pkg::ADDR_W,
    localparam DATA_W      = cross_bar_pkg::DATA_W,
    localparam type addr_t = cross_bar_pkg::addr_t,
    localparam type data_t = cross_bar_pkg::data_t
)
(
    // clk and asynchronus negative reset
    input logic                     clk,
    input logic                     aresetn,

    // master interface
    input  logic  [MASTER_N - 1: 0] master_req,
    input  addr_t [MASTER_N - 1: 0] master_addr,
    input  logic  [MASTER_N - 1: 0] master_cmd,
    input  data_t [MASTER_N - 1: 0] master_wdata,
    output logic  [MASTER_N - 1: 0] master_ack,
    output data_t [MASTER_N - 1: 0] master_rdata,

    // slave interface
    output logic  [SLAVE_N - 1: 0] slave_req,
    output addr_t [SLAVE_N - 1: 0] slave_addr,
    output logic  [SLAVE_N - 1: 0] slave_cmd,
    output data_t [SLAVE_N - 1: 0] slave_wdata,
    input  logic  [SLAVE_N - 1: 0] slave_ack,
    input  data_t [SLAVE_N - 1: 0] slave_rdata

);

import cross_bar_pkg::*;

// generate variable
genvar i;

//---------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------
typedef logic [MASTER_W - 1: 0] master_num_t;
master_num_t  [SLAVE_N - 1: 0]  master_num;

generate
  for (i = 0; i < SLAVE_N; i = i + 1) begin : slave_mux_gen
      assign slave_req[i]   = master_req[master_num[i]];
      assign slave_addr[i]  = master_addr[master_num[i]];
      assign slave_cmd[i]   = master_cmd[master_num[i]];
      assign slave_wdata[i] = master_wdata[master_num[i]];
  end
endgenerate

assign master_num = 0;

//---------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------
typedef logic [SLAVE_W - 1: 0] slave_num_t;
slave_num_t  [MASTER_N - 1: 0] slave_num;

generate
  for (i = 0; i < MASTER_N; i = i + 1) begin : master_mux_gen
      assign master_ack[i]   = slave_ack[slave_num[i]];
      assign master_rdata[i] = slave_rdata[slave_num[i]];
  end
endgenerate

assign slave_num = 0;


endmodule

