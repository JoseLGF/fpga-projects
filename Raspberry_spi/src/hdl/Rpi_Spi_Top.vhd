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
		-- Clock in, CLK = 100 MHz
		clk : in std_logic;
		
		-- 7 segment displays
		seg	: out	std_logic_vector(7 downto 0);
		an 	: out	std_logic_vector(3 downto 0);
		
		-- leds
		led : out	std_logic_vector(7 downto 0);
		
		-- SPI Master Interface (Raspberry Pi)
		RPI_CLK  : in  std_logic; -- SPI clock
		RPI_MOSI : in  std_logic; -- SPI mosi
		RPI_SS   : in  std_logic; -- SPI slave select (active low)
		RPI_MISO : out std_logic  -- SPI miso
	);
end Rpi_Spi_Top;

architecture arch of Rpi_Spi_Top is
	-- Components    
	component SPI_Slave is
		port(
			CLK      : in  std_logic; -- system clock
			RST      : in  std_logic; -- high active synchronous reset
			-- SPI SLAVE INTERFACE
			SCLK     : in  std_logic; -- SPI clock
			CS_N     : in  std_logic; -- SPI chip select, active in low
			MOSI     : in  std_logic; -- SPI serial data from master to slave
			MISO     : out std_logic; -- SPI serial data from slave to master
			-- USER INTERFACE
			DIN      : in  std_logic_vector(7 downto 0); -- input data for SPI master
			DIN_VLD  : in  std_logic; -- when DIN_VLD = 1, input data are valid
			READY    : out std_logic; -- when READY = 1, valid input data are accept
			DOUT     : out std_logic_vector(7 downto 0); -- output data from SPI master
			DOUT_VLD : out std_logic  -- when DOUT_VLD = 1, output data are valid
		);
	end component;
	
	component sseg_dec is
    Port (      
		ALU_VAL	: in	std_logic_vector(7 downto 0); 
		SIGN	: in	std_logic;
		VALID	: in	std_logic;
		CLK		: in	std_logic;
		DISP_EN	: out std_logic_vector(3 downto 0);
		SEGMENTS: out std_logic_vector(7 downto 0)
	);
	end component;
    
	-- Signals
	signal spi_data_out			:	std_logic_vector(7 downto 0);
	signal spi_data_out_valid	:	std_logic;
	-- unused signals
	signal din			: std_logic_vector(7 downto 0) := (others => '0');
	signal din_valid	: std_logic := '0';
	signal ready		: std_logic := '0';
	

begin
	-- port maps
	spi_slave_pm : SPI_Slave
		port map (
			CLK			=> CLK,
			RST			=> '1',
			-- SPI SLAVE INTERFACE
			SCLK		=> RPI_CLK,
			CS_N		=> RPI_SS,
			MOSI		=> RPI_MOSI,
			MISO		=> RPI_MISO,
			-- USER INTERFACE
			DIN			=> din,
			DIN_VLD		=> din_valid,
			READY		=> ready,
			DOUT		=> spi_data_out,
			DOUT_VLD	=> spi_data_out_valid
		);
		
	sseg_dec_pm : sseg_dec
		port map (
			ALU_VAL		=> spi_data_out,
			SIGN		=> '0',
			VALID		=> spi_data_out_valid,
			CLK			=> CLK,
			DISP_EN		=> an,
			SEGMENTS	=> seg
		);

	led <= spi_data_out;
end arch;
