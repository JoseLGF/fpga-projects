library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decodificador is
  Port ( Entrada: in STD_LOGIC_VECTOR (3 DOWNTO 0); 
         Salida: out STD_LOGIC_VECTOR (6 DOWNTO 0); --segments
         disp_select: in STD_LOGIC_VECTOR (1 DOWNTO 0); -- display selector
         displays: out STD_LOGIC_VECTOR (3 DOWNTO 0) --display selector
         );
end Decodificador;
 
architecture Behavioral of Decodificador is

begin
-- display select
process(disp_select)
    begin
        case disp_select is
            when "00" => displays <= "0001";
            when "01" => displays <= "0010";
            when "10" => displays <= "0100";
            when "11" => displays <= "1000";
            when others => displays <= "0001";
        end case;
end process;

-- segments
    process(Entrada)
        begin
            case Entrada is 
                when "0000" => Salida <= "0000001"; --0
                when "0001" => Salida <= "1001111"; --1
                when "0010" => Salida <= "0010010"; --2
                when "0011" => Salida <= "0000110"; --3
                when "0100" => Salida <= "1001100"; --4
                when "0101" => Salida <= "0100100"; --5
                when "0110" => Salida <= "0100000"; --6
                when "0111" => Salida <= "0001111"; --7
                
                when "1000" => Salida <= "0000000"; --8
                when "1001" => Salida <= "0001100"; --9
                when "1010" => Salida <= "0001000"; --A
                when "1011" => Salida <= "1100000"; --B
                when "1100" => Salida <= "1110010"; --C
                when "1101" => Salida <= "1000010"; --D
                when "1110" => Salida <= "0110000"; --E
                when "1111" => Salida <= "0111000"; --F
                when others => Salida <= "1111111"; -- others!
            end case;
    end process;

end Behavioral;