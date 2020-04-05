@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies
if not exist ".\half_subtractor\half_subtractor.vhd" (
	echo Copying half subtractor component...
	copy "..\half_subtractor\half_subtractor.vhd" ".\half_subtractor.vhd"
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


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys full_subtractor_tb
echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys full_subtractor_tb --vcd=full_subtractor_tb.vcd ^
		--stop-time=300ns