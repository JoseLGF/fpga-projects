----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2020 12:14:01
-- Design Name: 
-- Module Name: Rpi_Spi_Top - arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Rpi_Spi_Top is
  Port (
    -- Clock in, SYS_CLK = 100 MHz
    SYS_CLK : in std_logic;
    
    -- LED outs
    led : out std_logic_vector(8 downto 1);
    
    RPI_CLK  : in  std_logic; -- SPI clock
    RPI_MOSI : in  std_logic; -- SPI mosi
    RPI_SS   : in  std_logic; -- SPI slave select (active low)
    RPI_MISO : out std_logic  -- SPI miso
     );
end Rpi_Spi_Top;

architecture arch of Rpi_Spi_Top is

-- Clock divider from 100 MHz to 29p5 MHz
component clk_wiz_0 is
    port(
        clk_in1  : in  std_logic; -- input clock (100 MHz)
        reset    : in  std_logic;
        clk_out1 : out std_logic; -- Out clock (29p5 MHz)
        locked   : out std_logic
    );
    end component;
    
-- SPI Slave
component SPI_Slave is
    port(
      -- general purpose
      sys_clock : in  std_logic; -- system clock
      sys_rst   : in  std_logic; -- System reset (active low)
      -- serial I/O side
      sclk      : in  std_logic; -- SPI clock from Master
      ss        : in  std_logic; -- SPI chip select from Master
      mosi      : in  std_logic; -- SPI data from Master
      miso      : out std_logic; -- SPI data to Master
      -- Register read/write interface
      wr_enable : out std_logic; -- Write Enable: Data_out is valid
      data_out  : out std_logic_vector(7 downto 0); -- 8-bit data from Master
      data_in   : in  std_logic_vector(7 downto 0)  -- 8-bit data read back
    );
    end component;
    
-- Signals
signal locked, clk_29MHz_i, rst_i : std_logic := '0';
signal data_out, SPI_DATA         : std_logic_vector(7 downto 0);
    
signal rspi_clk  : std_logic;
signal rspi_mosi : std_logic;
signal rspi_miso : std_logic;
signal rspi_ss   : std_logic;
    
signal wr_enable : std_logic;

begin
-- port maps
clk_pm : clk_wiz_0
    port map (
        clk_in1  => SYS_CLK,
        reset    => '0',
        clk_out1 => clk_29MHz_i,
        locked   => locked
    );
    
spi_slave_pm : SPI_Slave
    port map (
        -- general purpose
        sys_clock => clk_29MHz_i,
        sys_rst   => rst_i,
        -- serial I/O side
        sclk      => rspi_clk,
        ss        => rspi_ss,
        mosi      => rspi_mosi,
        miso      => rspi_miso,
        -- Register read/write interface
        wr_enable => wr_enable,
        data_out  => data_out,
        data_in   => SPI_DATA
    );
    
-- Spi data register process
spi_data_p : process(clk_29MHz_i, rst_i)
begin
    if(rst_i = '0') then
        SPI_DATA <= (others => '0');
    elsif(rising_edge(clk_29MHz_i)) then
        if (wr_enable = '1') then
            SPI_DATA <= data_out;
        end if;
    end if;
end process;

rspi_clk    <= RPI_CLK;
rspi_mosi   <= RPI_MOSI;
rspi_ss     <= RPI_SS;
RPI_MISO    <= rspi_miso;

led  <= not SPI_DATA;

rst_i <= locked;
end arch;
