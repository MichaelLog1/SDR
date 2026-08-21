set_property PACKAGE_PIN U18 [get_ports {CLK_IN_D_0_clk_p[0]}]
set_property PACKAGE_PIN U19 [get_ports {CLK_IN_D_0_clk_n[0]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {CLK_IN_D_0_clk_p[0]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {CLK_IN_D_0_clk_n[0]}]

# 122.88 MHz =  8.138 ns
create_clock -period 8.138 -name adc_clk [get_ports {CLK_IN_D_0_clk_p[0]}]

set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_fpga_0]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks adc_clk] -group [get_clocks -include_generated_clocks clk_fpga_0]

# adc data, retrieved from red pitaya example
set_property IOSTANDARD LVCMOS18 [get_ports {adc_dat_i[*]}]
set_property IOB        TRUE     [get_ports {adc_dat_i[*]}]

set_property PACKAGE_PIN V17 [get_ports {adc_dat_i[0]}]
set_property PACKAGE_PIN U17 [get_ports {adc_dat_i[1]}]
set_property PACKAGE_PIN Y17 [get_ports {adc_dat_i[2]}]
set_property PACKAGE_PIN W16 [get_ports {adc_dat_i[3]}]
set_property PACKAGE_PIN Y16 [get_ports {adc_dat_i[4]}]
set_property PACKAGE_PIN W15 [get_ports {adc_dat_i[5]}]
set_property PACKAGE_PIN W14 [get_ports {adc_dat_i[6]}]
set_property PACKAGE_PIN Y14 [get_ports {adc_dat_i[7]}]
set_property PACKAGE_PIN W13 [get_ports {adc_dat_i[8]}]
set_property PACKAGE_PIN V12 [get_ports {adc_dat_i[9]}]
set_property PACKAGE_PIN V13 [get_ports {adc_dat_i[10]}]
set_property PACKAGE_PIN T14 [get_ports {adc_dat_i[11]}]
set_property PACKAGE_PIN T15 [get_ports {adc_dat_i[12]}]
set_property PACKAGE_PIN V15 [get_ports {adc_dat_i[13]}]
set_property PACKAGE_PIN T16 [get_ports {adc_dat_i[14]}]
set_property PACKAGE_PIN V16 [get_ports {adc_dat_i[15]}]

set_input_delay -clock adc_clk 6.000 [get_ports {adc_dat_i[*]}]

set_property IOSTANDARD LVCMOS18 [get_ports {adc_clk_o[*]}]
set_property SLEW       FAST     [get_ports {adc_clk_o[*]}]
set_property DRIVE      8        [get_ports {adc_clk_o[*]}]
set_property PACKAGE_PIN N20     [get_ports {adc_clk_o[0]}]
set_property PACKAGE_PIN P20     [get_ports {adc_clk_o[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports adc_cdcs_o]
set_property SLEW       FAST     [get_ports adc_cdcs_o]
set_property DRIVE      8        [get_ports adc_cdcs_o]
set_property PACKAGE_PIN V18     [get_ports adc_cdcs_o]