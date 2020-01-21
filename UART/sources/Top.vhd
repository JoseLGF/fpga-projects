library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
  Port ( RX   : in  std_logic;
         TX   : out std_logic;
         CLK  : in  std_logic;
         seg  : out std_logic_vector (7 downto 0);
         an   : out std_logic_vector (3 downto 0);
         sw   : in  std_logic_vector (7 downto 0);
         btnC : in std_logic
          );
end Top;

architecture Structural of Top is
-- components
component UART_RX is
generic (
    g_CLKS_PER_BIT : integer := 868     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic; -- Clock (100 MHz on the Basys3)
    i_RX_Serial : in  std_logic; -- Serial data line
    o_RX_DV     : out std_logic; -- high for one cycle when read is complete
    o_RX_Byte   : out std_logic_vector(7 downto 0) -- output received byte
    );
end component;

component EightBitDataPassDelay is
    Port ( FastIn       : in STD_LOGIC_VECTOR (7 downto 0);
           UpdateNow    : in STD_LOGIC;
           HeldSample   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component sseg_dec is
    Port (      ALU_VAL : in std_logic_vector(7 downto 0); 
			       SIGN : in std_logic;
		          VALID : in std_logic;
                    CLK : in std_logic;
                DISP_EN : out std_logic_vector(3 downto 0);
               SEGMENTS : out std_logic_vector(7 downto 0));
end component;

component UART_TX is
    generic (
    g_CLKS_PER_BIT : integer := 868     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;                    -- 100 MHz on Basys3
    i_TX_DV     : in  std_logic;                    -- drive high for one cycle to start transmitting
    i_TX_Byte   : in  std_logic_vector(7 downto 0); -- byte to be transmitted
    o_TX_Active : out std_logic;                    -- High when Data is being transmitted
    o_TX_Serial : out std_logic;                    -- Serial output line
    o_TX_Done   : out std_logic                     -- High for one cycle when transmission is complete
    );
end component;

-- signals
signal s_RX_byte : std_logic_vector(7 downto 0);
signal s_rx_dv   : std_logic;
signal s_sample  : std_logic_vector (7 downto 0);
signal s_Sign    : std_logic := '0';
signal s_Valid   : std_logic := '1';

begin
    -- port maps
    Receiver: UART_RX port map (
      i_Clk       => CLK,
      i_RX_Serial => RX,
      o_RX_DV     => s_rx_dv,
      o_RX_Byte   => s_RX_byte (7 downto 0)
    );
    
    Reg: EightBitDataPassDelay port map (
        FastIn     => s_RX_byte (7 downto 0),
        UpdateNow  => s_rx_dv,
        HeldSample => s_sample (7 downto 0)
    );
    
    displays: sseg_dec port map (
        ALU_VAL => s_sample (7 downto 0), 
           SIGN => s_Sign,
          VALID => s_Valid,
            CLK => CLK,
        DISP_EN => an,
       SEGMENTS => seg
    );
    
    Transmitter: UART_TX port map (
        i_Clk       => CLK,
        i_TX_DV     => btnC,
        i_TX_Byte   => sw (7 downto 0),
        o_TX_Active => open,
        o_TX_Serial => TX,
        o_TX_Done   => open
    );
    

end Structural;