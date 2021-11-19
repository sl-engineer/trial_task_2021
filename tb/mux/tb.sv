//===============================================================================================================
// Module: tb.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

import cross_bar_pkg::*;

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
      always #(2.75ns) master_clk[i] = ~master_clk[i];
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
    resetn = 1'b0;
    repeat (20) @(posedge device_clk);
    resetn = 1'b1;
end

//---------------------------------------------------------------------------------------------------------------
// signals  
//---------------------------------------------------------------------------------------------------------------
// mux controller interface 
master_num_t [SLAVE_N: 1] slave_mux;
slave_num_t [MASTER_N: 1] master_mux;

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
task automatic write (
                       logic  [MASTER_W: 0] device,
                       addr_t               addr,
                       data_t               data
                     );
    begin
        @(posedge master_clk[device - 1]);
        
          master_req[device - 1] = 1'b1;
         master_addr[device - 1] = addr;
          master_cmd[device - 1] = 1'b1;
        master_wdata[device - 1] = data;
        
        $display("time = %0t \tM[%0d] -> S[%0d] \t request: Address[0x%8h] write Data[0x%8h]",
                             $time, device, addr[ADDR_W - 1: ADDR_W - SLAVE_W] + 1, addr, data);
    
        wait (master_ack[device - 1]);
        @(posedge master_clk[device - 1]);
        
          master_req[device - 1] = 0;
         master_addr[device - 1] = 0;
          master_cmd[device - 1] = 0;
        master_wdata[device - 1] = 0;
    
        $display("time = %0t \tM[%0d] <- S[%0d] \tresponse: Address[0x%8h] write Data[0x%8h]",
                             $time, device, addr[ADDR_W - 1: ADDR_W - SLAVE_W] + 1, addr, data);
    end
endtask           

task automatic read (
                       logic  [MASTER_W: 0] device,
                       addr_t               addr
                     );
    data_t data;
    begin
        @(posedge master_clk[device - 1]);
        
         master_req[device - 1] = 1'b1;
        master_addr[device - 1] = addr;
         master_cmd[device - 1] = 1'b0;
        
        $display("time = %0t \tM[%0d] -> S[%0d] \t request: Address[0x%8h] read",
                             $time, device, addr[ADDR_W - 1: ADDR_W - SLAVE_W] + 1, addr);
    
        wait (master_ack[device - 1]);
        @(posedge master_clk[device - 1]);
        
        data = master_rdata[device - 1];
    
        //@(posedge master_clk[device - 1]);
    
         master_req[device - 1] = 0;
        master_addr[device - 1] = 0;
         master_cmd[device - 1] = 0;      
    
        $display("time = %0t \tM[%0d] <- S[%0d] \tresponse: Address[0x%8h] read  Data[0x%8h]",
                             $time, device, addr[ADDR_W - 1: ADDR_W - SLAVE_W] + 1, addr, data);
    end
endtask 

generate
  for (i = 0; i < SLAVE_N; i = i + 1) begin: vip_slave_gen
      tb_vip_slave vip_slave_gen (
                                     // common interface
                                     .clk           (slave_clk[i]),
                                     .aresetn       (resetn),

                                     // slave interface
                                     .slave_req     (slave_req[i]),
                                     .slave_addr   (slave_addr[i]),
                                     .slave_cmd     (slave_cmd[i]),
                                     .slave_wdata (slave_wdata[i]),
                                     .slave_ack     (slave_ack[i]),
                                     .slave_rdata (slave_rdata[i])
                                  );

  end
endgenerate


//---------------------------------------------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------------------------------------------
cross_bar_mux dut (
                    // mux controller interface
                    .master_mux    (master_mux),
                    .slave_mux     (slave_mux),

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
  wait (resetn);
  repeat (3) @(posedge device_clk);
  
  slave_mux[1] = 3;
  slave_mux[2] = 0;
  slave_mux[3] = 1;
  slave_mux[4] = 2;

  master_mux[1] = 3;
  master_mux[2] = 4;
  master_mux[3] = 1;
  master_mux[4] = 0;
  
  fork
    write(1, 32'ha0000000, 32'hdeadc0de);
    write(2, 32'hd2000004, 32'h0f0f0f0f);
     read(3, 32'h00000000);
  join
  
  #10;
  read(1, 32'ha0000000);
  
  
  #1us;
  $display("\n\n\n\n");
  $display("Test passed!");
  $display("\n\n\n\n");
  $stop;
end  

initial #10 $display("\n\n\n\n");

endmodule
