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

entity square_rom is
	port (
		clk		: in  std_logic;
		enable	: in  std_logic;
		address	: in  std_logic_vector(3 downto 0);
		d_out	: out std_logic_vector(2 downto 0)
	);
end square_rom;

architecture Behavioral of square_rom is
	type rom_array is array (0 to 8) of std_logic_vector(2 downto 0);
	-- Rom contents
	constant content : rom_array := (
	-- !GCB Generate code begin ----------------------------------------------------
	0 		=> "000", -- black
	1		=> "100", -- red
	2		=> "010", -- green
	3 		=> "001", -- blue
	4 		=> "111", -- white
	5 		=> "110", -- red + green
	6 		=> "011", -- green + blue
	7 		=> "101", -- red + blue
	8 		=> "000", -- black
	others	=> "000"
	-- !GCE Generate code end ------------------------------------------------------
	);
begin
	process (clk) begin
		if (clk'event and clk = '0') then
			if (enable = '1') then
				d_out <= content(conv_integer(address));
			else
				d_out <= "ZZZ";
			end if;
		end if;
	end process;
end Behavioral;