//===============================================================================================================
// Module: cross_bar_top.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_top
#(
    localparam MASTER_N    = cross_bar_pkg::MASTER_N,
    localparam SLAVE_N     = cross_bar_pkg::SLAVE_N,
    localparam type addr_t = cross_bar_pkg::addr_t,
    localparam type data_t = cross_bar_pkg::data_t
)
(
    // clk and asynchronus negative reset
    input logic                     clk,
    input logic                     aresetn,

    // master interface
    input  logic  [MASTER_N: 1] master_req,
    input  addr_t [MASTER_N: 1] master_addr,
    input  logic  [MASTER_N: 1] master_cmd,
    input  data_t [MASTER_N: 1] master_wdata,
    output logic  [MASTER_N: 1] master_ack,
    output data_t [MASTER_N: 1] master_rdata,

    // slave interface
    output logic  [SLAVE_N: 1] slave_req,
    output addr_t [SLAVE_N: 1] slave_addr,
    output logic  [SLAVE_N: 1] slave_cmd,
    output data_t [SLAVE_N: 1] slave_wdata,
    input  logic  [SLAVE_N: 1] slave_ack,
    input  data_t [SLAVE_N: 1] slave_rdata

);

import cross_bar_pkg::*;

// generate variable
genvar i;

//---------------------------------------------------------------------------------------------------------------
// Slave muxs:
// 0 - disconnected;
// 1 - master 1;
// 2 - master 2;
// ...
//---------------------------------------------------------------------------------------------------------------
typedef logic [MASTER_W: 0] master_num_t;
master_num_t  [SLAVE_N: 1]  slave_mux;

generate
  for (i = 1; i < SLAVE_N + 1; i = i + 1) begin : slave_mux_gen
      assign slave_req[i]   = (slave_mux[i]) ?   master_req[slave_mux[i]] : 0;
      assign slave_addr[i]  = (slave_mux[i]) ?  master_addr[slave_mux[i]] : 0;
      assign slave_cmd[i]   = (slave_mux[i]) ?   master_cmd[slave_mux[i]] : 0;
      assign slave_wdata[i] = (slave_mux[i]) ? master_wdata[slave_mux[i]] : 0;
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// Master muxs:
// 0 - disconnected;
// 1 - slave 1;
// 2 - slave 2;
// ... 
//---------------------------------------------------------------------------------------------------------------
typedef logic [SLAVE_W: 0]  slave_num_t;
slave_num_t   [MASTER_N: 1] master_mux;

generate
  for (i = 1; i < MASTER_N + 1; i = i + 1) begin : master_mux_gen
      assign master_ack[i]   = (master_mux[i]) ?   slave_ack[master_mux[i]] : 0;
      assign master_rdata[i] = (master_mux[i]) ? slave_rdata[master_mux[i]] : 0;
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// dummy data for test muxs
//---------------------------------------------------------------------------------------------------------------

assign slave_mux[1] = 3;
assign slave_mux[2] = 0;
assign slave_mux[3] = 1;
assign slave_mux[4] = 2;

assign master_mux[1] = 3;
assign master_mux[2] = 4;
assign master_mux[3] = 1;
assign master_mux[4] = 0;

endmodule

