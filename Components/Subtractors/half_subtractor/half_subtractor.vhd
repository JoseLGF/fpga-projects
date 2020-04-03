-------------------------------------------------------------------------------
-- Component name: Half subtractor
-- Description:
-- Half subtractor component that can be used as a building block other components.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity half_subtractor is
	port(
		x		: in  std_logic;
		y		: in  std_logic;
		diff	: out std_logic;
		borrow	: out std_logic
	);
end entity;

architecture Behavioral of half_subtractor is
begin
	process (x, y)
		variable indata : std_logic_vector (1 downto 0);
	begin
		indata := x & y;
		case indata is
			when "00"	=> diff <= '0'; borrow <= '0';
			when "01"	=> diff <= '1'; borrow <= '1';
			when "10"	=> diff <= '1'; borrow <= '0';
			when "11"	=> diff <= '0'; borrow <= '0';
			when others	=> diff <= '0'; borrow <= '0';
		end case;
	end process;
end Behavioral;
