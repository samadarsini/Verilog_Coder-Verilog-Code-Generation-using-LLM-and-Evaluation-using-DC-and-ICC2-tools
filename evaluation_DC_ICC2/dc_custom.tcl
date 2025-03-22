set top_mod "alu"
sh mkdir -p asic
sh mkdir -p asic/${top_mod}/reports

# Formality output file used for Formal Verification
set_svf "asic/${top_mod}/${top_mod}.svf";

# Set library paths
set search_path "$search_path /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/lib/stdcell_rvt/db_ccs/"
set search_path "$search_path /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/"
set search_path "$search_path /afs/umbc.edu/users/w/d/wd70170/home/final_project/alu/GPT4"
set rvt_library " /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/lib/stdcell_rvt/db_ccs/saed32rvt_tt1p05v25c.db"

set link_library "$rvt_library"
set target_library "$rvt_library"

create_mw_lib "asic/${top_mod}/${top_mod}" -technology /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/tech/milkyway/saed32nm_1p9m_mw.tf -mw_reference_library { /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m }

open_mw_lib "asic/${top_mod}/${top_mod}"

set_host_options -max_cores 10

define_design_lib work -path asic/${top_mod}/work


analyze -define {ASIC=1} -f sverilog -library work "${top_mod}.v"

elaborate -library work ${top_mod}
create_clock -name clk -period 2.01 clk
# Adding clock uncertainty constraint
set_clock_uncertainty 0.1 [get_clocks clk]

# Adding input, output delay constraint
set_input_delay 0.1 -clock [get_clocks clk] [all_inputs]; set_output_delay 0.1 -clock [get_clocks clk] [all_outputs]

compile_ultra

#finding capacitance at the output pin
set dff_load [get_attribute [get_pins FP_R_reg[1]/D] actual_pin_cap_max]
#setting four load capacitances for all outputs
set_load [expr {$dff_load*4} ] [all_outputs]
uniquify

write -hierarchy -format verilog -output asic/${top_mod}/${top_mod}_icc.v ${top_mod}
write_sdc asic/${top_mod}/${top_mod}.sdc

change_names -rules verilog -hierarchy
write_sdf -significant_digits 13 asic/${top_mod}/${top_mod}.sdf

report_constraint -all_violators > asic/${top_mod}/reports/dc_constraint.txt
report_area > asic/${top_mod}/reports/dc_area.txt
report_power > asic/${top_mod}/reports/dc_power.txt
report_timing -delay_type max > asic/${top_mod}/reports/maximum_critical_path.txt
report_timing -delay_type min > asic/${top_mod}/reports/minimum_critical_path.txt
quit
