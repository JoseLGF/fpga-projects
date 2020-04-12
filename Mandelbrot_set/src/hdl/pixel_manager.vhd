library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.ALL;

entity pixel_manager is
	port (
		-- VGA unit interface
		p_x				:	in	std_logic_vector(9 downto 0);
		p_y				:	in	std_logic_vector(9 downto 0);
		
		-- VGA rgb outputs
		vgaRed			:	out	std_logic_vector(3 downto 0);
		vgaGreen		:	out	std_logic_vector(3 downto 0);
		vgaBlue			:	out	std_logic_vector(3 downto 0)
		
	);
end pixel_manager;

architecture rtl of pixel_manager is

	signal sq_a : std_logic := '0';
	signal sq_b : std_logic := '0';
	signal sq_c : std_logic := '0';
	signal sq_d : std_logic := '0';
	
begin 

	-- Four overlapping squares
    sq_a <=  '1' when ((p_x > 120) and (p_y >  40) and (p_x < 280) and (p_y < 200))
		else '0';
    sq_b <=  '1' when ((p_x > 200) and (p_y > 120) and (p_x < 360) and (p_y < 280))
		else '0';
    sq_c <=  '1' when ((p_x > 280) and (p_y > 200) and (p_x < 440) and (p_y < 360))
		else '0';
    sq_d <=  '1' when ((p_x > 360) and (p_y > 280) and (p_x < 520) and (p_y < 440))
		else '0';

    vgaRed(3)   <= sq_b;          -- square b is red
    vgaGreen(3) <= sq_a or sq_d;  -- squares a and d are green
    vgaBlue(3)  <= sq_c;          -- square c is blue
	
end rtl;