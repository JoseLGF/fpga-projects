-------------------------------------------------------------------------------
--
-- Component name: Generic N-bit parallel adder
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity parallel_adder is
	generic (
		-- n must be >= 2 for this component to synthesize properly
		n	: integer := 4
	);
	port (
		A		: in  std_logic_vector(n-1 downto 0);
		B		: in  std_logic_vector(n-1 downto 0);
		C0		: in  std_logic;
		Sum		: out std_logic_vector(n   downto 0)
	);
end entity;

architecture gen of parallel_adder is

	component full_adder is
	port(
		a    : in  std_logic;
		b    : in  std_logic;
		cin  : in  std_logic;
		sum  : out std_logic;
		cout : out std_logic
	);
	end component;
	
	--signals
	signal carries : std_logic_vector(n+1 downto 0) := (others => '0');
	
begin

	GEN_REG: 
	for I in 0 to n-1 generate
		-- full adder generic port mapping
		fa_gpm : full_adder port map (
			a		=> A(I),
			b		=> B(I),
			cin		=> carries(I),
			sum		=> Sum(I),
			cout	=> carries(I+1)
		);
   end generate GEN_REG;
   
   -- Last carry is Sum's MSB
   Sum(n) <= carries(n);
   -- first carry is C0
   carries(0) <= C0;
   
end gen;
