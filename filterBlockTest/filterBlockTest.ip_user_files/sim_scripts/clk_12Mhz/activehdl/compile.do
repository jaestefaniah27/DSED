vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_clk_wiz.v" \
"../../../../Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.v" \

vlog -work xil_defaultlib \
"glbl.v"

