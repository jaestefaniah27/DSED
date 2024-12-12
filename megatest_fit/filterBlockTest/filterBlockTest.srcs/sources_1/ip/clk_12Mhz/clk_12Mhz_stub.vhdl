-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Wed Nov 20 11:53:56 2024
-- Host        : PC_CSDVerisure running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {c:/Users/SDverisure/Documents/4
--               TELECO/DSED/Punto_1_test_ok/Punto_1_test_ok/Punto_1_test_ok.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_stub.vhdl}
-- Design      : clk_12Mhz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_12Mhz is
  Port ( 
    clk_12Mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_100Mhz : in STD_LOGIC
  );

end clk_12Mhz;

architecture stub of clk_12Mhz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_12Mhz,reset,clk_100Mhz";
begin
end;
