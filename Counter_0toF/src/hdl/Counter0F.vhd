library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter0F is
    Port ( 
    pulse: in STD_LOGIC;
    count: out STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
end Counter0F;

architecture Behavioral of Counter0F is
signal s_count: STD_LOGIC_VECTOR (3 DOWNTO 0):= (others => '0');
begin
    process(pulse) begin
        if (pulse'event and pulse='1') then
            if (s_count >= x"F") then
                        s_count <= x"0";
            else
                s_count <= s_count + 1;
            end if;
        end if;
    end process;
    count <= s_count; -- assign output
end Behavioral;
