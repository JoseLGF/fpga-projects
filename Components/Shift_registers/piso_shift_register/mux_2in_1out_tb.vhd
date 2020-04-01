----------------------------------------------------------------------------------
--
-- Module Name: 2 input 1 output multiplexer testbench
-- Description:
-- A simulation to test the proper behavior of multiplexer component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2in_1out_tb is
end mux_2in_1out_tb;

architecture test of mux_2in_1out_tb is
    -- components
    component mux_2in_1out
        port(
			d_in	: in  std_logic_vector(1 downto 0);
			d_out	: out  std_logic;
			sel		: in std_logic
		);
    end component;
    
    -- input signals
    signal d_in		: std_logic_vector(1 downto 0) := "00";
    signal sel		: std_logic := '0';
    -- output signals
    signal d_out	: std_logic := '0';

begin
    mux_2in_1out_pm: mux_2in_1out 
	port map(
		d_in	=> d_in,
		d_out	=> d_out,
		sel		=> sel
	);

	-- Generate all possible combinations of inputs
    process begin
    d_in <= "00";
    wait for 10 ns;
    d_in <= "01";
    wait for 10 ns;
	d_in <= "10";
    wait for 10 ns;
    d_in <= "11";
    wait for 10 ns;
    end process;

    process begin
    sel <= '0';
    wait for 40 ns;
    sel <= '1';
    wait for 40 ns;
    end process;
	
end test;
