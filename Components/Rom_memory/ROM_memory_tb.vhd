----------------------------------------------------------------------------------
--
-- Module Name: ROM memory testbench
-- Description: A simulation to test the proper behavior of rom memory component
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_memory_tb is
end rom_memory_tb;

architecture test of rom_memory_tb is
    -- components
	component rom_memory is
		port (
			clk		: in  std_logic;
			enable	: in  std_logic;
			address	: in  std_logic_vector(1 downto 0);
			d_out	: out std_logic_vector(7 downto 0)
		);
	end component;
    
    -- input signals
    signal clk		: std_logic := '0';
	signal enable	: std_logic := '0';
	signal address	: std_logic_vector(1 downto 0) := "00";
	-- output signals
	signal d_out	: std_logic_vector(7 downto 0) := "00000000";

begin
    rom_memory_pm : rom_memory 
	port map(
		clk		=> clk,
		enable	=> enable,
		address	=> address,
		d_out	=> d_out
	);

	-- 100 Mhz Clock
    process begin
	clk <= '0';
    wait for 10 ns;
	clk <= '1';
    wait for 10 ns;
    end process;
		
	-- address sweep
	process begin
	wait for 20 ns;
    address <= "00";
	wait for 20 ns;
    address <= "01";
	wait for 20 ns;
    address <= "10";
	wait for 20 ns;
    address <= "11";
    end process;
	
	-- enable signal
	process begin
	enable <= '1';
	wait for 100 ns;
	end process;
	
end test;
