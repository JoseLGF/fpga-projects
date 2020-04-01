----------------------------------------------------------------------------------
--
-- Module Name: SIPO shift register testbench
-- Description: A simulation to test the proper behavior of SIPO shift register component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sipo_shift_register_tb is
end sipo_shift_register_tb;

architecture test of sipo_shift_register_tb is
    -- components
	component sipo_shift_register is
		port (
			din	   : in  std_logic;
			clk	   : in  std_logic;
			enable : in  std_logic;
			dout   : out std_logic_vector(7 downto 0)
		);
	end component;
    
    -- input signals
    signal data_in	: std_logic := '0';
	signal sys_clk	: std_logic := '0';
	signal enable	: std_logic := '0';
	-- output signals
	signal data_out	: std_logic_vector(7 downto 0) := "00000000";

begin
    sipo_shift_register_pm : sipo_shift_register 
	port map(
		din	   => data_in,
		clk	   => sys_clk,
		dout   => data_out,
		enable => enable
	);

	-- 100 Mhz Clock
    process begin
    sys_clk <= '0';
    wait for 10 ns;
    sys_clk <= '1';
    wait for 10 ns;
    end process;
		
	-- Serial Data in: Send 0xAB = 0b1010 1011
	process begin
	wait for 300 ns;
	enable <= '1';
    data_in <= '1';
    wait for 20 ns;
    data_in <= '0';
    wait for 20 ns;
	data_in <= '1';
    wait for 20 ns;
    data_in <= '0';
    wait for 20 ns;
	
	data_in <= '1';
    wait for 20 ns;
    data_in <= '0';
    wait for 20 ns;
	data_in <= '1';
    wait for 20 ns;
    data_in <= '1';
    wait for 20 ns;
	data_in <= '0';
	enable <= '0';
    end process;
	
end test;
