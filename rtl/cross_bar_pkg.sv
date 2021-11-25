//===============================================================================================================
// Module: cross_bar_pkg.sv
// Author: Viacheslav Tarasov
// email: sl-engineer@protonmail.com
//===============================================================================================================

package cross_bar_pkg;

parameter MASTER_N = 4;                  // Number of master devices
                                         // ! must be at least 2!
                     
parameter MASTER_W = $clog2(MASTER_N);   // Width address bus of master devices
 
parameter SLAVE_N  = 4;                  // Number of slave devices
                                         // 
                     
parameter SLAVE_W  = $clog2(SLAVE_N);    // Width address bus of slave devices

parameter ADDR_W   = 32;
parameter DATA_W   = 32;

typedef logic [ADDR_W - 1: 0] addr_t;
typedef logic [DATA_W - 1: 0] data_t;

typedef  logic     [SLAVE_N - 1: 0]  sgrant_t;
typedef  sgrant_t [MASTER_N - 1: 0] msgrant_t;
endpackage

