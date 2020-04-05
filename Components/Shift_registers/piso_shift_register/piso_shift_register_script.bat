@echo OFF

rem ------------ Copy dependencies --------------------------------------------
echo Searching for dependencies
if not exist ".\D_FlipFlop.vhd" (
	echo Copying D Flip Flop component
	copy "..\..\D_Flipflop\D_FlipFlop.vhd" ".\D_FlipFlop.vhd"
)

rem ------------ Check sources syntax -----------------------------------------
echo Checking Component files syntax...

ghdl -s  mux_2in_1out.vhd
ghdl -s  mux_2in_1out_tb.vhd

ghdl -s  D_FlipFlop.vhd

ghdl -s  piso_shift_register.vhd
ghdl -s  piso_shift_register_tb.vhd
rem ghdl -s --ieee=synopsys Half_adder_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing component files...

ghdl -a mux_2in_1out.vhd
ghdl -a mux_2in_1out_tb.vhd

ghdl -a D_FlipFlop.vhd

ghdl -a piso_shift_register.vhd
ghdl -a piso_shift_register_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench files...

ghdl -e mux_2in_1out_tb
ghdl -e piso_shift_register_tb

echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys mux_2in_1out_tb --vcd=mux_2in_1out_tb.vcd --stop-time=100ns
ghdl -r --ieee=synopsys piso_shift_register_tb --vcd=piso_shift_register_tb.vcd --stop-time=300ns

rem ------------ Cleanup ------------------------------------------------------
echo Removing dependencies
del  ".\D_FlipFlop.vhd"