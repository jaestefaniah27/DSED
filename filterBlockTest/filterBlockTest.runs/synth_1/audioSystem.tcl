# 
# Synthesis run script generated by Vivado
# 

set_msg_config  -ruleid {1}  -id {Project 1-311}  -new_severity {ADVISORY} 
set_msg_config  -ruleid {2}  -id {Project 1-311}  -suppress 
set_msg_config  -ruleid {3}  -id {Labtools 27-3361}  -suppress 
set_msg_config  -ruleid {4}  -id {Project 1-19}  -suppress 
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.cache/wt [current_project]
set_property parent.project_path C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/imports/new/gen_enables.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/imports/new/packageDSED.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/imports/new/inputMicrophone.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/outputMicrophone.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/audioInterface.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/simpleAudioSystem.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/coefSelector.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/sampleRegister.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/fir5stage.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/mux8_1.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/contador_3bits.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/mul.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/filterBlock.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/controller.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/audioSystem.vhd
  C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/new/LED_driver.vhd
}
read_ip -quiet C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.xci
set_property used_in_implementation false [get_files -all c:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.xdc]
set_property used_in_implementation false [get_files -all c:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_ooc.xdc]
set_property is_locked true [get_files C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz.xci]

read_ip -quiet C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci
set_property used_in_implementation false [get_files -all c:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc]
set_property is_locked true [get_files C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/constrs_1/imports/DSED/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files C:/Users/SDverisure/Documents/4_TELECO/DSED_github/DSED/filterBlockTest/filterBlockTest.srcs/constrs_1/imports/DSED/Nexys4DDR_Master.xdc]


synth_design -top audioSystem -part xc7a100tcsg324-1


write_checkpoint -force -noxdef audioSystem.dcp

catch { report_utilization -file audioSystem_utilization_synth.rpt -pb audioSystem_utilization_synth.pb }
