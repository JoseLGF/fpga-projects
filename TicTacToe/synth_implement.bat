@echo OFF

call C:/Xilinx/Vivado/2018.2/settings64.bat

echo compile, synthesize, implement, and generate bitstream
call vivado -mode batch -source synth_imp_bitstr.tcl || exit /B 1

echo Generation completed