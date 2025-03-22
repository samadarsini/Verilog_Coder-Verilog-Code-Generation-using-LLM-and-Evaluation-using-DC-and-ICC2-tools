set IP [pwd]
sh rm -Rf ${IP}/build/pnr
file mkdir ${IP}/build/pnr
cd ${IP}/build/pnr

file mkdir outputs
file mkdir reports
file mkdir output_scripts

#put your link and target here

set link_library  \
[ list * /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/lib/stdcell_rvt/db_ccs/saed32rvt_tt1p05v25c.db \
		 ]
set target_library  \
[list   /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/lib/stdcell_rvt/db_ccs/saed32rvt_tt1p05v25c.db \
		 ]
set chip_top "alu"

set route_min_layer M2
set route_max_layer M6

create_lib prototype_${chip_top} -technology /afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/tech/milkyway/saed32nm_1p9m_mw.tf \
     -ref_libs {/afs/umbc.edu/users/w/d/wd70170/home/final_project/alu/GPT4/synopsys32nm_new_ndm-20230208T213226Z-001/synopsys32nm_new_ndm/saed32rvt_tt1p05v25c.ndm}

set gate_verilog "${IP}/asic/${chip_top}/${chip_top}_icc.v" 

set MAP_FILE                      "/afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"  ;#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "/afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "/afs/umbc.edu/software/synopsys/design_kits/synopsys_32_22nm/SAED32_EDK/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus"  ;#  Min TLUplus file

read_parasitic_tech -tlup $TLUPLUS_MAX_FILE  -layermap  $MAP_FILE 
read_parasitic_tech -tlup $TLUPLUS_MIN_FILE  -layermap  $MAP_FILE 

#Read the synthesized verilog and constraint files
read_verilog -top ${chip_top} $gate_verilog

current_design ${chip_top}

read_sdc -version 2.0 ${IP}/asic/${chip_top}/${chip_top}.sdc

save_block -as ${chip_top}_data_setup
save_lib

set_app_option -name time.disable_recovery_removal_checks -value false
set_app_option -name time.disable_case_analysis -value false
group_path -name INPUT  -from [all_inputs]
group_path -name OUTPUT -to   [all_outputs]
group_path -name COMBO -from [all_inputs] -to [all_outputs]
set_host_options -max_cores 20

#Preferred Routing Layers
set_attribute [get_layers M1] routing_direction horizontal
set_attribute [get_layers M2] routing_direction vertical
set_attribute [get_layers M3] routing_direction horizontal
set_attribute [get_layers M4] routing_direction vertical
set_attribute [get_layers M5] routing_direction horizontal
set_attribute [get_layers M6] routing_direction vertical
set_attribute [get_layers M7] routing_direction horizontal
set_attribute [get_layers M8] routing_direction vertical
set_attribute [get_layers M9] routing_direction horizontal
set_attribute [get_layers MRDL] routing_direction vertical

## Floorplanning
initialize_floorplan -core_utilization 0.8 \
        -core_offset {10 10 10 10}				 
place_pins -ports [get_ports *]

connect_pg_net -automatic
check_mv_design

save_block -as ${chip_top}_floorplan

create_placement -floorplan -effort high -timing_driven
legalize_placement
route_global -congestion_map_only true -effort high

save_block -as ${chip_top}_fp_place


connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all

#######################################

create_pg_std_cell_conn_pattern rail_pat -layers {M1}

set_pg_strategy rail_strategy -core -pattern {{name: rail_pat} {nets: {VDD VSS}}}

set_pg_strategy_via_rule rail_via_rule -via_rule \
                         {{intersection: all} {via_master: NIL}}

compile_pg -strategies {rail_strategy} -via_rule rail_via_rule

create_pg_ring_pattern ring_pattern \
    -horizontal_layer M7    -horizontal_width {3} -horizontal_spacing {1.5} \
    -vertical_layer   M8    -vertical_width   {3} -vertical_spacing   {1.5} \

set_pg_strategy core_ring -pattern {{name: ring_pattern} {nets: {VDD VSS}} {offset: {2.5 2.5}}} -core
compile_pg -strategies core_ring

create_pg_mesh_pattern mesh_pattern -layers { \
        {{vertical_layer  : M8}   {width: 2.4} {spacing: interleaving} {pitch: 35}} \
        {{horizontal_layer: M7}   {width: 2.4} {spacing: interleaving} {pitch: 35}}} \
        -via_rule {{{layers: M7} {layers: M8} {via_master: default}} \
        {{intersection: undefined}  {via_master: NIL}}}

set_pg_strategy mesh_strategy -design_boundary -pattern {{name: mesh_pattern} {nets: {VDD VSS}}}

set_pg_strategy_via_rule mesh_std_cell_rails -via_rule { \
        {{{strategies: mesh_strategy} {layers: M7}} \
        {{existing: std_conn} {layers: M1}} {via_master: default}} \
        {{intersection: undefined} {via_master: NIL}}} 

set_pg_strategy_via_rule mesh_via_rule_m7m8_ring -via_rule { \
       {{{strategies: core_ring} {layers: M7}} \
       {{strategies: mesh_strategy} {layers: M8}} {via_master: default}} \
       {{intersection: undefined} {via_master: NIL}} \
                                                       }
set_pg_strategy_via_rule mesh_via_rule_m8m7_ring -via_rule { \
       {{{strategies: core_ring} {layers: M8}} \
       {{strategies: mesh_strategy} {layers: M7}} {via_master: default}} \
       {{intersection: undefined} {via_master: NIL}} \
                                                       }

