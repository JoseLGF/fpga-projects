@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies
set name=parallel_adder
set source="..\..\Adders\Parallel_adder\parallel_adder.vhd"
set target=".\parallel_adder.vhd"
if not exist %target% (
	echo Copying %name% component
	if exist %source% (
		copy %source% %target%
	) else (
		echo Error, file not found at %source%
		exit /b 1
	)
)

set name=Half_adder
set source="..\..\Adders\Half_adder\Half_adder.vhd"
set target=".\Half_adder.vhd"
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
ghdl -s --ieee=synopsys Half_adder.vhd
ghdl -s --ieee=synopsys parallel_adder.vhd
ghdl -s 				parallel_subtractor_n_bit.vhd
ghdl -s 				parallel_subtractor_n_bit_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a 				Half_adder.vhd
ghdl -a --ieee=synopsys parallel_adder.vhd
ghdl -a --ieee=synopsys parallel_subtractor_n_bit.vhd
ghdl -a --ieee=synopsys parallel_subtractor_n_bit_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys parallel_subtractor_tb
echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys parallel_subtractor_tb --vcd=parallel_subtractor_tb.vcd ^
		--stop-time=5200ns