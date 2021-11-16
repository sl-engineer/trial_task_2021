//===============================================================================================================
// Module: tb_vip_slave.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_slave
#(
    localparam ADDR_W      = cross_bar_pkg::ADDR_W,
    localparam DATA_W      = cross_bar_pkg::DATA_W,
    localparam type addr_t = cross_bar_pkg::addr_t,
    localparam type data_t = cross_bar_pkg::data_t
)
(
    // clk and asynchronus negative reset
    input logic    clk,
    input logic    aresetn,

    // slave interface
    input  logic   slave_req,
    input  addr_t  slave_addr,
    input  logic   slave_cmd,
    input  data_t  slave_wdata,
    output logic   slave_ack,
    output data_t  slave_rdata

);

import cross_bar_pkg::*;



endmodule
