@echo OFF

call C:/Xilinx/Vivado/2018.2/settings64.bat

echo Generating project
call vivado -mode batch -source build.tcl || exit /B 1

echo Project Generation completed