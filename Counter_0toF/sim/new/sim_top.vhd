library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_top is
end sim_top;

architecture Behavioral of sim_top is
-- component
        component Top
        Port (
        CLK: in STD_LOGIC;
        disp_sel: in STD_LOGIC_VECTOR (1 DOWNTO 0);
        LEDS: out STD_LOGIC_VECTOR (6 DOWNTO 0);
        displays: out STD_LOGIC_VECTOR (3 DOWNTO 0)
         );
         end component;
         
         -- input signals
         signal CLK: std_logic := '0';
         signal disp_sel: std_logic_vector (1 downto 0);
         --output signals
         signal s_leds: std_logic_vector (6 downto 0);
         signal s_disps: std_logic_vector (3 downto 0);
             -- clock period definition
             constant CLK_period : time := 10 ns;
begin
    uut: Top port map (CLK, disp_sel, s_leds, s_disps);
    
        -- clock process
        CLK_process: process
        begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
        end process;

        disp_sel <= "00";

end Behavioral;
