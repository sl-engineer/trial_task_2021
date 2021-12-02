set design_name syn_wrp
set_db information_level 3

set_db library { ../../lib/mkcmos090rhbdstdPwcsV108T125C.lib }

read_hdl -sv ../../../rtl/cross_bar_pkg.sv
read_hdl -sv ../../../rtl/cross_bar_top.sv
read_hdl -sv ../../../rtl/cross_bar_rr_arbiter.sv
read_hdl -sv ../../../rtl/cross_bar_master.sv
read_hdl -sv ../../../rtl/cross_bar_slave.sv
read_hdl -sv ../syn_wrp.sv

set_db lp_insert_clock_gating false

elaborate $design_name
