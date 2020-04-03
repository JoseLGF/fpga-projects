----------------------------------------------------------------------------------
--
-- Module Name: Full adder testbench
-- Description: A simulation to test the proper behavior of full adder component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
end full_adder_tb;

architecture test of full_adder_tb is
    -- components
    component full_adder
        PORT (
		a    : in  std_logic;
		b    : in  std_logic;
		cin  : in  std_logic;
		sum  : out std_logic;
		cout : out std_logic
          );
    end component;
    
    -- input signals
    signal a	: std_logic := '0';
    signal b	: std_logic := '0';
    signal cin	: std_logic := '0';
    -- output signals
    signal sum	: std_logic := '0';
    signal cout	: std_logic := '0';

begin
    full_adder_pm: full_adder 
        port map(
		a    => a,
		b    => b,
		cin  => cin,
		sum  => sum,
		cout => cout
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

    cin_process: process
    begin
    cin <= '0';
    wait for 40 ns;
    cin <= '1';
    wait for 40 ns;
    end process;
	
end test;
