rem Set environment variables to define location of
rem LabTools
PATH=%PATH%;C:\Xilinx\14.7\LabTools\LabTools\lib\nt64
set XILINX=C:\Xilinx\14.7\ISE_DS\ISE
REM Upload program HEX using JTAG Loader
JTAG_Loader_Win7_64.exe -l unsigned_multiplier.hex