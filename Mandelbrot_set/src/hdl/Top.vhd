library ieee;
use ieee.std_logic_1164.all;

entity Mandelbrot_top is
	port (
		clk				:	in	std_logic;
		sw				:	in	std_logic_vector(2 downto 0);
		Hsync, Vsync	:	out	std_logic;
		vgaRed			:	out	std_logic_vector(3 downto 0);
		vgaGreen		:	out	std_logic_vector(3 downto 0);
		vgaBlue			:	out	std_logic_vector(3 downto 0);
		led				:	out	std_logic_vector(15 downto 0)
	);
end Mandelbrot_top;

architecture arch of Mandelbrot_top is

    component vga_unit is
	port (
    CLK			: in	std_logic;
    RST_BTN		: in	std_logic;
    VGA_HS_O	: out	std_logic;
    VGA_VS_O	: out	std_logic;
    VGA_R		: out	std_logic_vector(3 downto 0);
    VGA_G		: out	std_logic_vector(3 downto 0);
    VGA_B		: out	std_logic_vector(3 downto 0)
    );
    end component;

begin
	vga_test_pm : vga_unit
		port map (
			CLK			=> clk,
			RST_BTN		=> '1',
			VGA_HS_O	=> Hsync,
			VGA_VS_O	=> Vsync,
			VGA_R		=> vgaRed,
			VGA_G		=> vgaGreen,
			VGA_B		=> vgaBlue
		);
	
	led				<= "0101010101010101";

end arch;