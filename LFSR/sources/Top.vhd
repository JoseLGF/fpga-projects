library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
    Port ( clk  : in std_logic;
           btnU : in std_logic; -- Up button to get the next random number
           btnD : in std_logic; -- Down button to reset the sequence
           seg  : out std_logic_vector (7 downto 0);
           an   : out std_logic_vector (3 downto 0);
           led  : out std_logic_vector (7 downto 0)
           );
end Top;

architecture Structural of Top is
    -- signals
    signal s_rand_n : std_logic_vector (7 downto 0);
    
    -- components
    component LFSR
            Port ( CLK   : in std_logic;                     -- clock
                   pulse : in  std_logic;                    -- generate next signal
                   reset : in std_logic;                     -- reset lfsr state
                   q     : out std_logic_vector (7 downto 0) -- random number out
                   );
        end component;
        
    component sseg_dec
        Port (      ALU_VAL : in std_logic_vector(7 downto 0); 
                       SIGN : in std_logic;
                      VALID : in std_logic;
                        CLK : in std_logic;
                    DISP_EN : out std_logic_vector(3 downto 0);
                   SEGMENTS : out std_logic_vector(7 downto 0)
               );
    end component;
begin
    -- port maps
    pm_lfsr: LFSR port map (
                       CLK   => CLK,
                       pulse => btnU,
                       reset => btnD,
                       q     => s_rand_n
    );
    
    sseg: sseg_dec port map (
                        ALU_VAL => s_rand_n,
                           SIGN => '0',
                          VALID => '1',
                            CLK => clk,
                        DISP_EN => an,
                       SEGMENTS => seg
    );
end Structural;
