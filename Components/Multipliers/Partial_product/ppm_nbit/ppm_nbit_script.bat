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

set name=Full_adder
set source="..\..\..\Adders\Full_adder\Full_adder.vhd"
set target=".\Full_adder.vhd"
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
echo Generating component file
python "./generate_ppm_nbit.py" 4 "gen_ppm_4bit.vhd"
echo Generating testbench file
python "../generate_testbench.py" 4 "gen_partial_product_multiplier_4bit_tb.vhd"


rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys Half_adder.vhd
ghdl -s --ieee=synopsys Full_adder.vhd
ghdl -s 				gen_ppm_4bit.vhd
ghdl -s 				gen_partial_product_multiplier_4bit_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a 				Half_adder.vhd
ghdl -a 				Full_adder.vhd
ghdl -a --ieee=synopsys gen_ppm_4bit.vhd
ghdl -a --ieee=synopsys gen_partial_product_multiplier_4bit_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys partial_product_4bit_multiplier_tb
echo Running simulation without assert statements. Generateing vcd file.
ghdl -r --ieee=synopsys partial_product_4bit_multiplier_tb --vcd=gen_partial_product_multiplier_4bit_tb.vcd ^
		--stop-time=6000ns --assert-level=none
echo Running simulation with assert statements ON.
ghdl -r --ieee=synopsys partial_product_4bit_multiplier_tb ^
		--stop-time=6000ns