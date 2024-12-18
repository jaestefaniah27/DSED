@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim read_text_behav -key {Behavioral:sim_1:Functional:read_text} -tclbatch read_text.tcl -view C:/Users/SDverisure/Documents/4_TELECO/DSED_github/dsed_croqueta_player/dsed_croqueta_player.srcs/filterBlockTest/tb_RAM_behav.wcfg -view C:/Users/SDverisure/Documents/4_TELECO/DSED_github/dsed_croqueta_player/dsed_croqueta_player.srcs/filterBlockTest/tb_audioSystem_behav.wcfg -view C:/Users/SDverisure/Documents/4_TELECO/DSED_github/dsed_croqueta_player/dsed_croqueta_player.srcs/filterBlockTest/LED_driver_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
