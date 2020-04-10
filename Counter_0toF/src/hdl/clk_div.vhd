-- Clock divider module to get 1 second clock, with a 100 MHz clock signal
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
entity clk_div is
port (
   clk_100: in std_logic;
   clk_1s: out std_logic
  );
end clk_div;
architecture Behavioral of clk_div is
signal counter: std_logic_vector(27 downto 0):=(others =>'0');
begin
 process(clk_100)
 begin
  if(clk_100'event and clk_100='1') then
   counter <= counter + 1;
   if(counter>=x"5F5E100") then -- 100,000,000
   --if(counter>=x"FF") then -- 100,000,000
    counter <= x"0000000";
   end if;
  end if;
 end process;
 clk_1s <= '1' when counter = 0 else '0';
 --clk_1s <= '0' when counter < x"7F" else '1';
end Behavioral;