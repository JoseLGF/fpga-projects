--------------------------------------------------------------------------------
-- This file combines a debounce and an edge detector in a single block.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_debounce is
	Port (
		btn_i	: in  std_logic;
		clk		: in  std_logic;
		rst		: in  std_logic;
		btn_o	: out std_logic
	);
end edge_debounce;

architecture Structural of edge_debounce is

	-- components
	component debounce
		generic(
			--counter size (19 bits gives 10.5ms with 50mhz clock)
			counter_size : integer := 19
		);
		port(
			clk            : in  std_logic;
			button         : in  std_logic;
			result         : out std_logic
		);
	end component;

	component edge_detector
		port (
			i_clk          : in  std_logic;
			i_rstb         : in  std_logic;
			i_input        : in  std_logic;
			o_pulse        : out std_logic
		);
	end component;


	-- signals
	signal s_debounced	: std_logic := '0';
	signal s_edge		: std_logic := '0';

begin

	-- port maps
	db: debounce
	generic map(
		--counter size (19 bits gives 10.5ms with 50mhz clock)
		counter_size => 19
	)
	port map(
		clk		=> clk,
		button	=> btn_i,
		result	=> s_debounced
	);

	ed: edge_detector port map(
		i_clk	=> clk,
		i_rstb	=> rst,
		i_input	=> s_debounced,
		o_pulse	=> btn_o
	);

end Structural;
