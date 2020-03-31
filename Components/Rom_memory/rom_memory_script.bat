@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys ROM_memory.vhd
ghdl -s ROM_memory_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys ROM_memory.vhd
ghdl -a ROM_memory_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys rom_memory_tb
echo Running testbench and generate vcd file. Running for 300ns
ghdl -r --ieee=synopsys rom_memory_tb --vcd=rom_memory_tb.vcd --stop-time=300ns

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave rom_memory_tb.vcd