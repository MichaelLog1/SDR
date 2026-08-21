set_property PACKAGE_PIN U18 [get_ports {CLK_IN_D_0_clk_p[0]}]
set_property PACKAGE_PIN U19 [get_ports {CLK_IN_D_0_clk_n[0]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {CLK_IN_D_0_clk_p[0]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {CLK_IN_D_0_clk_n[0]}]

# 122.88 MHz =  8.138 ns
create_clock -period 8.138 -name adc_clk [get_ports {CLK_IN_D_0_clk_p[0]}]

set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_fpga_0]