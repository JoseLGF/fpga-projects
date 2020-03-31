----------------------------------------------------------------------------------
--
-- Module Name: Rom Memory component
-- Description: Simple rom memory component
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rom_memory is
	port (
		clk		: in  std_logic;
		enable	: in  std_logic;
		address	: in  std_logic_vector(1 downto 0);
		d_out	: out std_logic_vector(7 downto 0)
	);
end rom_memory;

architecture Behavioral of rom_memory is
	type rom_array is array (0 to 3) of std_logic_vector(7 downto 0);
	-- Rom contents
	constant content : rom_array := (
	-- !GCB Generate code begin ----------------------------------------------------
	0 		=> "10000001",
	1		=> "10000010",
	2		=> "10000011",
	3 		=> "10000100",
	others	=> "11111111"
	-- !GCE Generate code end ------------------------------------------------------
	);
begin
	process (clk) begin
		if (clk'event and clk = '0') then
			if (enable = '1') then
				d_out <= content(conv_integer(address));
			else
				d_out <= "ZZZZZZZZ";
			end if;
		end if;
	end process;
end Behavioral;