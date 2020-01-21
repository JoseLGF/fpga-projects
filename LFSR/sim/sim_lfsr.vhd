library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_lfsr is
end sim_lfsr;

architecture Behavioral of sim_lfsr is
    -- components
    component LFSR
        Port ( pulse : in  std_logic;                    -- generate next signal
               reset : in std_logic;                     -- reset lfsr state
               q     : out std_logic_vector (7 downto 0) -- random number out
               );
    end component;
    
    -- signals
    signal pls  : std_logic := '0';
    signal rst  : std_logic := '0';
    signal s_sq : std_logic_vector (7 downto 0);

begin
    -- port map
    pm_lfsr: LFSR port map (
        pulse => pls,
        reset => rst,
        q     => s_sq
        );
        
    -- pulse process
    pulse_process: process
        begin
        pls <= '0';
        wait for 10 ns;
        pls<= '1';
        wait for 10 ns;
        end process;
        
    -- reset process
    reset_process: process
        begin
        rst <= '0';
        wait for 7000 ns;
        rst <= '1';
        wait for 3000 ns;
        end process;
        
end Behavioral;
