// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Wed Nov 20 11:53:56 2024
// Host        : PC_CSDVerisure running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/SDverisure/Documents/4
//               TELECO/DSED/Punto_1_test_ok/Punto_1_test_ok/Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_stub.v}
// Design      : clk_12Mhz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_12Mhz(clk_12Mhz, reset, clk_100Mhz)
/* synthesis syn_black_box black_box_pad_pin="clk_12Mhz,reset,clk_100Mhz" */;
  output clk_12Mhz;
  input reset;
  input clk_100Mhz;
endmodule
