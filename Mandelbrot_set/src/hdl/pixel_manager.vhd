library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_unsigned.ALL;

entity pixel_manager is
	port (
		-- system interface
		clk				:	in	std_logic;
	
		-- VGA unit interface
		p_x				:	in	std_logic_vector(9 downto 0);
		p_y				:	in	std_logic_vector(9 downto 0);
		
		-- VGA rgb outputs
		vgaRed			:	out	std_logic_vector(3 downto 0);
		vgaGreen		:	out	std_logic_vector(3 downto 0);
		vgaBlue			:	out	std_logic_vector(3 downto 0);
		
		-- memory interface
		read_addr		:	out std_logic_vector(3 downto 0);
		read_data		:	in  std_logic_vector(2 downto 0)
	);
end pixel_manager;

architecture rtl of pixel_manager is

	signal sq_a : std_logic := '0';
	signal sq_b : std_logic := '0';
	signal sq_c : std_logic := '0';
	signal sq_d : std_logic := '0';
	
	signal pixel_r : std_logic := '0';
	signal pixel_g : std_logic := '0';
	signal pixel_b : std_logic := '0';
	
	signal s_read_data : std_logic_vector(2 downto 0) := "000";
	
begin

	-- nine squares of different color
	-- choose read address based on current x and y values
	process (clk, p_x, p_y)
	begin
		if    (p_x > 420) then
			if (p_y > 320) then
				read_addr <= "1000";
			elsif (p_y > 160) then
				read_addr <= "0101";
			else
				read_addr <= "0010";
			end if;
		elsif (p_x > 210) then
			if (p_y > 320) then
				read_addr <= "0111";
			elsif (p_y > 160) then
				read_addr <= "0100";
			else
				read_addr <= "0001";
			end if;
		else
			if (p_y > 320) then
				read_addr <= "0110";
			elsif (p_y > 160) then
				read_addr <= "0011";
			else
				read_addr <= "0000";
			end if;
		end if;
	end process;
	
	-- Use intermediate signal to allow initialization
	s_read_data <= read_data;
	
	-- unpack pixel values from read data
	pixel_r <= s_read_data(2);
	pixel_g <= s_read_data(1);
	pixel_b <= s_read_data(0);

	-- assign values to vga outputs based on unpacked pixel values
    vgaRed(3)   <= pixel_r;
	vgaRed(2)   <= pixel_r;
	vgaRed(1)   <= pixel_r;
	vgaRed(0)   <= pixel_r;
    vgaGreen(3) <= pixel_g;
	vgaGreen(2) <= pixel_g;
	vgaGreen(1) <= pixel_g;
	vgaGreen(0) <= pixel_g;
    vgaBlue(3)  <= pixel_b;
	vgaBlue(2)  <= pixel_b;
	vgaBlue(1)  <= pixel_b;
	vgaBlue(0)  <= pixel_b;

end rtl;