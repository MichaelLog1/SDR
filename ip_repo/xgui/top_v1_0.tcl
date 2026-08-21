# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CIC_DECIMATION_FACTOR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CIC_STAGES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIR_TAPS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIR_TAP_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MIXER_ADC_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MIXER_OUTPUT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NCO_OUTPUT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NCO_P" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NCO_PHASE_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.CIC_DECIMATION_FACTOR { PARAM_VALUE.CIC_DECIMATION_FACTOR } {
	# Procedure called to update CIC_DECIMATION_FACTOR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CIC_DECIMATION_FACTOR { PARAM_VALUE.CIC_DECIMATION_FACTOR } {
	# Procedure called to validate CIC_DECIMATION_FACTOR
	return true
}

proc update_PARAM_VALUE.CIC_STAGES { PARAM_VALUE.CIC_STAGES } {
	# Procedure called to update CIC_STAGES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CIC_STAGES { PARAM_VALUE.CIC_STAGES } {
	# Procedure called to validate CIC_STAGES
	return true
}

proc update_PARAM_VALUE.FIR_TAPS { PARAM_VALUE.FIR_TAPS } {
	# Procedure called to update FIR_TAPS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIR_TAPS { PARAM_VALUE.FIR_TAPS } {
	# Procedure called to validate FIR_TAPS
	return true
}

proc update_PARAM_VALUE.FIR_TAP_WIDTH { PARAM_VALUE.FIR_TAP_WIDTH } {
	# Procedure called to update FIR_TAP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIR_TAP_WIDTH { PARAM_VALUE.FIR_TAP_WIDTH } {
	# Procedure called to validate FIR_TAP_WIDTH
	return true
}

proc update_PARAM_VALUE.MIXER_ADC_WIDTH { PARAM_VALUE.MIXER_ADC_WIDTH } {
	# Procedure called to update MIXER_ADC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIXER_ADC_WIDTH { PARAM_VALUE.MIXER_ADC_WIDTH } {
	# Procedure called to validate MIXER_ADC_WIDTH
	return true
}

proc update_PARAM_VALUE.MIXER_OUTPUT_WIDTH { PARAM_VALUE.MIXER_OUTPUT_WIDTH } {
	# Procedure called to update MIXER_OUTPUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIXER_OUTPUT_WIDTH { PARAM_VALUE.MIXER_OUTPUT_WIDTH } {
	# Procedure called to validate MIXER_OUTPUT_WIDTH
	return true
}

proc update_PARAM_VALUE.N { PARAM_VALUE.N } {
	# Procedure called to update N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N { PARAM_VALUE.N } {
	# Procedure called to validate N
	return true
}

proc update_PARAM_VALUE.NCO_OUTPUT_WIDTH { PARAM_VALUE.NCO_OUTPUT_WIDTH } {
	# Procedure called to update NCO_OUTPUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NCO_OUTPUT_WIDTH { PARAM_VALUE.NCO_OUTPUT_WIDTH } {
	# Procedure called to validate NCO_OUTPUT_WIDTH
	return true
}

proc update_PARAM_VALUE.NCO_P { PARAM_VALUE.NCO_P } {
	# Procedure called to update NCO_P when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NCO_P { PARAM_VALUE.NCO_P } {
	# Procedure called to validate NCO_P
	return true
}

proc update_PARAM_VALUE.NCO_PHASE_WIDTH { PARAM_VALUE.NCO_PHASE_WIDTH } {
	# Procedure called to update NCO_PHASE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NCO_PHASE_WIDTH { PARAM_VALUE.NCO_PHASE_WIDTH } {
	# Procedure called to validate NCO_PHASE_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.NCO_PHASE_WIDTH { MODELPARAM_VALUE.NCO_PHASE_WIDTH PARAM_VALUE.NCO_PHASE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NCO_PHASE_WIDTH}] ${MODELPARAM_VALUE.NCO_PHASE_WIDTH}
}

proc update_MODELPARAM_VALUE.NCO_OUTPUT_WIDTH { MODELPARAM_VALUE.NCO_OUTPUT_WIDTH PARAM_VALUE.NCO_OUTPUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NCO_OUTPUT_WIDTH}] ${MODELPARAM_VALUE.NCO_OUTPUT_WIDTH}
}

proc update_MODELPARAM_VALUE.NCO_P { MODELPARAM_VALUE.NCO_P PARAM_VALUE.NCO_P } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NCO_P}] ${MODELPARAM_VALUE.NCO_P}
}

proc update_MODELPARAM_VALUE.MIXER_ADC_WIDTH { MODELPARAM_VALUE.MIXER_ADC_WIDTH PARAM_VALUE.MIXER_ADC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIXER_ADC_WIDTH}] ${MODELPARAM_VALUE.MIXER_ADC_WIDTH}
}

proc update_MODELPARAM_VALUE.MIXER_OUTPUT_WIDTH { MODELPARAM_VALUE.MIXER_OUTPUT_WIDTH PARAM_VALUE.MIXER_OUTPUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIXER_OUTPUT_WIDTH}] ${MODELPARAM_VALUE.MIXER_OUTPUT_WIDTH}
}

proc update_MODELPARAM_VALUE.CIC_STAGES { MODELPARAM_VALUE.CIC_STAGES PARAM_VALUE.CIC_STAGES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CIC_STAGES}] ${MODELPARAM_VALUE.CIC_STAGES}
}

proc update_MODELPARAM_VALUE.CIC_DECIMATION_FACTOR { MODELPARAM_VALUE.CIC_DECIMATION_FACTOR PARAM_VALUE.CIC_DECIMATION_FACTOR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CIC_DECIMATION_FACTOR}] ${MODELPARAM_VALUE.CIC_DECIMATION_FACTOR}
}

proc update_MODELPARAM_VALUE.FIR_TAPS { MODELPARAM_VALUE.FIR_TAPS PARAM_VALUE.FIR_TAPS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIR_TAPS}] ${MODELPARAM_VALUE.FIR_TAPS}
}

proc update_MODELPARAM_VALUE.FIR_TAP_WIDTH { MODELPARAM_VALUE.FIR_TAP_WIDTH PARAM_VALUE.FIR_TAP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIR_TAP_WIDTH}] ${MODELPARAM_VALUE.FIR_TAP_WIDTH}
}

proc update_MODELPARAM_VALUE.N { MODELPARAM_VALUE.N PARAM_VALUE.N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N}] ${MODELPARAM_VALUE.N}
}

