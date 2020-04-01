@echo OFF

rem ------------ Copy dependencies -------------------------------------------- 

rem ------------ Check sources syntax -----------------------------------------
echo Checking Component files syntax...
ghdl -s  mux_2in_1out.vhd
ghdl -s  mux_2in_1out_tb.vhd
rem ghdl -s --ieee=synopsys Half_adder_tb.vhd

rem ------------ Analyze components -------------------------------------------
echo Analyzing component files...
ghdl -a mux_2in_1out.vhd
ghdl -a mux_2in_1out_tb.vhd

rem ------------ Elaborate and run testbench ----------------------------------
echo Elaborating testbench files...
ghdl -e mux_2in_1out_tb
echo Running testbench and generate vcd file. Running for 100ns
ghdl -r --ieee=synopsys mux_2in_1out_tb --vcd=mux_2in_1out_tb.vcd --stop-time=100ns

rem ------------ Cleanup ------------------------------------------------------


rem In order to open the generated waveform file type:
rem gtkwave half_adder_tb.vcd