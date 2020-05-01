--------------------------------------------------------------------------------
-- Testbench for the edge_debounce file.
-- A 50 MHz clock is simulated.
-- First, wait 10 ms in order for the debouncer to produce a valid output.
-- Then, input an unstable signal coming from e.g. a button.
-- Afer the signal stabilizes high (@18 ms), the debouncer waits 10 ms and
-- produces a stable signal (@28 ms). This change is detected by the edge
-- detector, which produces a single pulse for 1 clock cycle.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity edge_debounce_tb is
end edge_debounce_tb;

architecture behavioral of edge_debounce_tb is

	component edge_debounce is
		Port (
			btn_i	: in  std_logic;
			clk		: in  std_logic;
			rst		: in  std_logic;
			btn_o	: out std_logic
		);
	end component;

	-- signals
	signal s_clk	: std_logic := '1';
	signal s_btn_i	: std_logic := '0';
	signal s_btn_o	: std_logic := '0';
	signal s_rst	: std_logic := '0';

begin

	uut : edge_debounce
		port map(
			btn_i	=> s_btn_i,
			clk		=> s_clk,
			rst		=> s_rst,
			btn_o	=> s_btn_o
		);

	-- processes
	p_clk: process begin
		s_clk <= '1';
		wait for 10 ns;
		s_clk <= '0';
		wait for 10 ns;
	end process;

	p_btn: process begin
		s_btn_i <= '0';
		wait for 12 ms;
		s_btn_i <= '1';
		wait for 1 ms;
		s_btn_i <= '0';
		wait for 1 ms;
		s_btn_i <= '1';
		wait for 1 ms;
		s_btn_i <= '0';
		wait for 1 ms;
		s_btn_i <= '1';
		wait for 1 ms;
		s_btn_i <= '0';
		wait for 1 ms;
		s_btn_i <= '1';
		wait;
	end process;

	p_rst : process begin
		s_rst <= '1';
		wait for 100 ns;
		s_rst <= '0';
		wait;
	end process;

end behavioral;
