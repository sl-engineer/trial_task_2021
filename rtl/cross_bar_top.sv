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
    input  logic  [MASTER_N - 1: 0] master_req,
    input  addr_t [MASTER_N - 1: 0] master_addr,
    input  logic  [MASTER_N - 1: 0] master_cmd,
    input  data_t [MASTER_N - 1: 0] master_wdata,
    output logic  [MASTER_N - 1: 0] master_ack,
    output data_t [MASTER_N - 1: 0] master_rdata,

    // slave interface
    output logic  [SLAVE_N - 1: 0]  slave_req,
    output addr_t [SLAVE_N - 1: 0]  slave_addr,
    output logic  [SLAVE_N - 1: 0]  slave_cmd,
    output data_t [SLAVE_N - 1: 0]  slave_wdata,
    input  logic  [SLAVE_N - 1: 0]  slave_ack,
    input  data_t [SLAVE_N - 1: 0]  slave_rdata

);

import cross_bar_pkg::*;

//---------------------------------------------------------------------------------------------------------------
// inner grant matrix 
//---------------------------------------------------------------------------------------------------------------
msgrant_t [SLAVE_N - 1: 0] msgrant; 
msgrant_t                  sgrant;

always_comb
begin
    sgrant = 0;
    for (int unsigned index = 0; index < SLAVE_N; index++)
    begin
        sgrant |= msgrant[index];
    end
end  

//---------------------------------------------------------------------------------------------------------------
// masters
//---------------------------------------------------------------------------------------------------------------
generate
  for (genvar i = 0; i < MASTER_N; i = i + 1) begin: master_instance_gen
      cross_bar_master mst (
                              // master interface
                              .master_ack   (master_ack[i]),
                              .master_rdata (master_rdata[i]),

                              // slave interface
                              .slave_ack    (slave_ack),
                              .slave_rdata  (slave_rdata),
    
                              // inner interface
                              .sgrant       (sgrant[i])
                           );
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// slaves
//---------------------------------------------------------------------------------------------------------------
logic [SLAVE_N - 1: 0] saddr [SLAVE_N - 1: 0];

generate
  for (genvar i = 0; i < SLAVE_N; i = i + 1) begin: slave_instance_gen
      
      assign saddr[i] = 1 << i;
  
      cross_bar_slave  slv (  
                              // clk and asynchronus negative reset
                              .clk          (clk),
                              .aresetn      (aresetn),
    
                              // master interface
                              .master_req   (master_req),
                              .master_addr  (master_addr),
                              .master_cmd   (master_cmd),
                              .master_wdata (master_wdata),

                              // slave interface
                              .slave_req      (slave_req[i]),
                              .slave_addr    (slave_addr[i]),
                              .slave_cmd      (slave_cmd[i]),
                              .slave_wdata  (slave_wdata[i]),
    
                              // inner interface
                              .saddr          (saddr[i]), // every slave must know its number in one hot system
                              .msgrant      (msgrant[i])
                           );
  end
endgenerate


endmodule