compile_pg -strategies {mesh_strategy core_ring} -via_rule { mesh_std_cell_rails mesh_via_rule_m7m8_ring mesh_via_rule_m8m7_ring } 

#######################################

check_pg_connectivity -nets "VDD VSS"

save_block -as ${chip_top}_powerplan

set_app_options -name time.disable_recovery_removal_checks -value false
set_app_options -name time.disable_case_analysis -value false
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value place

legalize_placement

set_app_option -name time.snapshot_storage_location -value "./place_rpt"
create_qor_snapshot -name place_qor_snp -significant_digits 4

report_qor_snapshot -name place_qor_snp > reports/place.qor_snapshot.rpt
report_qor > reports/place.qor
report_constraints -all_violators > reports/place.con
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > reports/place.max.tim
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > reports/place.min.tim

save_block -as ${chip_top}_place
save_lib
check_legality  -verbose > reports/place_report.rpt

set_ignored_layers -min_routing_layer ${route_min_layer} -max_routing_layer ${route_max_layer}

set_app_options -name cts.compile.enable_cell_relocation -value all
set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references -value true

set_clock_tree_options    -clocks [all_clocks] \
                          -target_skew 0.08
						  
set_lib_cell_purpose -include cts { IBUFFX2_RVT IBUFFX4_RVT IBUFFX8_RVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT CGLPPSX2_RVT CGLPPSX4_RVT CGLPPSX8_RVT CGLPPSX16_RVT CGLNPSX2_RVT CGLNPSX4_RVT CGLNPSX8_RVT CGLNPSX16_RVT CGLPPRX2_RVT CGLPPRX8_RVT CGLNPRX2_RVT CGLNPRX8_RVT }

set_clock_uncertainty 0.08 [all_clocks]

create_routing_rule CLK_SPACING -spacings {M2 0.3 M3 0.5 M4 0.7 M5 0.9 M6 1.1} 
set_clock_routing_rules -rules CLK_SPACING -min_routing_layer M2 -max_routing_layer M6

report_clock_settings

set_app_options -name opt.common.user_instance_name_prefix -value clock

set_app_option -name time.snapshot_storage_location -value "./clock_rpt"
create_qor_snapshot -name clock_pre_route -significant_digits 4

report_qor_snapshot -name clock_pre_route > reports/clock_pre_route.qor_snapshot.rpt
report_qor > reports/clock_pre_route.qor
report_constraints -all_violators > reports/clock_pre_route.con
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > reports/clock_pre_route.max.tim
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > reports/clock_pre_route.min.tim

connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

save_block -as ${chip_top}_cts
save_lib

create_stdcell_fillers -lib_cells { SHFILL1_RVT SHFILL2_RVT SHFILL3_RVT SHFILL64_RVT SHFILL128_RVT }
connect_pg_net -automatic
remove_stdcell_fillers_with_violation
create_stdcell_fillers -lib_cells { SHFILL1_RVT SHFILL2_RVT SHFILL3_RVT SHFILL64_RVT SHFILL128_RVT }
connect_pg_net -automatic

set_ignored_layers -min_routing_layer  ${route_min_layer} -max_routing_layer ${route_max_layer}
report_ignored_layers

route_auto

connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

optimize_routes -max_detail_route_iterations 2

check_lvs -max_errors 2000

set_app_option -name time.snapshot_storage_location -value "./route_rpt"
create_qor_snapshot -name route -significant_digits 4
report_congestion

write_verilog -include {pg_netlist} outputs/pnr_${chip_top}.v
write_verilog outputs/icc_top.v
set_app_options -list {file.lef.output_non_real_blockages {true}}
create_frame -block_all used_layers
write_lef -design ${chip_top} outputs/${chip_top}.lef
write_default_pg_pattern -type {mesh ring} -output_filename output_scripts/pg_pattern.tcl
write_def -design ${chip_top} -compress none -units 1000 -include_tech_via_definitions -via_as_fixed \
-self_contained -traverse_physical_hierarchy -routed_nets -include_pad_owned_terminals -version 5.7 \
    -bus_delimiters {[]} outputs/${chip_top}.def
write_sdc -output outputs/${chip_top}.sdc
write_gds -library prototype_${chip_top} -design ${chip_top} -units 1000 outputs/${chip_top}.gds
report_qor_snapshot > reports/route.qor_snapshot.rpt
report_qor  > reports/qor.rpt
report_constraint -all_violators > reports/icc_violatios.rpt
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > reports/route.max.tim
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > reports/route.min.tim
report_power > reports/icc_power.rpt
report_attributes -application -class core_area [get_core_area]  > reports/icc_area.rpt

save_block -as ${chip_top}_final
save_lib

report_timing -max_paths 1 -delay_type max -sort_by slack > ${IP}/build/pnr/reports/max_crit_path_for_icc2.txt
report_timing -max_paths 1 -delay_type min -sort_by slack > ${IP}/build/pnr/reports/min_crit_path_for_icc2.txt
report_utilization > ${IP}/build/pnr/reports/utilizatoin_icc2.txt
report_power > ${IP}/build/pnr/reports/power_icc2.txt
report_clock_qor > ${IP}/build/pnr/reports/clock_qor_icc2.txt
report_placement_ir_drop_target > ${IP}/build/pnr/reports/voltage_drop_icc2.txt

write_def -design ${chip_top} ${IP}/asic/${chip_top}/${chip_top}_icc2.def
write_lef -design ${chip_top} ${IP}/asic/${chip_top}/${chip_top}_icc2.lef

quit

