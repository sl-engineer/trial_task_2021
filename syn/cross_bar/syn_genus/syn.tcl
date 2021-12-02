create_clock [get_ports clk] -name clk -period 2.5

set_clock_uncertainty -setup 0.05 [get_clocks clk] 
set_clock_uncertainty -hold  0.05 [get_clocks clk]

set_input_delay  -clock clk 0.1 [all_inputs]
set_output_delay -clock clk 0.1 [all_outputs]

syn_gen

syn_map

syn_opt

report area
report timing
