-- 8 bit LFSR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR is
    Port ( CLK   : in  std_logic;                    -- clock signal
           pulse : in  std_logic;                    -- generate next signal
           reset : in std_logic;                     -- reset lfsr state
           q     : out std_logic_vector (7 downto 0) -- random number out
           );
end LFSR;

architecture Behavioral of LFSR is
signal s_q : std_logic_vector (7 downto 0) := ("01001101"); -- Initial value for LFSR
begin
    process(CLK, pulse, reset) begin
        if (reset = '1') then -- asynchronous reset
            s_q <= "01001101";
        elsif(rising_edge(CLK)) then
            if (pulse = '1') then
            s_q <= (s_q(4) xor s_q(3) xor s_q(2) xor s_q(0)) & s_q(7 downto 1); -- polynomial for maximal LFSR
            end if;
        end if;
    end process;
q <= s_q;
end Behavioral;