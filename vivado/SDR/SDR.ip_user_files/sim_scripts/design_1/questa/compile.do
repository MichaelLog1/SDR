vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_11
vlib questa_lib/msim/processing_system7_vip_v1_0_13
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/lib_pkg_v1_0_2
vlib questa_lib/msim/fifo_generator_v13_2_6
vlib questa_lib/msim/lib_fifo_v1_0_15
vlib questa_lib/msim/lib_srl_fifo_v1_0_2
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/axi_datamover_v5_1_27
vlib questa_lib/msim/axi_sg_v4_1_14
vlib questa_lib/msim/axi_dma_v7_1_26
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_25
vlib questa_lib/msim/axi_data_fifo_v2_1_24
vlib questa_lib/msim/axi_crossbar_v2_1_26
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/xlconstant_v1_1_7
vlib questa_lib/msim/axis_infrastructure_v1_1_0
vlib questa_lib/msim/axis_clock_converter_v1_1_26
vlib questa_lib/msim/axi_protocol_converter_v2_1_25

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_11 questa_lib/msim/axi_vip_v1_1_11
vmap processing_system7_vip_v1_0_13 questa_lib/msim/processing_system7_vip_v1_0_13
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap lib_pkg_v1_0_2 questa_lib/msim/lib_pkg_v1_0_2
vmap fifo_generator_v13_2_6 questa_lib/msim/fifo_generator_v13_2_6
vmap lib_fifo_v1_0_15 questa_lib/msim/lib_fifo_v1_0_15
vmap lib_srl_fifo_v1_0_2 questa_lib/msim/lib_srl_fifo_v1_0_2
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap axi_datamover_v5_1_27 questa_lib/msim/axi_datamover_v5_1_27
vmap axi_sg_v4_1_14 questa_lib/msim/axi_sg_v4_1_14
vmap axi_dma_v7_1_26 questa_lib/msim/axi_dma_v7_1_26
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_25 questa_lib/msim/axi_register_slice_v2_1_25
vmap axi_data_fifo_v2_1_24 questa_lib/msim/axi_data_fifo_v2_1_24
vmap axi_crossbar_v2_1_26 questa_lib/msim/axi_crossbar_v2_1_26
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap xlconstant_v1_1_7 questa_lib/msim/xlconstant_v1_1_7
vmap axis_infrastructure_v1_1_0 questa_lib/msim/axis_infrastructure_v1_1_0
vmap axis_clock_converter_v1_1_26 questa_lib/msim/axis_clock_converter_v1_1_26
vmap axi_protocol_converter_v2_1_25 questa_lib/msim/axi_protocol_converter_v2_1_25

vlog -work xilinx_vip -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_11 -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/63b7/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_13 -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \

vlog -work xil_defaultlib -64 -incr -mfcu -sv -L axi_vip_v1_1_11 -L processing_system7_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/f994/src/AXI_adapter.sv" \
"../../../bd/design_1/ipshared/f994/src/AXI_slave.sv" \
"../../../bd/design_1/ipshared/f994/src/CIC.sv" \
"../../../bd/design_1/ipshared/f994/src/DDC.sv" \
"../../../bd/design_1/ipshared/f994/src/FIR.sv" \
"../../../bd/design_1/ipshared/f994/src/NCO.sv" \
"../../../bd/design_1/ipshared/f994/src/mixer.sv" \
"../../../bd/design_1/ipshared/f994/src/top.sv" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_top_0_0/sim/design_1_top_0_0.v" \

vcom -work lib_pkg_v1_0_2 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_6 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_6 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_6 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8ae1/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_15 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/a4ed/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_27 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/9b19/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_14 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/bcf6/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_26 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/69a4/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/design_1/ip/design_1_axi_dma_0_0/sim/design_1_axi_dma_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_25 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/e1e6/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_24 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/fa53/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_26 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/ac57/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xbar_0/sim/design_1_xbar_0.v" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/sim/design_1_rst_ps7_0_50M_0.vhd" \
"../../../bd/design_1/ip/design_1_util_ds_buf_0_0/util_ds_buf.vhd" \
"../../../bd/design_1/ip/design_1_util_ds_buf_0_0/sim/design_1_util_ds_buf_0_0.vhd" \
"../../../bd/design_1/ip/design_1_util_ds_buf_1_0/sim/design_1_util_ds_buf_1_0.vhd" \
"../../../bd/design_1/ip/design_1_proc_sys_reset_0_0/sim/design_1_proc_sys_reset_0_0.vhd" \

vlog -work xlconstant_v1_1_7 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/fcfc/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xlconstant_0_0/sim/design_1_xlconstant_0_0.v" \

vlog -work axis_infrastructure_v1_1_0 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_clock_converter_v1_1_26 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/72b4/hdl/axis_clock_converter_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axis_clock_converter_0_0/sim/design_1_axis_clock_converter_0_0.v" \

vlog -work axi_protocol_converter_v2_1_25 -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../../SDR.gen/sources_1/bd/design_1/ipshared/8fe4/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/3007/hdl" "+incdir+../../../../SDR.gen/sources_1/bd/design_1/ipshared/8713/hdl" "+incdir+/apps/reconfig/tools/Xilinx/Vivado/2021.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_auto_pc_0/sim/design_1_auto_pc_0.v" \
"../../../bd/design_1/ip/design_1_auto_pc_1/sim/design_1_auto_pc_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

