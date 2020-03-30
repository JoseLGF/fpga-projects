----------------------------------------------------------------------------------
--
-- Module Name: D Flip Flop testbench
-- Description: A simulation to test the proper behavior of D flip flop component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FlipFlop_tb is
end D_FlipFlop_tb;

architecture test of D_FlipFlop_tb is
    -- components
    component D_FlipFlop
        Port (
			DATAIN     : in  std_logic;
			CLK        : in  std_logic;
			ENABLE     : in  std_logic;
			DATAOUT    : out std_logic := '0';
			NOTDATAOUT : out std_logic := '1'
		);
    end component;
    
    -- input signals
    signal DATAIN     : std_logic;
	signal CLK        : std_logic;
	signal ENABLE     : std_logic;
	-- output signals
	signal DATAOUT    : std_logic := 'X';
	signal NOTDATAOUT : std_logic := 'X';

begin
    D_FlipFlop_pm : D_FlipFlop 
	port map(
		DATAIN     => DATAIN,
		CLK        => CLK,
		ENABLE     => ENABLE,
		DATAOUT    => DATAOUT,
		NOTDATAOUT => NOTDATAOUT
	);

	-- 100 Mhz Clock
    process begin
    CLK <= '0';
    wait for 10 ns;
    CLK <= '1';
    wait for 10 ns;
    end process;
	
	-- Enable signal
	process begin
    ENABLE <= '0';
    wait for 500 ns;
    ENABLE <= '1';
    wait for 500 ns;
    end process;
	
	-- Data in
	process begin
    DATAIN <= '0';
    wait for 100 ns;
    DATAIN <= '1';
    wait for 100 ns;
    end process;
	
end test;
