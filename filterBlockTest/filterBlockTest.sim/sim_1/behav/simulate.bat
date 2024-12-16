@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim LED_driver_tb_behav -key {Behavioral:sim_1:Functional:LED_driver_tb} -tclbatch LED_driver_tb.tcl -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED_2_porque_DSED_no_funca/DSED/filterBlockTest/tb_RAM_behav.wcfg -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED_2_porque_DSED_no_funca/DSED/filterBlockTest/tb_audioSystem_behav.wcfg -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED_2_porque_DSED_no_funca/DSED/filterBlockTest/LED_driver_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
