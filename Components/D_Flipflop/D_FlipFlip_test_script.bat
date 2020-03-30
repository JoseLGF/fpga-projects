echo Cheking D Flip Flop syntax...
ghdl -s D_FlipFlop.vhd
echo Analyzing D Flip Flop...
ghdl -a D_FlipFlop.vhd
echo Analyzing D_FlipFlop testbench...
ghdl -s D_FlipFlop_tb.vhd
echo Analyzing D_FlipFlop testbench...
ghdl -a D_FlipFlop_tb.vhd

echo Elaborating testbench...
ghdl -e D_FlipFlop_tb

echo Running testbench and generate vcd file. Running for 1000ns
ghdl -r D_FlipFlop_tb --vcd=D_FlipFlop.vcd --stop-time=1000ns

rem In order to open the generated waveform file type:
rem gtkwave D_FlipFlop.vcd