//===============================================================================================================
// Module: cross_bar_master.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_master
#(
    localparam SLAVE_N       = cross_bar_pkg::SLAVE_N,
    localparam type addr_t   = cross_bar_pkg::addr_t,
    localparam type data_t   = cross_bar_pkg::data_t,
    localparam type sgrant_t = cross_bar_pkg::sgrant_t
)
(
    // master interface
    output logic                   master_ack,
    output data_t                  master_rdata,

    // slave interface
    input  logic  [SLAVE_N - 1: 0] slave_ack,
    input  data_t [SLAVE_N - 1: 0] slave_rdata,
    
    // inner interface
    input  sgrant_t                sgrant
);

import cross_bar_pkg::*;

//---------------------------------------------------------------------------------------------------------------
// master_mux 
//---------------------------------------------------------------------------------------------------------------
always_comb
begin
    master_ack   =         1'b0;
    master_rdata = {DATA_W{1'b0}};
    for (int unsigned index = 0; index < SLAVE_N; index++)
    begin
        master_ack   |=         sgrant[index]   &   slave_ack[index];
        master_rdata |= {DATA_W{sgrant[index]}} & slave_rdata[index];
     end
end

endmodule
