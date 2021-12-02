//===============================================================================================================
// Module: tb_vip_slave.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module tb_vip_slave
#(
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

logic [DATA_W - 1: 0] mem [255: 0]; // just for test use only 8 bits = 1KB

//---------------------------------------------------------------------------------------------------------------
// Write to mem 
//---------------------------------------------------------------------------------------------------------------
always_ff @(posedge clk)
    if (slave_req && slave_cmd)
        mem[slave_addr[7:0]] <= slave_wdata;

//---------------------------------------------------------------------------------------------------------------
// Read from mem
//---------------------------------------------------------------------------------------------------------------
assign slave_rdata = (slave_req && !slave_cmd) ? mem[slave_addr[7:0]] : {DATA_W{1'bx}};

//---------------------------------------------------------------------------------------------------------------
// slave_ack logic and display 
//---------------------------------------------------------------------------------------------------------------
logic ack;
always_ff @(posedge clk or negedge aresetn)
    if (!aresetn)
        ack <= 1'b0;
    else if (slave_req) begin
        ack <= 1'b1;
    
        
        if (slave_cmd) $display("time = %0t \tS[%0d]                      Address[0x%8h] write Data[0x%8h]",
                                        $time, slave_addr[ADDR_W - 1: ADDR_W - SLAVE_W], slave_addr, slave_wdata); 
                 
        else           $display("time = %0t \tS[%0d]                      Address[0x%8h] read  Data[0x%8h]",
                                        $time, slave_addr[ADDR_W - 1: ADDR_W - SLAVE_W], slave_addr, slave_rdata); 
    
    
    end else
        ack <= 1'b0;


assign slave_ack = ack & slave_req;

endmodule
