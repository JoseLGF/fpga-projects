library ieee;
use ieee.std_logic_1164.all;

entity vga_test is
	port (
		clk, reset		:	in	std_logic;
		sw				:	in	std_logic_vector(2 downto 0);
		hsync, vsync	:	out	std_logic;
		rgb				:	out	std_logic_vector(2 downto 0)
	);
end vga_test;

architecture arch of vga_test is
    component vga_640x480 is
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
    end component;

	signal	rgb_reg		:	std_logic_vector(2 downto 0) := "000";
	signal	video_on	:	std_logic := '1';
	signal	s_clk		:	std_logic := '0';
	signal	s_reset		:	std_logic := '0';

begin
	vga_sync_unit : vga_640x480
		port map (
			clk			=> s_clk,
			reset		=> s_reset,
			hsync		=> hsync,
			vsync		=> vsync,
			video_on	=> video_on,
			p_tick		=> open,
			pixel_x		=> open,
			pixel_y		=> open
		);
		
	-- rgb buffer
	process (s_clk, s_reset)
	begin
		if s_reset = '1' then
			rgb_reg	<= (others => '0');
		elsif (s_clk'event and s_clk='1') then
			rgb_reg <= sw;
		end if;
	end process;
	rgb <= rgb_reg;
	
	-- clock
	process begin
		s_clk <= '0';
		wait for 5 ns;
		s_clk <= '1';
		wait for 5 ns;
	end process;
	
	-- clock
	process begin
		s_reset <= '0';
		wait for 50 ns;
		s_reset <= '1';
		wait for 50 ns;
		s_reset <= '0';
		wait;
	end process;
end arch;