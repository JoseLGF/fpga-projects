@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys vga_640x480.vhd
ghdl -s vga_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys vga_640x480.vhd
ghdl -a vga_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys vga_test
echo Running testbench and generate vcd file. Running for 300ns
ghdl -r --ieee=synopsys vga_test --vcd=vga_test.vcd --stop-time=40ms --read-wave-opt=wave.opt

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave rom_memory_tb.vcd