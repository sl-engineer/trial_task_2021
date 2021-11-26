//===============================================================================================================
// Module: cross_bar_slave.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_slave
#(
    localparam MASTER_N       = cross_bar_pkg::MASTER_N,
    localparam SLAVE_N        = cross_bar_pkg::SLAVE_N,
    localparam type addr_t    = cross_bar_pkg::addr_t,
    localparam type data_t    = cross_bar_pkg::data_t,
    localparam type msgrant_t = cross_bar_pkg::msgrant_t
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

    // slave interface
    output logic                    slave_req,
    output addr_t                   slave_addr,
    output logic                    slave_cmd,
    output data_t                   slave_wdata,
    
    // inner interface
    input  logic  [SLAVE_N - 1: 0]  saddr,                      // one hot type
    output msgrant_t                msgrant
);

import cross_bar_pkg::*;

// generate variable
genvar i;

//---------------------------------------------------------------------------------------------------------------
// inner signals
//---------------------------------------------------------------------------------------------------------------
logic [MASTER_N - 1: 0] req;
logic [MASTER_N - 1: 0] grant;

//---------------------------------------------------------------------------------------------------------------
// input req's filter
// saddr - one hot type's number of slave
//---------------------------------------------------------------------------------------------------------------
generate
  for (i = 0; i < MASTER_N; i = i + 1) begin: req_gen
      assign req[i] = 
                  (master_req[i] && saddr == (1 << master_addr[i][ADDR_W - 1: ADDR_W - SLAVE_W])) ? 1'b1 : 1'b0;
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// round robin arbiter
//---------------------------------------------------------------------------------------------------------------
cross_bar_rr_arbiter arbiter (
                              // clk and asynchronus negative reset
                              .clk     (clk),
                              .aresetn (aresetn),

                              // req and grant interface
                              .req     (req),
                              .grant   (grant)
                             );

//---------------------------------------------------------------------------------------------------------------
// slave_mux 
//---------------------------------------------------------------------------------------------------------------
always_comb
begin
  slave_req   =         1'b0;
  slave_addr  = {ADDR_W{1'b0}};
  slave_cmd   =         1'b0;
  slave_wdata = {DATA_W{1'b0}};
  for (int unsigned index = 0; index < MASTER_N; index++)
  begin
      slave_req   |=         grant[index]   &   master_req[index];
      slave_addr  |= {ADDR_W{grant[index]}} &  master_addr[index];
      slave_cmd   |=         grant[index]   &   master_cmd[index];
      slave_wdata |= {DATA_W{grant[index]}} & master_wdata[index];
  end
end

//---------------------------------------------------------------------------------------------------------------
// mgrant logic 
// saddr - one hot type's number of slave
//---------------------------------------------------------------------------------------------------------------
generate
  for (i = 0; i < MASTER_N; i = i + 1) begin: msgrant_gen
      assign msgrant[i] = (grant[i]) ? saddr : {SLAVE_N{1'b0}};
  end
endgenerate


endmodule
