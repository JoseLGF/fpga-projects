@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies

set name=n bit register
set source="..\..\Registers\n_bit_register\n_bit_register.vhd"
set target=".\n_bit_register.vhd"
if not exist %target% (
	echo Copying %name% component
	if exist %source% (
		copy %source% %target%
	) else (
		echo Error, file not found at %source%
		exit /b 1
	)
)

rem ------------ Generated files --------------------------------------


rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys n_bit_register.vhd
ghdl -s --ieee=synopsys fir_filter.vhd
ghdl -s 				fir_filter_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys n_bit_register.vhd
ghdl -a --ieee=synopsys fir_filter.vhd
ghdl -a 				fir_filter_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys fir_filter_tb
echo Running simulation without assert statements. Generateing vcd file.
ghdl -r --ieee=synopsys fir_filter_tb --vcd=fir_filter_tb.vcd ^
		--stop-time=70000ns --assert-level=none
echo Running simulation with assert statements ON.
ghdl -r --ieee=synopsys fir_filter_tb ^
		--stop-time=70000ns