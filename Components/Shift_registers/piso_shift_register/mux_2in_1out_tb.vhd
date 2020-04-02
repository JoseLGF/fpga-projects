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
			d_in_0	: in  std_logic;
			d_in_1	: in  std_logic;
			d_out	: out std_logic;
			sel		: in std_logic
		);
    end component;
    
    -- input signals
    signal d_in_0	: std_logic := '0';
	signal d_in_1	: std_logic := '0';
    signal sel		: std_logic := '0';
    -- output signals
    signal d_out	: std_logic := '0';

begin
    mux_2in_1out_pm: mux_2in_1out 
	port map(
		d_in_0	=> d_in_0,
		d_in_1	=> d_in_1,
		d_out	=> d_out,
		sel		=> sel
	);

	-- Generate all possible combinations of inputs
    process	begin
    d_in_0 <= '0';
	d_in_1 <= '0';
    wait for 10 ns;
    d_in_0 <= '0';
	d_in_1 <= '1';
    wait for 10 ns;
	d_in_0 <= '1';
	d_in_1 <= '0';
    wait for 10 ns;
    d_in_0 <= '1';
	d_in_1 <= '1';
    wait for 10 ns;
    end process;

    process begin
    sel <= '0';
    wait for 40 ns;
    sel <= '1';
    wait for 40 ns;
    end process;
	
end test;
