----------------------------------------------------------------------------------
-- Create Date: 23.02.2020 13:27:42
-- Module Name: SPI_Slave - Behavioral
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SPI_Slave is
  Port (
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
end SPI_Slave;

architecture Behavioral of SPI_Slave is

    signal spi_clk_rising_edge  : std_logic;
    signal spi_clk_falling_edge : std_logic;
    signal spi_write_cycle      : std_logic;
    signal spi_clk_dly_line     : std_logic_vector(2 downto 0);
    signal spi_clk_count        : unsigned(5 downto 0); -- count # of clk cycles
    signal spi_datain_shifter   : std_logic_vector(7 downto 0);
    signal spi_dataout_shifter  : std_logic_vector(7 downto 0);

begin    
-- edge detection process
-- This method requires that sys_clk be at least 4 times faster than spi clock
  spi_clk_edge_detect_p : process (sys_clock)
  begin
    if(rising_edge(sys_clock)) then
        -- delay spi_clk three system clock cycles
        spi_clk_dly_line <= spi_clk_dly_line(1 downto 0) & sclk;
        
        -- rising edge detected when two clock cycles low and then two clock cycles high
        if(spi_clk_dly_line(2) = '0' and 
           spi_clk_dly_line(1) = '0' and
           spi_clk_dly_line(0) = '1' and
           sclk = '1') then
                spi_clk_rising_edge <= '1';
        else
                spi_clk_rising_edge <= '0';
        end if;
        -- falling edge detected when two clock cycles high and then two clock cycles low
        if(spi_clk_dly_line(2) = '1' and 
           spi_clk_dly_line(1) = '1' and
           spi_clk_dly_line(0) = '0' and
           sclk = '0') then
               spi_clk_rising_edge <= '1';
        else
               spi_clk_rising_edge <= '0';
        end if;
    end if;
  end process;
  
  spi_clock_cycles_counter_p : process(sys_clock)
  begin
    if(rising_edge(sys_clock)) then
      if(ss = '1') then -- reset counter to 0 when not chip select
        spi_clk_count <= (others => '0');
      else
        if (spi_clk_rising_edge = '1') then -- every rising edge add one
          if (spi_clk_count = 16) then
            spi_clk_count <= (others => '0');
          else
            spi_clk_count <= spi_clk_count + 1;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- Every time SPI chip select goes to low, it will have 16 bit data
  spi_in_p : process (sys_clock)
  begin
    if (rising_edge(sys_clock)) then
      if (spi_clk_rising_edge = '1') then
        spi_datain_shifter <= spi_datain_shifter(6 downto 0) & mosi;
      end if;
    end if;
  end process;
  
  read_write_cycle_p : process (sys_clock, sys_rst)
  begin
    if (sys_rst = '0') then
      spi_write_cycle <= '0';
    elsif (rising_edge(sys_clock)) then
      if (ss = '1') then
        spi_write_cycle <= '0';
      elsif (spi_clk_count = 8 and spi_datain_shifter = x"00" and spi_clk_falling_edge = '1') then
        spi_write_cycle <= '1';
      end if;
    end if;
  end process;
  
  write_input_p : process(sys_clock, sys_rst)
  begin
    if (sys_rst = '0') then
      wr_enable <= '0';
      data_out <= (others => '0');
    elsif (rising_edge(sys_clock)) then
      if (ss = '1') then
        wr_enable <= '0';
      elsif (spi_clk_count = 16 and spi_write_cycle = '1' and spi_clk_falling_edge = '1') then
        wr_enable <= '1';
        data_out <= spi_datain_shifter;
      else
        wr_enable <= '0';
      end if;
    end if;
  end process;
  
  read_output_p : process(sys_clock, sys_rst)
  begin
  if(sys_rst = '0') then
    spi_dataout_shifter <= (others => '0');
  elsif(rising_edge(sys_clock))then
    if(spi_clk_count = 8 and spi_datain_shifter = x"01" and spi_clk_falling_edge = '1')
  then
    spi_dataout_shifter <= data_in;
  elsif(spi_clk_falling_edge = '1') then
    spi_dataout_shifter <= spi_dataout_shifter(6 downto 0)& '0';
  end if;
  end if;
  end process;
  
  miso <= spi_dataout_shifter(7); -- msb send to the SPI master
end Behavioral;

--=============================================================================
-- architecture end
--=============================================================================