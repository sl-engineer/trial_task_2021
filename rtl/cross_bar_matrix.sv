//===============================================================================================================
// Module: cross_bar_matrix.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

module cross_bar_matrix
#(
    localparam MASTER_N          = cross_bar_pkg::MASTER_N,
    localparam type master_num_t = cross_bar_pkg::master_num_t
)
(
    // 
    input  master_num_t [MASTER_N - 1: 0]  in_data,
    output master_num_t [MASTER_N - 1: 0]  out_data   
);

import cross_bar_pkg::*;

// generate variable
genvar i;

//---------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------



endmodule

