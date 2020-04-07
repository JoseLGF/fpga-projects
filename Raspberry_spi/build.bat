@echo OFF

call C:/Xilinx/Vivado/2018.2/settings64.bat

echo Generating project
call vivado -mode batch -source build.tcl || exit /B 1

echo compile, synthesize, implement, and generate bitstream
call vivado -mode batch -source synth_imp_bitstr.tcl || exit /B 1

echo Generation completed
copy ".\work\Raspberry_spi\Raspberry_spi.runs\impl_1\Rpi_Spi_Top.bit" ".\work\bitstream\Rpi_Spi_Top.bit"
echo Bitstream file copied to ".\work\bitstream\Rpi_Spi_Top.bit"