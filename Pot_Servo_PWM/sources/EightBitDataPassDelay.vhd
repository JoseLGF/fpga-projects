library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EightBitDataPassDelay is
    Port ( FastIn       : in STD_LOGIC_VECTOR (7 downto 0);
           UpdateNow    : in STD_LOGIC;
           HeldSample   : out STD_LOGIC_VECTOR (7 downto 0));
end EightBitDataPassDelay;

architecture Behavioral of EightBitDataPassDelay is

COMPONENT DFF is
    Port ( DATAIN       : in  STD_LOGIC;
           CLK          : in  STD_LOGIC;
           ENABLE       : in  STD_LOGIC; 
           DATAOUT      : out STD_LOGIC := '0';
           NOTDATAOUT   : out STD_LOGIC := '1');
end COMPONENT;

begin
    FF1 : DFF
        port map(   DATAIN      => FastIn(0),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(0),
                    NOTDATAOUT  => open );
    FF2 : DFF
        port map(   DATAIN      => FastIn(1),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(1),
                    NOTDATAOUT  => open );
    FF3 : DFF
        port map(   DATAIN      => FastIn(2),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(2),
                    NOTDATAOUT  => open );
    FF4 : DFF
        port map(   DATAIN      => FastIn(3),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(3),
                    NOTDATAOUT  => open );
    FF5 : DFF
        port map(   DATAIN      => FastIn(4),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(4),
                    NOTDATAOUT  => open );
    FF6 : DFF
        port map(   DATAIN      => FastIn(5),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(5),
                    NOTDATAOUT  => open );
    FF7 : DFF
        port map(   DATAIN      => FastIn(6),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(6),
                    NOTDATAOUT  => open );
    FF8 : DFF
        port map(   DATAIN      => FastIn(7),
                    CLK         => UpdateNow,
                    ENABLE      => '1',
                    DATAOUT     => HeldSample(7),
                    NOTDATAOUT  => open );
end Behavioral;
