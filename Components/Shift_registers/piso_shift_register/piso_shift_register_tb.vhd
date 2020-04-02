----------------------------------------------------------------------------------
--
-- Module Name: Half adder testbench
-- Description:
-- A simulation to test the proper behavior of half adder component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso_shift_register_tb is
end piso_shift_register_tb;

architecture test of piso_shift_register_tb is
    -- components
    component piso_shift_register
        port (
			din		: in  std_logic_vector(3 downto 0);
			clk		: in  std_logic;
			temp	: in  std_logic;
			ctrl	: in  std_logic;
			dout	: out std_logic
		);
    end component;
    
		signal din		: std_logic_vector(3 downto 0);
		signal clk		: std_logic:= '0';
		signal temp		: std_logic:= '0';
		signal ctrl		: std_logic:= '0';
		signal dout		: std_logic:= '0';

begin

    piso_shift_register_pm: piso_shift_register 
	port map(
		din		=> din,
		clk		=> clk,
		temp	=> temp,
		ctrl	=> ctrl,
		dout	=> dout
	);
	
	-- clk
    process begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    end process;
	
	process begin
	-- Verify initial values
	din  <= "0000";
	ctrl <= '0';
	-- dout reads "0" at 20 ns
	wait for 20 ns;
	
	-- load the register input with "1001"
	din  <= "1001";
	wait for 15 ns;
	
	-- Setting ctrl = 1 will trigger the shifting process
	-- Should serially read 1,0,0,1
	-- The output bits are captured in the falling edge.
	-- Shifting process begins at each rising edge when ctrl = 1
	-- Therefore, you are reading your first bit even before you set ctrl.
	-- When setting ctrl =1, the next will appear in the rising edge.
	-- Capture output bits in falling edge.
	-- First bit is captured immediately
	ctrl <= '1';
	wait for 80 ns;
	
	-- Load the register input with "0011"
	ctrl <= '0';
	din  <= "0011";
	wait for 35 ns;
	
	-- Flush the register
	ctrl <= '1';
	wait for 80 ns;
	
	wait;
    end process;
	
end test;
