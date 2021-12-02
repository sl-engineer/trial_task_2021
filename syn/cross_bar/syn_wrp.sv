import cross_bar_pkg::*;

module syn_wrp
(
    // clk and asynchronus negative reset
    input logic                     clk,
    input logic                     resetn,

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

cross_bar_top cbar (
                    // common interface
                    .clk          (clk),
                    .aresetn      (resetn),

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

endmodule
