----------------------------------------------------------------------------------
--
-- Module Name: SIPO (Serial input Parallel output) Shift register
-- Description: 8 bit SIPO Shift register
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sipo_shift_register is
	port (
		din	   : in  std_logic;
		clk	   : in  std_logic;
		enable : in  std_logic;
		dout   : out std_logic_vector(7 downto 0)
	);
end sipo_shift_register;

architecture Behavioral of sipo_shift_register is

	component D_FlipFlop is
		Port (
			DATAIN     : in  std_logic;
			CLK        : in  std_logic;
			ENABLE     : in  std_logic;
			DATAOUT    : out std_logic;
			NOTDATAOUT : out std_logic
	);
	end component;

	signal ff_out : std_logic_vector(7 downto 0);
begin
    FF1 : D_FlipFlop
        port map(   DATAIN      => din,
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(0),
                    NOTDATAOUT  => open );
    FF2 : D_FlipFlop
        port map(   DATAIN      => ff_out(0),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(1),
                    NOTDATAOUT  => open );
    FF3 : D_FlipFlop
        port map(   DATAIN      => ff_out(1),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(2),
                    NOTDATAOUT  => open );
    FF4 : D_FlipFlop
        port map(   DATAIN      => ff_out(2),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(3),
                    NOTDATAOUT  => open );
    FF5 : D_FlipFlop
        port map(   DATAIN      => ff_out(3),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(4),
                    NOTDATAOUT  => open );
    FF6 : D_FlipFlop
        port map(   DATAIN      => ff_out(4),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(5),
                    NOTDATAOUT  => open );
    FF7 : D_FlipFlop
        port map(   DATAIN      => ff_out(5),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(6),
                    NOTDATAOUT  => open );
    FF8 : D_FlipFlop
        port map(   DATAIN      => ff_out(6),
                    CLK         => clk,
                    ENABLE      => enable,
                    DATAOUT     => ff_out(7),
                    NOTDATAOUT  => open );
					
	dout <= ff_out;
end Behavioral;
