-- Listing 15.3
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pico_top is
	port(
		clk		: in  std_logic;
		--reset	: in  std_logic;
		sw		: in  std_logic_vector(15 downto 0);
		push_n	: in  std_logic;
		push_e	: in  std_logic;
		push_s	: in  std_logic;
		push_w	: in  std_logic;
		push_c	: in  std_logic;
		led		: out std_logic_vector(15 downto 0);
		-- Seven segment display interface
		an		: out std_logic_vector(3 downto 0);
		seg		: out std_logic_vector(7 downto 0);
		-- vga interface
		Hsync		: out std_logic;
		Vsync		: out std_logic;
		vgaRed		: out std_logic_vector(3 downto 0);
		vgaGreen	: out std_logic_vector(3 downto 0);
		vgaBlue		: out std_logic_vector(3 downto 0)
	);
end pico_top;

architecture arch of pico_top is


component kcpsm6
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
	port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
	end component;


component unsigned_multiplier
    generic(             C_FAMILY : string := "7S";
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;
                    clk : in std_logic);
end component;


component sseg_dec is
    Port (
		ALU_VAL		: in std_logic_vector(7 downto 0);
		SIGN		: in std_logic;
		VALID		: in std_logic;
		CLK			: in std_logic;
		DISP_EN		: out std_logic_vector(3 downto 0);
		SEGMENTS	: out std_logic_vector(7 downto 0)
	);
end component;


component blk_ram_gen_0 is
	port (
		clka	: in  std_logic;
		ena		: in  std_logic;
		wea		: in  std_logic_vector(0 downto 0);
		addra	: in  std_logic_vector(7 downto 0);
		dina	: in  std_logic_vector(7 downto 0);
		clkb	: in  std_logic;
		addrb	: in  std_logic_vector(7 downto 0);
		doutb	: out std_logic_vector(7 downto 0)
	);
end component;


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


--
-- Signals for connection of KCPSM6 and Program Memory.
--
signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;


-- Block ram interface
signal s_wea	: std_logic_vector(0 downto 0);
signal s_addr	: std_logic_vector(7 downto 0);
signal s_dina	: std_logic_vector(7 downto 0);
signal s_doutb	: std_logic_vector(7 downto 0);


-- Vga interface
signal s_video_on	: std_logic;


begin


  processor: kcpsm6
    generic map (                 hwbuild => X"00",
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);

kcpsm6_sleep <= '0';
interrupt    <= interrupt_ack;


  program_rom: unsigned_multiplier               --Name to match your PSM file
    generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1'
    port map(      address => address,
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);


	output_ports: process(clk)
	begin
		if clk'event and clk = '1' then
			if write_strobe = '1' then
				-- Ram address register for the block ram at address 01 hex
				if port_id(0) = '1' then
					s_addr <= out_port;
				end if;
				-- Ram Data input a register at port address 02 hex
				if port_id(1) = '1' then
					s_dina(7 downto 0) <= out_port;
				end if;
				-- Ram write enable register at port address 04 hex
				if port_id(2) = '1' then
					s_wea(0) <= out_port(0);
				end if;
			end if;
		end if;
	end process output_ports;

	-- Map the LEDs to the address Register output to see its contents
	led(7  downto 0) <= s_addr;
	led(15 downto 8) <= s_dina;

	input_ports: process(clk)
	begin
		if clk'event and clk = '1' then
			case port_id(1 downto 0) is
				-- Ram Address: First 8 DIP switches at port address 00 hex
				when "00" => in_port <= sw(7 downto 0);
				-- Read 5 Push Buttons at port address 01 hex
				when "01" => in_port(0) <= push_n;
							in_port(1) <= push_e;
							in_port(2) <= push_s;
							in_port(3) <= push_w;
							in_port(4) <= push_c;
				-- Ram Data: Last 8 DIP switches at port address 00 hex
				when "10" => in_port <= sw(15 downto 8);
				when others => in_port <= "XXXXXXXX";
			end case;
		end if;
	end process input_ports;

	digit_disp : sseg_dec
    Port map(
		ALU_VAL		=> s_doutb,
		SIGN		=> '0',
		VALID		=> '1',
		CLK			=> clk,
		DISP_EN		=> an,
		SEGMENTS	=> seg
	);


	ram_mem : blk_ram_gen_0
	port map(
		clka	=> clk,
		ena		=> '1',
		wea		=> s_wea,
		addra	=> s_addr,
		dina	=> s_dina,
		clkb	=> clk,
		addrb	=> s_addr,
		doutb	=> s_doutb
	);


	vga : vga_640x480
	port map(
		clk			=> clk,
		reset		=> '0',
		hsync		=> Hsync,
		vsync		=> Vsync,
		video_on	=> s_video_on,
		p_tick		=> open,
		pixel_x		=> open,
		pixel_y		=> open
	);

	video_mux : process
	begin
		if s_video_on = '1' then
			vgaRed(3 downto 2)		<= s_doutb(1 downto 0);
			vgaGreen(3 downto 2)	<= s_doutb(3 downto 2);
			vgaBlue(3 downto 2)		<= s_doutb(5 downto 4);
		else
			vgaRed		<= "0000";
			vgaGreen	<= "0000";
			vgaBlue		<= "0000";
		end if;
	end process;
end arch;