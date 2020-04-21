library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_640x480 is
	port (
		clk			:	in	std_logic;
		reset		:	in	std_logic;
		hsync		:	out	std_logic;
		vsync		:	out	std_logic;
		video_on	:	out	std_logic;
		p_tick		:	out	std_logic;
		pixel_x		:	out	std_logic_vector(9 downto 0);
		pixel_y		:	out	std_logic_vector(9 downto 0)
	);
end entity;

architecture arch of vga_640x480 is
	-- VGA 640x480 sync parameters
	constant HD	:	integer := 640;	-- horizontal display area
	constant HF :	integer := 16;	-- horizontal front porch
	constant HB	:	integer := 48;	-- horizontal back porch
	constant HR	:	integer	:= 96;	-- horizontal retrace
	constant VD	:	integer := 480;	-- vertical display area
	constant VF :	integer := 10;	-- vertical front porch
	constant VB	:	integer := 33;	-- vertical back porch
	constant VR	:	integer	:= 2;	-- vertical retrace
	
	-- mod-4 counter
	signal mod4_reg, mod4_next : std_logic_vector(1 downto 0) := "00";
	-- sync counters
	signal v_count_reg, v_count_next : unsigned(9 downto 0) := "0000000000";
	signal h_count_reg, h_count_next : unsigned(9 downto 0) := "0000000000";
	-- output buffer
	signal v_sync_reg, h_sync_reg : std_logic := '0';
	signal v_sync_next, h_sync_next : std_logic := '0';
	-- status signal
	signal h_end, v_end, pixel_tick: std_logic := '0';
	
begin

	-- registers
	process (clk, reset)
	begin
		if reset = '1' then
			mod4_reg	<= (others => '0');
			v_count_reg	<= (others => '0');
			h_count_reg	<= (others => '0');
			v_sync_reg	<= '0';
			h_sync_reg	<= '0';
		elsif (clk'event and clk='1') then
			mod4_reg 	<= mod4_next;
			v_count_reg	<= v_count_next;
			h_count_reg	<= h_count_next;
			v_sync_reg	<= v_sync_next;
			h_sync_reg	<= h_sync_next;
		end if;
	end process;
	
	
	-- 25 MHz pixel tick
	pixel_tick	<= '1' when mod4_reg = "11" else '0';
	-- status
	h_end		<= -- en of horizontal counter
		'1' when h_count_reg = (HD+HF+HB+HR-1) else -- 799
		'0';
	v_end		<= -- end of vertical counter
		'1' when v_count_reg = (VD+VF+VB+VR-1) else -- 524
		'0';
	
	-- mod-4 circuit to generate a 25 MHz enable tick from 100 MHz sys clock
	mod4_next <=
	"00" when mod4_reg = "11"
	else
	std_logic_vector(to_unsigned(to_integer(unsigned( mod4_reg )) + 1, 2));
	
	
	-- mod-800 horizontal sync counter
	process (h_count_reg, h_end, pixel_tick)
	begin
		if pixel_tick = '1' then -- 25 Mhz tick
			if h_end='1' then
				h_count_next <= (others => '0');
			else
				h_count_next <= h_count_reg + 1;
			end if;
		else
			h_count_next <= h_count_reg;
		end if;
	end process;
	
	-- mod-525 vertical sync counter
	process (v_count_reg, h_end, v_end, pixel_tick)
	begin
		if pixel_tick='1' and h_end='1' then
			if (v_end = '1') then
				v_count_next <= (others => '0');
			else
				v_count_next <= v_count_reg + 1;
			end if;
		else
			v_count_next <= v_count_reg;
		end if;
	end process;
	
	-- horizontal and vertical sync, buffered to avoid glitch
	h_sync_next <=
		'1' when (h_count_reg >= (HD+HF))
			and (h_count_reg <= (HD+HF+HR-1)) else
		'0';
	v_sync_next <=
		'1' when	(v_count_reg >= (VD+VF))
			and		(v_count_reg <= (VD+VF+VR-1)) else
		'0';
	
	-- video on/off
	video_on <=
		'1'	when	(h_count_reg<HD) and (v_count_reg < VD) else
		'0';
	
	-- output signal
	hsync <= h_sync_reg;
	vsync <= v_sync_reg;
	pixel_x <= std_logic_vector(h_count_reg);
	pixel_y <= std_logic_vector(v_count_reg);
	p_tick	<= pixel_tick;
	
end architecture;