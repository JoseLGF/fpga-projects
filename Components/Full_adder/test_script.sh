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

echo Running testbench and generate vcd file
ghdl -r --vcd=full_adder.vcd full_adder_tb
