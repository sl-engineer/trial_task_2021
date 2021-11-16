//===============================================================================================================
// Module: tb.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

import cross_bar_pkg::*;

`include "../tb/tb_vip_master.sv"
`include "../tb/tb_vip_slave.sv"

module tb();

// generate variable
genvar i;

//---------------------------------------------------------------------------------------------------------------
// clocks
//---------------------------------------------------------------------------------------------------------------
logic   device_clk;                                               // device clock
initial device_clk = 1'b0;
always #2.5ns device_clk = ~device_clk;                           // 200 MHz

logic [MASTER_N - 1: 0] master_clk;                               // master clocks
generate
  for (i = 0; i < MASTER_N; i = i + 1) begin: vip_master_clk_gen
      initial master_clk[i] = 1'b0;
      always #(2.75ns + i) master_clk[i] = ~master_clk[i];
  end
endgenerate

logic [SLAVE_N - 1: 0]  slave_clk;                                // slave clocks
generate
  for (i = 0; i < SLAVE_N; i = i + 1) begin: vip_slave_clk_gen
      initial slave_clk[i] = 1'b0;
      always #(5.25ns + i) slave_clk[i] = ~slave_clk[i];
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// reset  
//---------------------------------------------------------------------------------------------------------------
bit resetn = 1'b1;

initial begin
    repeat (20) @(posedge device_clk);
    resetn = 1'b0;
end

//---------------------------------------------------------------------------------------------------------------
// signals  
//---------------------------------------------------------------------------------------------------------------
// master interface
logic  [MASTER_N - 1: 0] master_req;
addr_t [MASTER_N - 1: 0] master_addr;
logic  [MASTER_N - 1: 0] master_cmd;
data_t [MASTER_N - 1: 0] master_wdata;
logic  [MASTER_N - 1: 0] master_ack;
data_t [MASTER_N - 1: 0] master_rdata;

// slave interface
logic  [SLAVE_N - 1: 0] slave_req;
addr_t [SLAVE_N - 1: 0] slave_addr;
logic  [SLAVE_N - 1: 0] slave_cmd;
data_t [SLAVE_N - 1: 0] slave_wdata;
logic  [SLAVE_N - 1: 0] slave_ack;
data_t [SLAVE_N - 1: 0] slave_rdata;

//---------------------------------------------------------------------------------------------------------------
// verification IPs 
//---------------------------------------------------------------------------------------------------------------
generate
  for (i = 0; i < MASTER_N; i = i + 1) begin: vip_master_gen
      tb_vip_master vip_master_gen (
                                     // common interface
                                     .clk          (master_clk[i]),
                                     .aresetn      (resetn),

                                     // master interface
                                     .master_req   (master_req[i]),
                                     .master_addr  (master_addr[i]),
                                     .master_cmd   (master_cmd[i]),
                                     .master_wdata (master_wdata[i]),
                                     .master_ack   (master_ack[i]),
                                     .master_rdata (master_rdata[i])
                                    );

  end
endgenerate

generate
  for (i = 0; i < SLAVE_N; i = i + 1) begin: vip_slave_gen
      tb_vip_slave vip_slave_gen (
                                     // common interface
                                     .clk         (slave_clk[i]),
                                     .aresetn     (resetn),

                                     // slave interface
                                     .slave_req   (slave_req[i]),
                                     .slave_addr  (slave_addr[i]),
                                     .slave_cmd   (slave_cmd[i]),
                                     .slave_wdata (slave_wdata[i]),
                                     .slave_ack   (slave_ack[i]),
                                     .slave_rdata (slave_rdata[i])
                                  );

  end
endgenerate


//---------------------------------------------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------------------------------------------
cross_bar_top dut (
                    // common interface
                    .clk          (device_clk),
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

//---------------------------------------------------------------------------------------------------------------
// testbench body 
//---------------------------------------------------------------------------------------------------------------
initial begin: main

  wait (!resetn);
  repeat (3) @(posedge device_clk);

  
  
  #1us;
  $display("Test passed!");
  $stop;
end  

endmodule

