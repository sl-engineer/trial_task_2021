//===============================================================================================================
// Module: cross_bar_rr_arbiter.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_rr_arbiter
#(
    localparam MASTER_N    = cross_bar_pkg::MASTER_N // must be at least 2
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

logic [MASTER_N - 1: 0] rotate_ptr;
logic [MASTER_N - 1: 0] mask_req;
logic [MASTER_N - 1: 0] mask_grant;
logic [MASTER_N - 1: 0] grant_comb;
logic                   nomask_req;
logic [MASTER_N - 1: 0] nomask_grant;
logic                   update_ptr;

// generate variable
genvar i;

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
  for (i = 2; i < MASTER_N; i = i + 1) begin: rotate_ptr_gen
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
  for (i = 1; i < MASTER_N; i = i + 1) begin: mask_grant_gen
      assign mask_grant[i] = (~(|mask_req[i - 1: 0])) & mask_req[i];
  end
endgenerate

//---------------------------------------------------------------------------------------------------------------
// nomask grant logic
//---------------------------------------------------------------------------------------------------------------
assign nomask_grant[0] = req[0];

generate
  for (i = 1; i < MASTER_N; i = i + 1) begin: nomask_grant_gen
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
  else
      grant[MASTER_N - 1: 0] <= grant_comb[MASTER_N - 1: 0] & ~grant[MASTER_N - 1: 0];


endmodule
