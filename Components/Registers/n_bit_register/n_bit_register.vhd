----------------------------------------------------------------------------------
--
-- Module Name: Generic n-bit register.
--
----------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_logic_1164.all;

entity n_bit_register is
	generic (
		input_width	: integer :=8
	);
	port(
		Q		: out	std_logic_vector(input_width-1 downto 0);
		Clk		: in	std_logic;
		reset	: in	std_logic;
		D		: in	std_logic_vector(input_width-1 downto 0)
	);
end n_bit_register;

architecture behavioral of n_bit_register is
begin
	process(Clk,reset)
	begin
		if (reset = '1') then
			Q <= (others => '0');
		elsif ( rising_edge(Clk) ) then
			Q <= D;
		end if;
	end process;
end behavioral;