-------------------------------------------------------------------------------
--
-- Component name: 2-bit partial product binary multiplier
-- 
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;

entity partial_product_2bit_multiplier is	
	port(
		a		: in  std_logic_vector(1 downto 0);
		b		: in  std_logic_vector(1 downto 0);
		p		: out std_logic_vector(3 downto 0)
	);
end entity;

architecture combinational of partial_product_2bit_multiplier is
	
	component half_adder is
		port(
			a     : in  std_logic;
			b     : in  std_logic;
			sum   : out std_logic;
			carry : out std_logic
		);
	end component;
	
	-- inputs multiplication values
	signal a0b0 : std_logic := '0';
	signal a0b1 : std_logic := '0';
	signal a1b0 : std_logic := '0';
	signal a1b1 : std_logic := '0';
	
	-- half adders intermediate values
	signal ha1_carry : std_logic := '0';
	
begin
	
	-- assign multipication values
	a0b0 <= a(0) and b(0);
	a0b1 <= a(0) and b(1);
	a1b0 <= a(1) and b(0);
	a1b1 <= a(1) and b(1);
	
	p(0) <= a0b0;
	
	ha1_pm : half_adder port map (
			a		=> a1b0,
			b		=> a0b1,
			sum		=> p(1),
			carry	=> ha1_carry
		);
	
	ha2_pm : half_adder port map (
			a		=> a1b1,
			b		=> ha1_carry,
			sum		=> p(2),
			carry	=> p(3)
		);
	
end combinational;