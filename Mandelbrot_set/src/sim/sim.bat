@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Components syntax...
ghdl -s --ieee=synopsys ../hdl/vga_640x480.vhd
ghdl -s --ieee=synopsys ../hdl/pixel_manager.vhd
ghdl -s --ieee=synopsys ../hdl/Top.vhd
ghdl -s --ieee=synopsys ../hdl/ROM.vhd
ghdl -s --ieee=synopsys Top_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing components...
ghdl -a --ieee=synopsys ../hdl/vga_640x480.vhd
ghdl -a --ieee=synopsys ../hdl/pixel_manager.vhd
ghdl -a --ieee=synopsys ../hdl/Top.vhd
ghdl -a --ieee=synopsys ../hdl/ROM.vhd
ghdl -a --ieee=synopsys Top_tb.vhd


rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench...
ghdl -e --ieee=synopsys Top_tb
echo Running testbench and generate vcd file.
ghdl -r --ieee=synopsys Top_tb --vcd=Top_tb.vcd --stop-time=18ms --read-wave-opt=wave.opt

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave rom_memory_tb.vcd