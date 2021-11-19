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
    input logic                 clk,
    input logic                 aresetn,

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

// mux controller interface   
master_num_t [SLAVE_N: 1] slave_mux;
slave_num_t [MASTER_N: 1] master_mux;

//---------------------------------------------------------------------------------------------------------------
// MUX 
//---------------------------------------------------------------------------------------------------------------
cross_bar_mux mux (
                    // mux controller interface
                    .master_mux   (master_mux),
                    .slave_mux    (slave_mux),

                    // master interface
                    .master_req   (master_req),
                    .master_addr  (master_addr),
                    .master_cmd   (master_cmd),
                    .master_wdata (master_wdata),
                    .master_ack   (master_ack),
                    .master_rdata (master_rdata),

                    // slave interface
                    .slave_req    (slave_req),
                    .slave_addr   (slave_addr),
                    .slave_cmd    (slave_cmd),
                    .slave_wdata  (slave_wdata),
                    .slave_ack    (slave_ack),
                    .slave_rdata  (slave_rdata)
                   );

//---------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------



endmodule

