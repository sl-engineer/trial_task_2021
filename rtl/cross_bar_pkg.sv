//===============================================================================================================
// Module: cross_bar_pkg.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

package cross_bar_pkg;

parameter MASTER_N = 2;
parameter SLAVE_N  = 2;

parameter ADDR_W   = 32;
parameter DATA_W   = 32;

typedef logic [ADDR_W - 1: 0] addr_t;
typedef logic [DATA_W - 1: 0] data_t;

endpackage

