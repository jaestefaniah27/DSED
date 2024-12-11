-makelib ies/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies/xpm \
  "C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_clk_wiz.v" \
  "../../../../Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

