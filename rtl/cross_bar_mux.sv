//===============================================================================================================
// Module: cross_bar_mux.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================
module cross_bar_mux
#(
    localparam MASTER_N          = cross_bar_pkg::MASTER_N,
    localparam SLAVE_N           = cross_bar_pkg::SLAVE_N,
    localparam type addr_t       = cross_bar_pkg::addr_t,
    localparam type data_t       = cross_bar_pkg::data_t,
    localparam type master_num_t = cross_bar_pkg::master_num_t,
    localparam type slave_num_t  = cross_bar_pkg::slave_num_t
)
(
    // mux controller interface   
    input slave_num_t  [MASTER_N: 1] master_mux,
    input master_num_t [SLAVE_N: 1]  slave_mux,

    // master interface
    input  logic       [MASTER_N: 1] master_req,
    input  addr_t      [MASTER_N: 1] master_addr,
    input  logic       [MASTER_N: 1] master_cmd,
    input  data_t      [MASTER_N: 1] master_wdata,
    output logic       [MASTER_N: 1] master_ack,
    output data_t      [MASTER_N: 1] master_rdata,

    // slave interface
    output logic       [SLAVE_N: 1]  slave_req,
    output addr_t      [SLAVE_N: 1]  slave_addr,
    output logic       [SLAVE_N: 1]  slave_cmd,
    output data_t      [SLAVE_N: 1]  slave_wdata,
    input  logic       [SLAVE_N: 1]  slave_ack,
    input  data_t      [SLAVE_N: 1]  slave_rdata
);

import cross_bar_pkg::*;

// generate variable
genvar i;

generate
  for (i = 1; i < SLAVE_N + 1; i = i + 1) begin : slave_mux_gen
      assign slave_req[i]   = (slave_mux[i]) ?   master_req[slave_mux[i]] : 0;
      assign slave_addr[i]  = (slave_mux[i]) ?  master_addr[slave_mux[i]] : 0;
      assign slave_cmd[i]   = (slave_mux[i]) ?   master_cmd[slave_mux[i]] : 0;
      assign slave_wdata[i] = (slave_mux[i]) ? master_wdata[slave_mux[i]] : 0;
  end
endgenerate

generate
  for (i = 1; i < MASTER_N + 1; i = i + 1) begin : master_mux_gen
      assign master_ack[i]   = (master_mux[i]) ?   slave_ack[master_mux[i]] : 0;
      assign master_rdata[i] = (master_mux[i]) ? slave_rdata[master_mux[i]] : 0;
  end
endgenerate

