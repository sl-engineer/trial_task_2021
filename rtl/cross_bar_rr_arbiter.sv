//===============================================================================================================
// Module: cross_bar_rr_arbiter.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_rr_arbiter
#(
    localparam MASTER_N = cross_bar_pkg::MASTER_N // must be at least 2
)
(
    // clk and asynchronus negative reset
    input  logic                   clk,
    input  logic                   aresetn,

    // req and grant interface
    input  logic [MASTER_N - 1: 0] req,
    output logic [MASTER_N - 1: 0] grant

);

import cross_bar_pkg::*;

//---------------------------------------------------------------------------------------------------------------
// inner signals
//---------------------------------------------------------------------------------------------------------------
logic [MASTER_N - 1: 0] rotate_ptr;
logic [MASTER_N - 1: 0] mask_req;
logic [MASTER_N - 1: 0] mask_grant;
logic [MASTER_N - 1: 0] grant_comb;
logic                   nomask_req;
logic [MASTER_N - 1: 0] nomask_grant;
logic                   update_ptr;

//---------------------------------------------------------------------------------------------------------------
// sync and fall edge impulse logic
//---------------------------------------------------------------------------------------------------------------
logic [MASTER_N - 1: 0] rsync0;
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      rsync0 <= {MASTER_N{1'b0}};
  else
      rsync0 <= req;

logic [MASTER_N - 1: 0] rsync1;
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      rsync1 <= {MASTER_N{1'b0}};
  else
      rsync1 <= rsync0;

logic [MASTER_N - 1: 0] rsync2;
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      rsync2 <= {MASTER_N{1'b0}};
  else
      rsync2 <= rsync1;

logic [MASTER_N - 1: 0] rsync;     
assign rsync = ~rsync1 & rsync2;              // set impulse when req[x] = 1 => to req[x] = 0

//---------------------------------------------------------------------------------------------------------------
// sync and rise edge impulse logic
//---------------------------------------------------------------------------------------------------------------
logic lsync0;
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      lsync0 <= 1'b0;
  else
      lsync0 <= |req;

logic lsync1;
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      lsync1 <= 1'b0;
  else
      lsync1 <= lsync0;

logic lsync2;      
always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      lsync2 <= 1'b0;
  else
      lsync2 <= lsync1;

logic  lsync;              
assign lsync = lsync1 & ~lsync2;              // set impulse when |req = 0 -> to |req = 1

//---------------------------------------------------------------------------------------------------------------
// roll logic
//---------------------------------------------------------------------------------------------------------------
logic  roll; 
assign roll = |rsync | lsync;

//---------------------------------------------------------------------------------------------------------------
// rotate pointer update logic
//---------------------------------------------------------------------------------------------------------------
assign update_ptr = |grant[MASTER_N - 1: 0];

always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
  begin
      rotate_ptr[0] <= 1'b1;
      rotate_ptr[1] <= 1'b1;
  end
  else if (update_ptr)
  begin
      rotate_ptr[0] <= grant[MASTER_N - 1];
      rotate_ptr[1] <= grant[MASTER_N - 1] | grant[0];
  end

generate
  for (genvar i = 2; i < MASTER_N; i = i + 1) begin: rotate_ptr_gen
      always_ff @(posedge clk or negedge aresetn)
        if (!aresetn)
            rotate_ptr[i] <= 1'b1;
        else if (update_ptr)
            rotate_ptr[i] <= grant[MASTER_N - 1] | (|grant[i - 1: 0]);
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// mask req and mask grant logic 
//---------------------------------------------------------------------------------------------------------------
assign mask_req[MASTER_N - 1: 0] = req[MASTER_N - 1: 0] & rotate_ptr[MASTER_N - 1: 0];

assign mask_grant[0] = mask_req[0];

generate
  for (genvar i = 1; i < MASTER_N; i = i + 1) begin: mask_grant_gen
      assign mask_grant[i] = (~(|mask_req[i - 1: 0])) & mask_req[i];
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// nomask grant logic
//---------------------------------------------------------------------------------------------------------------
assign nomask_grant[0] = req[0];

generate
  for (genvar i = 1; i < MASTER_N; i = i + 1) begin: nomask_grant_gen
      assign nomask_grant[i] = (~(|req[i - 1: 0])) & req[i];
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// grant logic
//---------------------------------------------------------------------------------------------------------------
assign nomask_req = ~(|mask_req[MASTER_N - 1: 0]);

assign grant_comb[MASTER_N - 1: 0] = mask_grant[MASTER_N - 1: 0] | 
                                  (nomask_grant[MASTER_N - 1: 0] & {MASTER_N{nomask_req}});

always_ff @(posedge clk or negedge aresetn)
  if (!aresetn)
      grant[MASTER_N - 1: 0] <= {MASTER_N{1'b0}};
  else if (roll)
      grant[MASTER_N - 1: 0] <= grant_comb[MASTER_N - 1: 0] & ~grant[MASTER_N - 1: 0];


endmodule
