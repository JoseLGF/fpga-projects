library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;


entity EightBitBarMeter is
    Port (  BarDatIn  : in  STD_LOGIC_VECTOR (7 downto 0);
            BarDatOut : out STD_LOGIC_VECTOR (7 downto 0) := "00000000"   );
end EightBitBarMeter;

architecture Behavioral of EightBitBarMeter is
begin
    Bardisp: process (BarDatIn)
            begin
            if    (BarDatIn >= "00000000"  and BarDatIn < "00100000") then
                BarDatOut <= "00000001";
            elsif (BarDatIn >= "00100000"  and BarDatIn < "01000000") then
                BarDatOut <= "00000011";
            elsif (BarDatIn >= "01000000"  and BarDatIn < "01100000") then
                BarDatOut <= "00000111";
            elsif (BarDatIn >= "01100000"  and BarDatIn < "10000000") then
                BarDatOut <= "00001111";
            elsif (BarDatIn >= "10000000"  and BarDatIn < "10100000") then
                BarDatOut <= "00011111";
            elsif (BarDatIn >= "10100000"  and BarDatIn < "11000000") then
                BarDatOut <= "00111111";
            elsif (BarDatIn >= "11000000"  and BarDatIn < "11100000") then
                BarDatOut <= "01111111";
            elsif (BarDatIn >= "11100000"  and BarDatIn < "11111111") then
                BarDatOut <= "11111111";
            else BarDatOut <= "00000000";
        end if;
--                if    (BarDatIn >= "00000000"  and BarDatIn < "00010000") then
--                    BarDatOut <= "0000000000000001";
--                elsif (BarDatIn >= "00010000"  and BarDatIn < "00100000") then
--                    BarDatOut <= "0000000000000011";
--                elsif (BarDatIn >= "00100000"  and BarDatIn < "00110000") then
--                    BarDatOut <= "0000000000000111";
--                elsif (BarDatIn >= "00110000"  and BarDatIn < "01000000") then
--                    BarDatOut <= "0000000000001111";
--                elsif (BarDatIn >= "01000000"  and BarDatIn < "01010000") then
--                    BarDatOut <= "0000000000111111";
--                elsif (BarDatIn >= "01010000"  and BarDatIn < "01100000") then
--                    BarDatOut <= "0000000000111111";
--                elsif (BarDatIn >= "01100000"  and BarDatIn < "01110000") then
--                    BarDatOut <= "0000000001111111";
--                elsif (BarDatIn >= "01110000"  and BarDatIn < "10000000") then
--                    BarDatOut <= "0000000011111111";
--                elsif (BarDatIn >= "10000000"  and BarDatIn < "10010000") then
--                    BarDatOut <= "0000000111111111";
--                elsif (BarDatIn >= "10010000"  and BarDatIn < "10100000") then
--                    BarDatOut <= "0000001111111111";
--                elsif (BarDatIn >= "10100000"  and BarDatIn < "10110000") then
--                    BarDatOut <= "0000011111111111";
--                elsif (BarDatIn >= "10110000"  and BarDatIn < "11000000") then
--                    BarDatOut <= "0000111111111111";
--                elsif (BarDatIn >= "11000000"  and BarDatIn < "11010000") then
--                    BarDatOut <= "0001111111111111";
--                elsif (BarDatIn >= "11010000"  and BarDatIn < "11100000") then
--                    BarDatOut <= "0011111111111111";
--                elsif (BarDatIn >= "11100000"  and BarDatIn < "11110000") then
--                    BarDatOut <= "0111111111111111";
--                elsif (BarDatIn >= "11110000"  and BarDatIn <= "11111111") then
--                    BarDatOut <= "1111111111111111";
--                else BarDatOut <= "0000000000000000";
--            end if;
        end process;
end Behavioral;

















