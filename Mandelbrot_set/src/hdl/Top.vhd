library ieee;
use ieee.std_logic_1164.all;

entity Mandelbrot_top is
	port (
		clk				:	in	std_logic;
		rst				:	in	std_logic;
		sw				:	in	std_logic_vector(2 downto 0);
		Hsync, Vsync	:	out	std_logic;
		vgaRed			:	out	std_logic_vector(3 downto 0);
		vgaGreen		:	out	std_logic_vector(3 downto 0);
		vgaBlue			:	out	std_logic_vector(3 downto 0);
		led				:	out	std_logic_vector(15 downto 0)
	);
end Mandelbrot_top;

architecture arch of Mandelbrot_top is


    component pixel_manager is
		port (
			-- VGA unit interface
			p_x				:	in	std_logic_vector(9 downto 0);
			p_y				:	in	std_logic_vector(9 downto 0);
			
			-- VGA rgb outputs
			vgaRed			:	out	std_logic_vector(3 downto 0);
			vgaGreen		:	out	std_logic_vector(3 downto 0);
			vgaBlue			:	out	std_logic_vector(3 downto 0)
		);
	end component;
	
	
	component vga_640x480 is
		port (
			clk			:	in	std_logic;
			reset		:	in	std_logic;
			hsync		:	out	std_logic;
			vsync		:	out	std_logic;
			video_on	:	out	std_logic;
			p_tick		:	out	std_logic;
			pixel_x		:	out	std_logic_vector(9 downto 0);
			pixel_y		:	out	std_logic_vector(9 downto 0)
		);
	end component;


	signal pixel_x : std_logic_vector(9 downto 0) := "0000000000";
	signal pixel_y : std_logic_vector(9 downto 0) := "0000000000";
	
	
begin
	
	pixel_mngr : pixel_manager
		port map (
			-- VGA unit interface
			p_x				=> pixel_x,
			p_y				=> pixel_y,
			
			-- VGA rgb outputs
			vgaRed			=> vgaRed,
			vgaGreen		=> vgaGreen,
			vgaBlue			=> vgaBlue
		);
	
	
	vga : vga_640x480
		port map (
			clk			=> clk,
			reset		=> rst,
			hsync		=> hsync,
			vsync		=> vsync,
			video_on	=> open,
			p_tick		=> open,
			pixel_x		=> pixel_x,
			pixel_y		=> pixel_y
		);
	
	led				<= "0101010101010101";

end arch;