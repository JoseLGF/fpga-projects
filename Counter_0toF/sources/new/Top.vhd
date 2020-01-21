library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port (
        CLK: in STD_LOGIC;
        disp_sel: in STD_LOGIC_VECTOR (1 DOWNTO 0);
        LEDS: out STD_LOGIC_VECTOR (6 DOWNTO 0);
        displays: out STD_LOGIC_VECTOR (3 DOWNTO 0)
--        salida_bin: out std_logic_vector (3 downto 0)
         );
end Top;

architecture Structural of Top is
-- signals
signal clk1s: STD_LOGIC;
signal counter_n: STD_LOGIC_VECTOR (3 DOWNTO 0);
-- components
component clk_div
    port (
        clk_100: in std_logic;
        clk_1s: out std_logic
    );
end component;

component Counter0F
    Port ( 
        pulse: in STD_LOGIC;
        count: out STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
end component;

component Decodificador
    Port ( Entrada: in STD_LOGIC_VECTOR (3 DOWNTO 0); 
         Salida: out STD_LOGIC_VECTOR (6 DOWNTO 0); --segments
         disp_select: in STD_LOGIC_VECTOR (1 DOWNTO 0); -- display selector
         displays: out STD_LOGIC_VECTOR (3 DOWNTO 0) --display selector
         );
end component;
begin
    reloj: clk_div port map (CLK, clk1s);
    counterc: Counter0F port map (clk1s, counter_n);
    disp7: Decodificador port map (counter_n, LEDS, disp_sel, displays);
end Structural;
