----------------------------------------------------------------------------------
--
-- Component Name: Testbench for Mandelbrot set top level component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Top_tb is
end Top_tb;

architecture sim of Top_tb is

    component Mandelbrot_top is
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
	end component;
    
    signal clk			: std_logic := '0';
	signal rst			: std_logic := '0';
	signal sw			: std_logic_vector(2 downto 0) := "000";
	signal Hsync, Vsync	: std_logic := '0';
	signal vgaRed		: std_logic_vector(3 downto 0) := "0000";
	signal vgaGreen		: std_logic_vector(3 downto 0) := "0000";
	signal vgaBlue		: std_logic_vector(3 downto 0) := "0000";

begin

    UUT : Mandelbrot_top 
	port map(
		clk				=> clk,
		rst				=> rst,
		sw				=> sw,
		Hsync			=> Hsync,
		Vsync			=> Vsync,
		vgaRed			=> vgaRed,
		vgaGreen		=> vgaGreen,
		vgaBlue			=> vgaBlue
	);
	
	-- system clock
	process begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;
	
	-- rst signal
	process begin
		rst <= '1';
		wait for 50 ns;
		rst <= '0';
		wait for 50 ns;
		rst <= '1';
		wait;
	end process;
	
end sim;