//===============================================================================================================
// Module: tb_vip_master.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_master
#(
    localparam MASTER_N    = cross_bar_pkg::MASTER_N,
    localparam ADDR_W      = cross_bar_pkg::ADDR_W,
    localparam DATA_W      = cross_bar_pkg::DATA_W,
    localparam type addr_t = cross_bar_pkg::addr_t,
    localparam type data_t = cross_bar_pkg::data_t
)
(
    // clk and asynchronus negative reset
    input logic   [MASTER_N - 1: 0] clk,
    input logic                     aresetn,

    // master interface
    output logic  [MASTER_N - 1: 0] master_req,
    output addr_t [MASTER_N - 1: 0] master_addr,
    output logic  [MASTER_N - 1: 0] master_cmd,
    output data_t [MASTER_N - 1: 0] master_wdata,
    input logic   [MASTER_N - 1: 0] master_ack,
    input data_t  [MASTER_N - 1: 0] master_rdata

);

import cross_bar_pkg::*;



endmodule
