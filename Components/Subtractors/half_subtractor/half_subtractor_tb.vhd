----------------------------------------------------------------------------------
--
-- Module Name: Half subtractor testbench
-- Description:
-- A simulation to test the proper behavior of half subtractor component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_subtractor_tb is
end half_subtractor_tb;

architecture test of half_subtractor_tb is
    -- components
    component half_subtractor
        port (
			x		: in  std_logic;
			y		: in  std_logic;
			diff	: out std_logic;
			borrow	: out std_logic
		);
    end component;
    
    -- input signals
    signal x		: std_logic := '0';
	signal y		: std_logic := '0';
	signal diff		: std_logic := '0';
	signal borrow	: std_logic := '0';

begin
    half_subtractor_pm: half_subtractor 
	port map(
		x		=> x,
		y		=> y,
		diff	=> diff,
		borrow	=> borrow
	);

    process begin
    x <= '0';
    wait for 10 ns;
    x <= '1';
    wait for 10 ns;
    end process;

    process begin
    y <= '0';
    wait for 20 ns;
    y <= '1';
    wait for 20 ns;
    end process;
	
end test;
