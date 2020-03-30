echo Cheking Full adder syntax...
ghdl -s Full_adder.vhd
echo Analyzing Full adder...
ghdl -a Full_adder.vhd
echo Analyzing Full adder testbench...
ghdl -s Full_adder_tb.vhd
echo Analyzing Full adder testbench...
ghdl -a Full_adder_tb.vhd

echo Elaborating testbench...
ghdl -e full_adder_tb

echo Running testbench and generate vcd file. Running for 1000ns
ghdl -r full_adder_tb --vcd=full_adder.vcd --stop-time=1000ns

rem In order to open the generated waveform file type:
rem $ gtkwave full_adder.vcd