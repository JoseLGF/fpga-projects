----------------------------------------------------------------------------------
--
-- Module Name: full subtractor testbench
-- Description:
-- A simulation to test the proper behavior of full subtractor component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_subtractor_tb is
end full_subtractor_tb;

architecture sim of full_subtractor_tb is
    -- components
    component full_subtractor
        port(
			x		: in  std_logic;
			y		: in  std_logic;
			b_in	: in  std_logic; -- Borrow in
			diff	: out std_logic;
			borrow	: out std_logic
		);
    end component;
    
    -- input signals
    signal x		: std_logic := '0';
	signal y		: std_logic := '0';
	signal b_in		: std_logic := '0';
	signal diff		: std_logic := '0';
	signal borrow	: std_logic := '0';

begin
    full_subtractor_pm: full_subtractor 
	port map(
		x		=> x,
		y		=> y,
		b_in	=> b_in,
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
	
	process begin
    b_in <= '0';
    wait for 40 ns;
    b_in <= '1';
    wait for 40 ns;
    end process;
	
end sim;
