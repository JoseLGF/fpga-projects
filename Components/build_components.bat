@echo OFF

echo ====Building component Full Adder
cd ".\Adders\Full_adder"
call test_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component Half Adder
cd ".\Adders\Half_adder"
call Half_adder_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component Parallel Adder
cd ".\Adders\Parallel_adder"
call parallel_adder_script.bat || exit /B 1
echo Building component Finished
cd "..\..\"

echo ====Building component D Flip Flop
cd ".\D_Flipflop"
call D_FlipFlip_test_script.bat
echo Building component Finished
cd "..\"

echo ====Building component MAC
cd ".\MAC"
call mac_8_bit_n_samples_script.bat
echo Building component Finished
cd "..\"

echo ====Building component Ram_memory
cd ".\Ram_memory"
call ram_memory_script.bat
echo Building component Finished
cd "..\"

echo ====Building component Rom_memory
cd ".\Rom_memory"
call rom_memory_script.bat
echo Building component Finished
cd "..\"

echo ====Building component piso_shift register
cd ".\Shift_registers\piso_shift_register"
call piso_shift_register_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component sipo_shift register
cd ".\Shift_registers\sipo_shift_register"
call sipo_shift_register_test_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component parallel subtractor
cd ".\Subtractors\parallel_subtractor_n_bit"
call parallel_subtractor_nbit_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component half subtractor
cd ".\Subtractors\half_subtractor"
call half_subtractor_script.bat
echo Building component Finished
cd "..\..\"

echo ====Building component full subtractor
cd ".\Subtractors\full_subtractor"
call full_subtractor_script.bat
echo Building component Finished
cd "..\..\"