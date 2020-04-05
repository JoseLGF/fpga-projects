@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 


rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys mac_8_bit_n_samples.vhd
ghdl -s --ieee=synopsys mac_8_bit_n_samples_tb.vhd


rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys mac_8_bit_n_samples.vhd
ghdl -a --ieee=synopsys mac_8_bit_n_samples_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys mac_8bit_nsamples_tb
echo %time% Running testbench and generate vcd file.
ghdl -r --ieee=synopsys mac_8bit_nsamples_tb --vcd=mac_8bit_nsamples_tb.vcd ^
		--stop-time=950ns
echo %time% Simulation completed.

rem ------------ Cleanup ------------------------------------------------------