endmodule
//---------------------------------------------------------------------------------------------------------------
//                     master_mux                                              slave_mux
//                +----------------+----+                             +----+----------------+
//       ack  <---|                |    |<---  ack           req  --->|    |                |--->  req
//                |                | S1 |                   addr  ===>| M1 |                |===>  addr
//     rdata  <===|                |    |<===  rdata         cmd  --->|    |                |--->  cmd
//                |                |    |                  wdata  ===>|    |                |===>  wdata
//                | master_mux[1]: +----+                             +----+  slave_mux[1]: |
//                |                |    |<---  ack           req  --->|    |                |
//                | 0 - No connect | S2 |                   addr  ===>| M2 | 0 - No connect |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                | 1 - Slave 1    |    |                  wdata  ===>|    | 1 - Master 1   |
//                |                +----+                             +----+                |
//                | 2 - Slave 2    |    |<---  ack           req  --->|    | 2 - Master 2   |
//                |                | S3 |                   addr  ===>| M3 |                |
//                | 3 - Slave 3    |    |<===  rdata         cmd  --->|    | 3 - Master 3   |
//                |                |    |                  wdata  ===>|    |                |
//                | 4 - Slave 4    +----+                             +----+ 4 - Master 4   |
//                |                |    |<---  ack           req  --->|    |                |
//                |                | S4 |                   addr  ===>| M4 |                |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                |                |    |                  wdata  ===>|    |                |
//                +----------------+----+                             +----+----------------+
//
//                +----------------+----+                             +----+----------------+
//       ack  <---|                |    |<---  ack           req  --->|    |                |--->  req
//                |                | S1 |                   addr  ===>| M1 |                |===>  addr
//     rdata  <===|                |    |<===  rdata         cmd  --->|    |                |--->  cmd
//                |                |    |                  wdata  ===>|    |                |===>  wdata
//                | master_mux[2]: +----+                             +----+  slave_mux[2]: |
//                |                |    |<---  ack           req  --->|    |                |
//                | 0 - No connect | S2 |                   addr  ===>| M2 | 0 - No connect |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                | 1 - Slave 1    |    |                  wdata  ===>|    | 1 - Master 1   |
//                |                +----+                             +----+                |
//                | 2 - Slave 2    |    |<---  ack           req  --->|    | 2 - Master 2   |
//                |                | S3 |                   addr  ===>| M3 |                |
//                | 3 - Slave 3    |    |<===  rdata         cmd  --->|    | 3 - Master 3   |
//                |                |    |                  wdata  ===>|    |                |
//                | 4 - Slave 4    +----+                             +----+ 4 - Master 4   |
//                |                |    |<---  ack           req  --->|    |                |
//                |                | S4 |                   addr  ===>| M4 |                |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                |                |    |                  wdata  ===>|    |                |
//                +----------------+----+                             +----+----------------+
//
//                +----------------+----+                             +----+----------------+
//       ack  <---|                |    |<---  ack           req  --->|    |                |--->  req
//                |                | S1 |                   addr  ===>| M1 |                |===>  addr
//     rdata  <===|                |    |<===  rdata         cmd  --->|    |                |--->  cmd
//                |                |    |                  wdata  ===>|    |                |===>  wdata
//                | master_mux[3]: +----+                             +----+  slave_mux[3]: |
//                |                |    |<---  ack           req  --->|    |                |
//                | 0 - No connect | S2 |                   addr  ===>| M2 | 0 - No connect |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                | 1 - Slave 1    |    |                  wdata  ===>|    | 1 - Master 1   |
//                |                +----+                             +----+                |
//                | 2 - Slave 2    |    |<---  ack           req  --->|    | 2 - Master 2   |
//                |                | S3 |                   addr  ===>| M3 |                |
//                | 3 - Slave 3    |    |<===  rdata         cmd  --->|    | 3 - Master 3   |
//                |                |    |                  wdata  ===>|    |                |
//                | 4 - Slave 4    +----+                             +----+ 4 - Master 4   |
//                |                |    |<---  ack           req  --->|    |                |
//                |                | S4 |                   addr  ===>| M4 |                |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                |                |    |                  wdata  ===>|    |                |
//                +----------------+----+                             +----+----------------+
//
//                +----------------+----+                             +----+----------------+
//       ack  <---|                |    |<---  ack           req  --->|    |                |--->  req
//                |                | S1 |                   addr  ===>| M1 |                |===>  addr
//     rdata  <===|                |    |<===  rdata         cmd  --->|    |                |--->  cmd
//                |                |    |                  wdata  ===>|    |                |===>  wdata
//                | master_mux[4]: +----+                             +----+  slave_mux[4]: |
//                |                |    |<---  ack           req  --->|    |                |
//                | 0 - No connect | S2 |                   addr  ===>| M2 | 0 - No connect |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                | 1 - Slave 1    |    |                  wdata  ===>|    | 1 - Master 1   |
//                |                +----+                             +----+                |
//                | 2 - Slave 2    |    |<---  ack           req  --->|    | 2 - Master 2   |
//                |                | S3 |                   addr  ===>| M3 |                |
//                | 3 - Slave 3    |    |<===  rdata         cmd  --->|    | 3 - Master 3   |
//                |                |    |                  wdata  ===>|    |                |
//                | 4 - Slave 4    +----+                             +----+ 4 - Master 4   |
//                |                |    |<---  ack           req  --->|    |                |
//                |                | S4 |                   addr  ===>| M4 |                |
//                |                |    |<===  rdata         cmd  --->|    |                |
//                |                |    |                  wdata  ===>|    |                |
//                +----------------+----+                             +----+----------------+
//
//---------------------------------------------------------------------------------------------------------------
