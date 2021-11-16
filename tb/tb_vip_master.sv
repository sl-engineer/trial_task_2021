//===============================================================================================================
// Module: tb_vip_master.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_master
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

    // master interface
    output logic   master_req,
    output addr_t  master_addr,
    output logic   master_cmd,
    output data_t  master_wdata,
    input logic    master_ack,
    input data_t   master_rdata

);

import cross_bar_pkg::*;



endmodule
