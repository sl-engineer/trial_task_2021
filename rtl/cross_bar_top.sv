//===============================================================================================================
// Module: cross_bar_top.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_top
#(
    localparam MASTER_N    = cross_bar_pkg::MASTER_N,
    localparam SLAVE_N     = cross_bar_pkg::SLAVE_N,
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



endmodule

