set_property SRC_FILE_INFO {cfile:{c:/Users/SDverisure/Documents/4 TELECO/DSED/Punto_1_test_ok/Punto_1_test_ok/Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.xdc} rfile:../../../Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_100Mhz]] 0.1
