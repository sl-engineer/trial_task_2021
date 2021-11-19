//===============================================================================================================
// Module: cross_bar_fifo.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_fifo
#(
    localparam type master_num_t = cross_bar_pkg::master_num_t,
    localparam type slave_num_t  = cross_bar_pkg::slave_num_t
)
(
    // clk and asynchronus negative reset
    input logic            clk,
    input logic            aresetn,

    // fifo interface 
    input  logic           rd,
    input  logic           wr,
    input  master_num_t    wdata,
    output master_num_t    rdata, 
    output logic           empty,
    
    // address fifo logic
    input  slave_num_t     set_addr,
    output slave_num_t     get_addr
);

import cross_bar_pkg::*;

//---------------------------------------------------------------------------------------------------------------
//                    +--------------------+
//             wdata  |                    |  rdata
// master_num =======>|        FIFO        |========> master_num
//                    |                    |
//                    +--------------------+
//
//            set_addr   +-------------+  get_addr
// slave_num ===========>|    CONST    |============> slave_num
//                       +-------------+
//---------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------------------
// FIFO read_pointer logic
//---------------------------------------------------------------------------------------------------------------
logic [SLAVE_W - 1: 0] rd_pt;
always_ff @(posedge clk or negedge aresetn)
    if (!aresetn)
        rd_pt <= 0;
    else if (rd && !empty && rd_pt != SLAVE_N - 1)
        rd_pt <= rd_pt + 1;
    else if (rd && !empty && rd_pt == SLAVE_N - 1)
        rd_pt <= 0;

//---------------------------------------------------------------------------------------------------------------
// FIFO write_pointer logic
//---------------------------------------------------------------------------------------------------------------
logic [SLAVE_W - 1: 0] wr_pt;
always_ff @(posedge clk or negedge aresetn)
    if (!aresetn)
        wr_pt <= 0;
    else if (wr && wr_pt != SLAVE_N - 1)
        wr_pt <= wr_pt + 1;
    else if (wr && wr_pt == SLAVE_N - 1)
        wr_pt <= 0;

//---------------------------------------------------------------------------------------------------------------
// FIFO wdata logic
//---------------------------------------------------------------------------------------------------------------
master_num_t [SLAVE_N - 1: 0] fifo_reg;
always_ff @(posedge clk or negedge aresetn)
    if (!aresetn)
        fifo_reg <= 0;
    else if (wr)
        fifo_reg[wr_pt] <= wdata;

//---------------------------------------------------------------------------------------------------------------
// FIFO rdata logic
//---------------------------------------------------------------------------------------------------------------
assign rdata = fifo_reg[rd_pt];

//---------------------------------------------------------------------------------------------------------------
// FIFO empty logic
//---------------------------------------------------------------------------------------------------------------
assign empty = (rd_pt == wr_pt) ? 1'b1 : 1'b0;  
    
//---------------------------------------------------------------------------------------------------------------
// CONST logic
//---------------------------------------------------------------------------------------------------------------
assign get_addr = set_addr;
    
endmodule

