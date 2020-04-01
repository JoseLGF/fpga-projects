----------------------------------------------------------------------------------
--
-- Module Name: Half adder testbench
-- Description:
-- A simulation to test the proper behavior of half adder component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder_tb is
end half_adder_tb;

architecture test of half_adder_tb is
    -- components
    component half_adder
        port(
			a     : in  std_logic;
			b     : in  std_logic;
			sum   : out std_logic;
			carry : out std_logic
		);
    end component;
    
    -- input signals
    signal a		: std_logic := '0';
    signal b		: std_logic := '0';
    -- output signals
    signal sum		: std_logic := '0';
    signal carry	: std_logic := '0';

begin
    half_adder_pm: half_adder 
	port map(
		a		=> a,
		b		=> b,		
		sum		=> sum,
		carry	=> carry
	);

    process begin
    a <= '0';
    wait for 10 ns;
    a <= '1';
    wait for 10 ns;
    end process;

    b_process: process
    begin
    b <= '0';
    wait for 20 ns;
    b <= '1';
    wait for 20 ns;
    end process;
	
end test;
