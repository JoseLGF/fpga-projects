@echo OFF

rem ------------ Copy dependencies --------------------------------------------
echo Searching for dependencies
if not exist ".\Full_adder.vhd" (
	echo Copying Full adder component...
	if exist "..\Full_adder\Full_adder.vhd" (
		copy "..\Full_adder\Full_adder.vhd" ".\Full_adder.vhd"
	) else (
		echo Error, file not found.
		exit /b 1
	)
)

rem ------------ Check sources syntax -----------------------------------------
echo Checking Component files syntax...

ghdl -s  parallel_adder.vhd
ghdl -s --ieee=synopsys parallel_adder_tb.vhd

ghdl -s  Full_adder.vhd


rem ------------ Analyze components -------------------------------------------
echo Analyzing component files...

ghdl -a parallel_adder.vhd
ghdl -a parallel_adder_tb.vhd

ghdl -a Full_adder.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench files...

ghdl -e parallel_adder_tb

echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys parallel_adder_tb --vcd=parallel_adder_tb.vcd --stop-time=5200ns
