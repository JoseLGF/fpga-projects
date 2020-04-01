@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys ram_memory.vhd
ghdl -s ram_memory_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys ram_memory.vhd
ghdl -a ram_memory_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys ram_memory_tb
echo Running testbench and generate vcd file. Running for 300ns
ghdl -r --ieee=synopsys ram_memory_tb --vcd=ram_memory_tb.vcd --stop-time=300ns

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave ram_memory_tb.vcd