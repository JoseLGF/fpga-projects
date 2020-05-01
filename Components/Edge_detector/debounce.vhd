--------------------------------------------------------------------------------
-- This vhdl file contains logic to debounce a button.
-- The debounce time depends on the clock frequency.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
	generic(
		--counter size (19 bits gives 10.5ms with 50mhz clock)
		counter_size : integer := 19
	);
	port(
		clk		: in  std_logic;  --input clock
		button	: in  std_logic;  --input signal to be debounced
		result	: out std_logic   --debounced signal
	);
end debounce;

architecture logic of debounce is
	signal flipflops   : std_logic_vector(1 downto 0) := (others => '0');
	signal counter_set : std_logic := '0';
	signal counter_out : std_logic_vector(counter_size downto 0) := (others => '0');
begin

	-- counter is reset when inputs are changing
	counter_set <= flipflops(0) xor flipflops(1);

	process(clk)
	begin
		if(clk'event and clk = '1') then
			flipflops(0) <= button;
			flipflops(1) <= flipflops(0);
			-- reset counter whenever input is changing
			if(counter_set = '1') then
				counter_out <= (others => '0');
			-- stable input time is not yet met
			elsif(counter_out(counter_size) = '0') then
				counter_out <= counter_out + 1;
			-- stable input time is met
			else
				result <= flipflops(1);
			end if;
		end if;
	end process;
end logic;