@echo OFF

rem ------------ Copy dependencies --------------------------------------------
echo Copying D Flip Flop component
set name=D Flip Flop
set source="..\..\D_Flipflop\D_FlipFlop.vhd"
set target=".\D_FlipFlop.vhd"
if not exist %target% (
	echo Copying %name% component
	if exist %source% (
		copy %source% %target%
	) else (
		echo Error, file not found at %source%
		exit /b 1
	)
)

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s D_FlipFlop.vhd
ghdl -s sipo_shift_register.vhd
ghdl -s sipo_shift_register_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a D_FlipFlop.vhd
ghdl -a sipo_shift_register.vhd
ghdl -a sipo_shift_register_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e sipo_shift_register_tb
echo Running testbench and generate vcd file. Running for 1000ns
ghdl -r sipo_shift_register_tb --vcd=sipo_shift_register_tb.vcd --stop-time=1000ns

rem ------------ Cleanup ------------------------------------------------------
echo Deleting local dependency files
del ".\D_FlipFlop.vhd"
