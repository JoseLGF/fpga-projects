-- Listing 15.3
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pico_top is
	port(
		clk		: in  std_logic;
		--reset	: in  std_logic;
		sw		: in  std_logic_vector(7 downto 0);
		push_n	: in  std_logic;
		push_e	: in  std_logic;
		push_s	: in  std_logic;
		push_w	: in  std_logic;
		push_c	: in  std_logic;
		led		: out std_logic_vector(7 downto 0);
		led_n	: out std_logic;
		led_e	: out std_logic;
		led_s	: out std_logic;
		led_w	: out std_logic;
		led_c	: out std_logic;
		-- Seven segment display interface
		an		: out std_logic_vector(3 downto 0);
		seg		: out std_logic_vector(7 downto 0)
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

--
-- Signals for connection of Seven segment decoder
--
signal sseg_val : std_logic_vector(7 downto 0);


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
				-- 8 General purpose LEDs at port address 01 hex
				if port_id(0) = '1' then
					led <= out_port;
				end if;
				-- Direction LEDs at port address 02 hex
				if port_id(1) = '1' then
					led_n <= out_port(0);
					led_e <= out_port(1);
					led_s <= out_port(2);
					led_w <= out_port(3);
					led_c <= out_port(4);
				end if;
				-- Seven segment display at port address 04 hex
				if port_id(2) = '1' then
					sseg_val <= out_port;
				end if;
			end if;
		end if;
	end process output_ports;


	input_ports: process(clk)
	begin
		if clk'event and clk = '1' then
			case port_id(0) is
				-- Read 8 DIP switches at port address 00 hex
				when '0' => in_port <= sw;
				-- Read 5 Push Buttons at port address 01 hex
				when '1' => in_port(0) <= push_n;
							in_port(1) <= push_e;
							in_port(2) <= push_s;
							in_port(3) <= push_w;
							in_port(4) <= push_c;
				when others => in_port <= "XXXXXXXX";
			end case;
		end if;
	end process input_ports;
	
	digit_disp : sseg_dec
    Port map(
		ALU_VAL		=> sseg_val,
		SIGN		=> '0',
		VALID		=> '1',
		CLK			=> clk,
		DISP_EN		=> an,
		SEGMENTS	=> seg
	);

end arch;