-------------------------------------------------------------------------------
-- Component name: Half adder
-- Description:
-- Half adder component that can be used as a building block other components.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
	port(
		a     : in  std_logic;
		b     : in  std_logic;
		sum   : out std_logic;
		carry : out std_logic
	);
end entity;

architecture Behavioral of half_adder is
begin
	process (a, b)
		variable indata : std_logic_vector (1 downto 0);
	begin
		indata := a & b;
		case indata is
			when "00"  => carry <= '0'; sum <= '0';
			when "01"  => carry <= '0'; sum <= '1';
			when "10"  => carry <= '0'; sum <= '1';
			when "11"  => carry <= '1'; sum <= '0';
			when others => carry <= '0'; sum <= '0';
		end case;
	end process;
end Behavioral;
