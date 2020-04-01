----------------------------------------------------------------------------------
--
-- Module Name: RAM memory testbench
-- Description: A simulation to test the proper behavior of ram memory component
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_memory_tb is
end ram_memory_tb;

architecture test of ram_memory_tb is
	-- constant declaration for generics instantiating
	constant RAM_WIDTH : integer := 8;
	constant RAM_DEPTH : integer := 4;
	constant RAM_ADDR  : integer := 2;

    -- components
	component ram_memory is
		generic (
			width	: integer := 8;
			depth	: integer := 4;
			addr	: integer := 2
		);

		port (
			clk			: in  std_logic;
			write		: in  std_logic;
			read		: in  std_logic;
			addrs		: in  std_logic_vector(addr-1 downto 0);
			data_out	: out std_logic_vector(width-1 downto 0);
			data_in		: in  std_logic_vector(width-1 downto 0)
		);
	end component;

    -- input signals
    signal clk		: std_logic := '0';
	signal write	: std_logic := '0';
	signal read		: std_logic := '0';
	signal addrs	: std_logic_vector(RAM_ADDR-1  downto 0) := "00";
	signal data_in	: std_logic_vector(RAM_WIDTH-1 downto 0) := "00000000";
	-- output signals
	signal d_out	: std_logic_vector(RAM_WIDTH-1 downto 0) := "00000000";

begin
    ram_memory_gm : ram_memory
	generic map (
		width	=> RAM_WIDTH,
		depth	=> RAM_DEPTH,
		addr	=> RAM_ADDR
	)
	
	port map(
		clk			=> clk,
		write		=> write,
		read		=> read,
		addrs		=> addrs,
		data_out	=> d_out,
		data_in		=> data_in
	);
	
	-- 100 Mhz Clock
    process begin
	clk <= '0';
    wait for 10 ns;
	clk <= '1';
    wait for 10 ns;
    end process;
	
	process begin
	-- Ram sweep initial values check
	-- data is captured in the rising edge of clk
	-- Verify RAM init data [0 - 100 ns]
	write <= '0';
	read  <= '1';
	wait for 20 ns;
	addrs <= "00";
	wait for 20 ns;
	addrs <= "01";
	wait for 20 ns;
	addrs <= "10";
	wait for 20 ns;
	addrs <= "11";
	wait for 20 ns;

	-- Write process
	write <= '1';
	read  <= '0';
	-- Write X"BB" in address 00 (T=100 ns)
	addrs   <= "00";
	data_in <= X"BB";
	wait for 20 ns;
	-- Write X"AA" in address 01
	addrs   <= "01";
	data_in <= X"AA";
	wait for 20 ns;
	-- Write X"DD" in address 10
	addrs   <= "10";
	data_in <= X"DD";
	wait for 20 ns;
	-- Write X"EE" in address 11
	addrs   <= "11";
	data_in <= X"EE";
	wait for 20 ns;
	
	-- Read the data back
	-- Set the memory in read mode and set read address
	write <= '0';
	read  <= '1';
	addrs   <= "00";
	wait for 20 ns;
	addrs   <= "01";
	wait for 20 ns;
	addrs   <= "10";
	wait for 20 ns;
	addrs   <= "11";
	wait for 20 ns;
	wait;
	end process;
	
end test;
