@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies
set name=half_subtractor
set source="..\half_subtractor\half_subtractor.vhd"
set target=".\half_subtractor.vhd"
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
ghdl -s --ieee=synopsys half_subtractor.vhd
ghdl -s --ieee=synopsys full_subtractor.vhd
ghdl -s full_subtractor_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a 				half_subtractor.vhd
ghdl -a --ieee=synopsys full_subtractor.vhd
ghdl -a --ieee=synopsys full_subtractor_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys full_subtractor_tb
echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys full_subtractor_tb --vcd=full_subtractor_tb.vcd ^
		--stop-time=300ns