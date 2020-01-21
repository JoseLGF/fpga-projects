----------------------------------------------------------------------------------
-- Module Name: four_single_sseg - Behavioral
-- Description: 
--      Allows to display four separate digits (0-F) in the four-digit seven segment display
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity four_single_sseg is
  Port (
               CLK            : in  std_logic;
               D0             : in  std_logic_vector(3 downto 0); 
               D1             : in  std_logic_vector(3 downto 0); 
               D2             : in  std_logic_vector(3 downto 0); 
               D3             : in  std_logic_vector(3 downto 0); 
               segments       : out std_logic_vector(7 downto 0);
               anodes         : out std_logic_vector(3 downto 0)
       );
end four_single_sseg;

architecture Behavioral of four_single_sseg is
    component clk_div 
             Port(
               clk            : in  std_logic;
               sclk           : out std_logic
                 ); 
    end component; 

    -- signals
    signal cnt_dig : std_logic_vector(1 downto 0);
    signal digit   : std_logic_vector(3 downto 0);
    signal s_sclk  : std_logic; -- slow clock signal

begin

    pm_clk_div: clk_div port map( 
               clk           => clk,
               sclk          => s_sclk
     );

    -- advance count (display multiplexing)
    process(s_sclk) begin 
        if (rising_edge(s_sclk)) then 
            cnt_dig <= cnt_dig +1;
        end if;
     end process;


   -- select the display sseg data abcdefg (active low) -----
   segments <= "00000011" when digit = "0000"  else
               "10011111" when digit = "0001"  else
               "00100101" when digit = "0010"  else
               "00001101" when digit = "0011"  else
               "10011001" when digit = "0100"  else
               "01001001" when digit = "0101"  else
               "01000001" when digit = "0110"  else
               "00011111" when digit = "0111"  else
               "00000001" when digit = "1000"  else
               "00001001" when digit = "1001"  else
               "11111101" when digit = "1110"  else   -- dash
               "11111111" when digit = "1110"  else   -- blank
               "11111111"; 

     -- actuate correct display
     anodes <= "1110" when cnt_dig = "00" else
               "1101" when cnt_dig = "01" else
               "1011" when cnt_dig = "10" else
               "0111" when cnt_dig = "11" else
               "1111"; 

     -- digit sweeping
    sw: process(cnt_dig) begin 
            case cnt_dig is
                    when "00" => digit <= D0(3 downto 0);
                    when "01" => digit <= D1(3 downto 0); 
                    when "10" => digit <= D2(3 downto 0); 
                    when "11" => digit <= D3(3 downto 0); 
                    when others => digit <= "0000"; 
            end case; 
     end process;

end Behavioral;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------------------------------------
-- Module to divide the clock 
-----------------------------------------------------------------------
entity clk_div is
    Port (  clk : in std_logic;
           sclk : out std_logic);
end clk_div;

architecture my_clk_div of clk_div is
   constant max_count : integer := (2200);  
   signal tmp_clk : std_logic := '0'; 
begin
   my_div: process (clk,tmp_clk)              
      variable div_cnt : integer := 0;   
   begin
      if (rising_edge(clk)) then   
         if (div_cnt = MAX_COUNT) then 
            tmp_clk <= not tmp_clk; 
            div_cnt := 0; 
         else
            div_cnt := div_cnt + 1; 
         end if; 
      end if; 
      sclk <= tmp_clk; 
   end process my_div; 
end my_clk_div;
