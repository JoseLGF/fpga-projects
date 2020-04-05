----------------------------------------------------------------------------------
--
-- Component Name: MAC unit testbench
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mac_8bit_nsamples_tb is
end mac_8bit_nsamples_tb;

architecture sim of mac_8bit_nsamples_tb is
	-- constant declaration for generics instantiating
	constant N : integer := 10;

    -- components
    component mac_8bit_nsamples is
		generic (
			N_samples	: integer := 10
		);
		
		port(
			in_1		:	in	std_logic_vector(7 downto 0);
			in_2		:	in	std_logic_vector(7 downto 0);
			clk			:	in	std_logic;
			nrst		:	in	std_logic;
			mac_out		:	out	std_logic_vector(N_samples + 16 downto 0)
		);
	end component;
    
    -- input signals
    signal in_1		: std_logic_vector(7 downto 0) := "00000000";
	signal in_2		: std_logic_vector(7 downto 0) := "00000000";
	signal clk		: std_logic := '0';
	signal nrst		: std_logic := '0';
	signal mac_out	: std_logic_vector(N + 16 downto 0);

begin

    UUT : mac_8bit_nsamples 
	generic map (
		N_samples => N
	)
	
	port map(
		in_1	=>	in_1,
		in_2	=>	in_2,
		clk		=>	clk,
		nrst	=>	nrst,
		mac_out	=>	mac_out
	);
	
	-- system clock
	process begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;
	
	-- reset signal active low
	process begin
		nrst <= '0';
		wait for 1 ns;
		nrst <= '1';
		wait for 300 ns;
	end process;
	
    -- load values in the mac address in the rising edge
	process begin
		-- First values
		in_1 <= "00000000";
		in_2 <= "00000000";
		wait for 10 ns;
		in_1 <= "00000001";--1
		in_2 <= "00000101";--5
		wait for 20 ns;
		in_1 <= "00000010";--2
		in_2 <= "00000110";--6
		wait for 20 ns;
		in_1 <= "00000011";--3
		in_2 <= "00000111";--7
		wait for 20 ns;
		in_1 <= "00000100";--4
		in_2 <= "00001000";--8
		wait for 20 ns;
		in_1 <= "00000000";--0
		in_2 <= "00000000";--0
		wait for 20 ns;
		in_1 <= "00000001";--1
		in_2 <= "00000101";--5
		wait for 20 ns;
		in_1 <= "00000010";--2
		in_2 <= "00000110";--6
		wait for 20 ns;
		in_1 <= "00000011";--3
		in_2 <= "00000111";--7
		wait for 20 ns;
		in_1 <= "00000100";--4
		in_2 <= "00001000";--8
		wait for 20 ns;
		in_1 <= "00000101";--5
		in_2 <= "00001001";--9
		wait for 20 ns;

	end process;
end sim;
