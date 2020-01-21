----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2018 14:42:54
-- Design Name: 
-- Module Name: DFF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DFF is
  Port ( DATAIN     : in std_logic;
         CLK        : in std_logic;
         ENABLE     : in std_logic;
         
         DATAOUT    : out std_logic := '0';
         NOTDATAOUT : out std_logic := '1'
  );
end DFF;

architecture Behavioral of DFF is

begin
    dff: process (DATAIN, CLK)
        begin
            if (rising_edge(CLK)) then
                if (ENABLE = '1') then
                    DATAOUT <= DATAIN;
                    NOTDATAOUT <= not DATAIN;
                end if;
            end if;
    end process dff;
end Behavioral;
