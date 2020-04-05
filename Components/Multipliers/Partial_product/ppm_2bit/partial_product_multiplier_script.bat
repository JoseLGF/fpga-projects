@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 
echo Retrieving dependencies

set name=Half_adder
set source="..\..\..\Adders\Half_adder\Half_adder.vhd"
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
rem ------------ Generate testbench file --------------------------------------
echo Generating testbench file
python "../generate_testbench.py" 2 "gen_partial_product_multiplier_2bit_tb.vhd"

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys Half_adder.vhd
ghdl -s 				partial_product_multiplier_2bit.vhd
ghdl -s 				gen_partial_product_multiplier_2bit_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a 				Half_adder.vhd
ghdl -a --ieee=synopsys partial_product_multiplier_2bit.vhd
ghdl -a --ieee=synopsys gen_partial_product_multiplier_2bit_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys partial_product_2bit_multiplier_tb
echo Running simulation without assert statements. Generateing vcd file.
ghdl -r --ieee=synopsys partial_product_2bit_multiplier_tb --vcd=partial_product_2bit_multiplier_tb.vcd ^
		--stop-time=200ns --assert-level=none
echo Running simulation with assert statements ON.
ghdl -r --ieee=synopsys partial_product_2bit_multiplier_tb ^
		--stop-time=200ns