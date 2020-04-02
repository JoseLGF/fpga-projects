-------------------------------------------------------------------------------
--
-- Component name: parallel input serial output shift register
-- Description:
-- PISO shift register that can be used as a block other components.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity piso_shift_register is
	port (
		din		: in  std_logic_vector(3 downto 0);
		clk		: in  std_logic;
		temp	: in  std_logic;
		ctrl	: in  std_logic;
		dout	: out std_logic
	);
end entity;

architecture Behavioral of piso_shift_register is

	component D_FlipFlop is
		Port (
			DATAIN     : in  std_logic;
			CLK        : in  std_logic;
			ENABLE     : in  std_logic;
			DATAOUT    : out std_logic;
			NOTDATAOUT : out std_logic
	);
	end component;
	
	component mux_2in_1out is
		port(
			d_in_0	: in  std_logic;
			d_in_1	: in  std_logic;
			d_out	: out std_logic;
			sel		: in  std_logic
		);
	end component;
	
	--signal data_in	: std_logic_vector(3 downto 0);
	signal dff_outs	: std_logic_vector(2 downto 0);
	signal mux_outs : std_logic_vector(3 downto 0);
	
begin

	mux0_pm : mux_2in_1out
		port map (
			d_in_0	=> din(0),
			d_in_1  => temp,
			d_out	=> mux_outs(0),
			sel		=> ctrl
		);
		
	mux1_pm : mux_2in_1out
		port map (
			d_in_0	=> din(1),
			d_in_1  => dff_outs(0),
			d_out	=> mux_outs(1),
			sel		=> ctrl
		);
		
	mux2_pm : mux_2in_1out
		port map (
			d_in_0	=> din(2),
			d_in_1  => dff_outs(1),
			d_out	=> mux_outs(2),
			sel		=> ctrl
		);
		
	mux3_pm : mux_2in_1out
		port map (
			d_in_0	=> din(3),
			d_in_1  => dff_outs(2),
			d_out	=> mux_outs(3),
			sel		=> ctrl
		);
		
	dff0_pm : D_FlipFlop
		port map (
			DATAIN		=> mux_outs(0),
			CLK			=> clk,
			ENABLE		=> '1',
			DATAOUT		=> dff_outs(0),
			NOTDATAOUT	=> open
		);
		
	dff1_pm : D_FlipFlop
		port map (
			DATAIN		=> mux_outs(1),
			CLK			=> clk,
			ENABLE		=> '1',
			DATAOUT		=> dff_outs(1),
			NOTDATAOUT	=> open
		);
		
	dff2_pm : D_FlipFlop
		port map (
			DATAIN		=> mux_outs(2),
			CLK			=> clk,
			ENABLE		=> '1',
			DATAOUT		=> dff_outs(2),
			NOTDATAOUT	=> open
		);
	
	dff3_pm : D_FlipFlop
		port map (
			DATAIN		=> mux_outs(3),
			CLK			=> clk,
			ENABLE		=> '1',
			DATAOUT		=> dout,
			NOTDATAOUT	=> open
		);
		
end Behavioral;
