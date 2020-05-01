@echo OFF

rem ------------ Copy dependencies --------------------------------------------

rem ------------ Generated files --------------------------------------

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys debounce.vhd
ghdl -s --ieee=synopsys edge_debounce.vhd
ghdl -s					edge_detector.vhd
ghdl -s 				edge_debounce_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys debounce.vhd
ghdl -a --ieee=synopsys edge_debounce.vhd
ghdl -a					edge_detector.vhd
ghdl -a 				edge_debounce_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys edge_debounce_tb
echo Running simulation without assert statements. Generateing vcd file.
ghdl -r --ieee=synopsys edge_debounce_tb --vcd=edge_debounce_tb.vcd ^
		--stop-time=30ms