@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies
if not exist ".\parallel_adder.vhd" (
	echo Copying parallel adder component...
	copy "..\..\Adders\Parallel_adder\parallel_adder.vhd" ".\parallel_adder.vhd"
)

if not exist ".\Half_adder.vhd" (
	echo Copying half adder component...
	copy "..\..\Adders\Half_adder\Half_adder.vhd" ".\Half_adder.vhd"
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

rem ------------ Cleanup ------------------------------------------------------


pause
rem In order to open the generated waveform file type:
rem gtkwave full_subtractor_tb.vcd