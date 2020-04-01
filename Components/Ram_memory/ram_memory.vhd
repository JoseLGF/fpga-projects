----------------------------------------------------------------------------------
--
-- Module Name: Ram Memory component
-- Description: Simple ram memory component
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ram_memory is
	generic (
		width	: integer := 8;
		depth	: integer := 4;
		addr	: integer := 2
		);

	port (
		clk			: in  std_logic;
		write		: in  std_logic;
		read		: in  std_logic;
		addrs		: in  std_logic_vector(addr-1 downto 0);
		data_out	: out std_logic_vector(width-1 downto 0);
		data_in		: in  std_logic_vector(width-1 downto 0)
	);
end ram_memory;

architecture Behavioral of ram_memory is
	type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
	signal tmp_ram: ram_type :=
	(
		X"00", X"01", X"02", X"03"
	);

begin
	process (clk) begin
		if (clk'event and clk = '1') then
			if write = '1' then
				tmp_ram(conv_integer(addrs)) <= data_in;
				data_out <= "ZZZZZZZZ";
			elsif read = '1' then
				data_out <= tmp_ram(conv_integer(addrs));
			else
				data_out <= "ZZZZZZZZ";
			end if;
		end if;
	end process;
end Behavioral;