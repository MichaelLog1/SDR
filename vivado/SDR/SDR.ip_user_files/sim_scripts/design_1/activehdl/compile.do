vlib work
vlib activehdl

vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_vip_v1_1_11
vlib activehdl/processing_system7_vip_v1_0_13
vlib activehdl/xil_defaultlib
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/fifo_generator_v13_2_6
vlib activehdl/lib_fifo_v1_0_15
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/axi_datamover_v5_1_27
vlib activehdl/axi_sg_v4_1_14
vlib activehdl/axi_dma_v7_1_26
vlib activehdl/generic_baseblocks_v2_1_0
vlib activehdl/axi_register_slice_v2_1_25
vlib activehdl/axi_data_fifo_v2_1_24
vlib activehdl/axi_crossbar_v2_1_26
vlib activehdl/proc_sys_reset_v5_0_13
vlib activehdl/axis_infrastructure_v1_1_0
vlib activehdl/axis_clock_converter_v1_1_26
vlib activehdl/xlconstant_v1_1_7
vlib activehdl/axi_protocol_converter_v2_1_25

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_11 activehdl/axi_vip_v1_1_11
vmap processing_system7_vip_v1_0_13 activehdl/processing_system7_vip_v1_0_13
vmap xil_defaultlib activehdl/xil_defaultlib
vmap lib_pkg_v1_0_2 activehdl/lib_pkg_v1_0_2
vmap fifo_generator_v13_2_6 activehdl/fifo_generator_v13_2_6
vmap lib_fifo_v1_0_15 activehdl/lib_fifo_v1_0_15
vmap lib_srl_fifo_v1_0_2 activehdl/lib_srl_fifo_v1_0_2
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap axi_datamover_v5_1_27 activehdl/axi_datamover_v5_1_27
vmap axi_sg_v4_1_14 activehdl/axi_sg_v4_1_14
vmap axi_dma_v7_1_26 activehdl/axi_dma_v7_1_26
vmap generic_baseblocks_v2_1_0 activehdl/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_25 activehdl/axi_register_slice_v2_1_25
vmap axi_data_fifo_v2_1_24 activehdl/axi_data_fifo_v2_1_24
vmap axi_crossbar_v2_1_26 activehdl/axi_crossbar_v2_1_26
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13
vmap axis_infrastructure_v1_1_0 activehdl/axis_infrastructure_v1_1_0
vmap axis_clock_converter_v1_1_26 activehdl/axis_clock_converter_v1_1_26
vmap xlconstant_v1_1_7 activehdl/xlconstant_v1_1_7
vmap axi_protocol_converter_v2_1_25 activehdl/axi_protocol_converter_v2_1_25

vlog -work xilinx_vip  -sv2k12 "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_11  -sv2k12 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/63b7/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_13  -sv2k12 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_6  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_6 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_6  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_15 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/a4ed/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_27 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/9b19/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_14 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/bcf6/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_26 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/69a4/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_axi_dma_0_0/sim/design_1_axi_dma_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_25  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/e1e6/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_24  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/fa53/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_26  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ac57/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xbar_0/sim/design_1_xbar_0.v" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/sim/design_1_rst_ps7_0_50M_0.vhd" \
"../../../bd/design_1/ip/design_1_util_ds_buf_0_0/util_ds_buf.vhd" \
"../../../bd/design_1/ip/design_1_util_ds_buf_0_0/sim/design_1_util_ds_buf_0_0.vhd" \
"../../../bd/design_1/ip/design_1_proc_sys_reset_0_0/sim/design_1_proc_sys_reset_0_0.vhd" \

vlog -work axis_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_clock_converter_v1_1_26  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/72b4/hdl/axis_clock_converter_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axis_clock_converter_0_0/sim/design_1_axis_clock_converter_0_0.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \

vlog -work xlconstant_v1_1_7  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/fcfc/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xlconstant_0_1/sim/design_1_xlconstant_0_1.v" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/79c9/src/AXI_adapter.sv" \
"../../../bd/design_1/ipshared/79c9/src/AXI_slave.sv" \
"../../../bd/design_1/ipshared/79c9/src/CIC.sv" \
"../../../bd/design_1/ipshared/79c9/src/DDC.sv" \
"../../../bd/design_1/ipshared/79c9/src/FIR.sv" \
"../../../bd/design_1/ipshared/79c9/src/NCO.sv" \
"../../../bd/design_1/ipshared/79c9/src/mixer.sv" \
"../../../bd/design_1/ipshared/79c9/src/top.sv" \
"../../../bd/design_1/ip/design_1_top_0_0/sim/design_1_top_0_0.sv" \

vlog -work axi_protocol_converter_v2_1_25  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8fe4/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/62b6" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_auto_pc_0/sim/design_1_auto_pc_0.v" \
"../../../bd/design_1/ip/design_1_auto_pc_1/sim/design_1_auto_pc_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

