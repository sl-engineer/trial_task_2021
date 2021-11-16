//===============================================================================================================
// Module: tb_vip_slave.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_slave
#(
    localparam SLAVE_N     = cross_bar_pkg::SLAVE_N,
    localparam ADDR_W      = cross_bar_pkg::ADDR_W,
    localparam DATA_W      = cross_bar_pkg::DATA_W,
    localparam type addr_t = cross_bar_pkg::addr_t,
    localparam type data_t = cross_bar_pkg::data_t
)
(
    // clk and asynchronus negative reset
    input logic   [SLAVE_N - 1: 0] clk,
    input logic                    aresetn,

    // slave interface
    input  logic  [SLAVE_N - 1: 0] slave_req,
    input  addr_t [SLAVE_N - 1: 0] slave_addr,
    input  logic  [SLAVE_N - 1: 0] slave_cmd,
    input  data_t [SLAVE_N - 1: 0] slave_wdata,
    output logic  [SLAVE_N - 1: 0] slave_ack,
    output data_t [SLAVE_N - 1: 0] slave_rdata

);

import cross_bar_pkg::*;



endmodule
