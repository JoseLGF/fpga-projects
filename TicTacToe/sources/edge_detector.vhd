--------------------------------------------------------------------------------
-- This file contains logic to implement rising edge detection of a signal.
-- In order to detect edges on buttons, a debouncer should be used together
-- with this file.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
	port (
		i_clk          : in  std_logic;
		i_rstb         : in  std_logic;
		i_input        : in  std_logic;
		o_pulse        : out std_logic
	);
end edge_detector;

architecture Behavioral of edge_detector is
	signal r0_input : std_logic := '0';
	signal r1_input : std_logic := '0';

begin

	p_rising_edge_detector : process(i_clk, i_rstb) begin
		if ( i_rstb='1') then
			r0_input <= '0';
			r1_input <= '0';
		elsif (rising_edge(i_clk)) then
			r0_input <= i_input;
			r1_input <= r0_input;
		end if;
	end process p_rising_edge_detector;

	o_pulse <= not r1_input and r0_input;

end Behavioral;
