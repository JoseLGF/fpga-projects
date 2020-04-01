@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys Half_adder.vhd
ghdl -s Half_adder_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys Half_adder.vhd
ghdl -a Half_adder_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys half_adder_tb
echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys half_adder_tb --vcd=half_adder_tb.vcd --stop-time=300ns

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave half_adder_tb.vcd