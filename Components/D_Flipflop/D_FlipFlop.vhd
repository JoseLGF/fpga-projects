----------------------------------------------------------------------------------
--
-- Module Name: D Flip Flop - Behavioral
-- Description: 
-- Generic D Flip flop component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FlipFlop is
	Port (
		DATAIN     : in  std_logic;
		CLK        : in  std_logic;
		ENABLE     : in  std_logic;
		DATAOUT    : out std_logic;
		NOTDATAOUT : out std_logic
  );
end D_FlipFlop;

architecture Behavioral of D_FlipFlop is

begin
    dff_p: process (DATAIN, CLK)
        begin
            if (rising_edge(CLK)) then
                if (ENABLE = '1') then
                    DATAOUT <= DATAIN;
                    NOTDATAOUT <= not DATAIN;
                end if;
            end if;
    end process dff_p;
end Behavioral;
