@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim tb_controller_behav -key {Behavioral:sim_1:Functional:tb_controller} -tclbatch tb_controller.tcl -view C:/Users/jaest/OneDrive/Documentos/4_TELECO/DSED/proyecto_dsed_github/DSED/filterBlockTest/tb_RAM_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
