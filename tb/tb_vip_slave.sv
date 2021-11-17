//===============================================================================================================
// Module: tb_vip_slave.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_slave
#(
    localparam SLAVE_W     = cross_bar_pkg::SLAVE_W,
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

logic [255: 0] mem [DATA_W - 1: 0]; // just for test use only 8 bits

always_ff @(posedge clk)
    if (slave_req && slave_cmd)
        mem[slave_addr[7:0]] <= slave_wdata;

assign slave_rdata = (slave_req && !slave_cmd) ? mem[slave_addr[7:0]] : 32'hxxxxxxxx;

always_ff @(posedge clk or negedge aresetn)
    if (!aresetn)
        slave_ack <= 1'b0;
    else if (slave_req) begin
        slave_ack <= 1'b1;
    
        if (slave_cmd) $display("time = %0t \tS[%0d] \tWRITE: Address[0x%8h] Data[0x%8h]",
                                        $time, slave_addr[ADDR_W - 1: ADDR_W - SLAVE_W], slave_addr, slave_wdata); 
                 
        else           $display("time = %0t \tS[%0d] \t READ: Address[0x%8h] Data[0x%8h]",
                                        $time, slave_addr[ADDR_W - 1: ADDR_W - SLAVE_W], slave_addr, slave_rdata); 
    end else
        slave_ack <= 1'b0;


endmodule
