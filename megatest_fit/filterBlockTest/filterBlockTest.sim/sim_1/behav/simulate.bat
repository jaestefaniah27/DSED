@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim tb_RAM_behav -key {Behavioral:sim_1:Functional:tb_RAM} -tclbatch tb_RAM.tcl -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED/megatest_fit/megatest_fit/tb_fir5stage_behav.wcfg -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED/megatest_fit/megatest_fit/tb_firterBlock_behav.wcfg -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED/megatest_fit/filterBlockTest/tb_RAM_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
