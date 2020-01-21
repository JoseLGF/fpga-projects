library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_cntr is
end sim_cntr;

architecture Behavioral of sim_cntr is
    -- components
    component Counter0F
        Port ( 
        pulse: in STD_LOGIC;
        count: out STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    end component;
    
    -- input signal
    signal pls: STD_LOGIC := '0';
    -- output signal+
    signal cnt: STD_LOGIC_VECTOR (3 DOWNTO 0);
    
begin
    uut: Counter0F port map (pls, cnt);
    
    -- pulse process
        pulse_process: process
        begin
        pls <= '0';
        wait for 50 ns;
        pls<= '1';
        wait for 50 ns;
        end process;

end Behavioral;
