-------------------------------------------------------------------------------
-- Component name: 2 input 1 output multiplexer
-- Description:
-- This component is meant to be used as a block for piso shift registers.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity mux_2in_1out is
	port(
		d_in_0	: in  std_logic;
		d_in_1	: in  std_logic;
		d_out	: out std_logic;
		sel		: in  std_logic
	);
end entity;

architecture Behavioral of mux_2in_1out is
begin
	process (d_in_0, d_in_1, sel)
		variable truth_table : std_logic_vector (2 downto 0);
	begin
		truth_table := sel & d_in_0 & d_in_1;
		case truth_table is
			when "000"  => d_out <= '0';
			when "001"  => d_out <= '0';
			when "010"  => d_out <= '1';
			when "011"  => d_out <= '1';
			
			when "100"  => d_out <= '0';
			when "101"  => d_out <= '1';
			when "110"  => d_out <= '0';
			when "111"  => d_out <= '1';
			
			when others => d_out <= '0';
		end case;
	end process;
end Behavioral;
