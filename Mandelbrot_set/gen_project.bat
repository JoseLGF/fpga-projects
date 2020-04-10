@echo OFF

rem sets up the environment variables to properly open vivado in batch mode.
call C:/Xilinx/Vivado/2018.2/settings64.bat

echo Generating project
call vivado -mode batch -source gen_project.tcl || exit /B 1

echo Project Generation completed