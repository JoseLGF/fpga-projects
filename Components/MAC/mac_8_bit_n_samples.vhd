-------------------------------------------------------------------------------
--
-- Component name: MAC unit to multiply and accumulate N 8-bit samples.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mac_8bit_nsamples is
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
end entity;

architecture Behavioral of mac_8bit_nsamples is

	signal	mulreg	:	integer range 0 to 65537;
	signal	addreg	:	std_logic_vector(N_samples + 16 downto 0) := (others => '0');
	signal	prv_val	:	std_logic_vector(N_samples + 16 downto 0) := (others => '0');
	signal	temp	:	std_logic_vector(N_samples - 1  downto 0) := (others => '0');
	signal	accm	:	std_logic_vector(16				downto 0) := (others => '0');
	signal	cnt		:	integer range 0 to N_samples;
	
begin
	
	mulreg <= to_integer(unsigned(in_1)) * to_integer(unsigned(in_2));
	accm   <= std_logic_vector(to_unsigned(mulreg, 17));
	addreg <= prv_val + (temp & accm);
	
	
	process (clk, nrst) begin
		-- active low reset the mac unit
		if (nrst = '0') then
			prv_val	<= (others => '0');
			temp 	<= (others => '0');
			cnt  	<= 0;
		else
			-- values are captured in the falling edge
			if (falling_edge(clk)) then
				prv_val <= addreg;
				if (cnt = N_samples) then
					mac_out <= addreg;
					cnt <= 0;
					prv_val <= (others => '0');
				else
					cnt <= cnt + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;