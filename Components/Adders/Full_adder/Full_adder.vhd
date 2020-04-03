-------------------------------------------------------------------------------
-- Component name: Full adder
-- Description:
-- Full adder component that can be used as a building block for serial adders.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port(
		a    : in  std_logic;
		b    : in  std_logic;
		cin  : in  std_logic;
		sum  : out std_logic;
		cout : out std_logic
	);
end entity;

architecture Behavioral of full_adder is
begin
	process (a, b, cin)
		variable indata : std_logic_vector (2 downto 0);
	begin
		indata := cin & a & b;
		case indata is
			when "000"  => cout <= '0'; sum <= '0';
			when "001"  => cout <= '0'; sum <= '1';
			when "010"  => cout <= '0'; sum <= '1';
			when "011"  => cout <= '1'; sum <= '0';
			when "100"  => cout <= '0'; sum <= '1';
			when "101"  => cout <= '1'; sum <= '0';
			when "110"  => cout <= '1'; sum <= '0';
			when "111"  => cout <= '1'; sum <= '1';
			when others => cout <= '0'; sum <= '0';
		end case;
	end process;
end Behavioral;
