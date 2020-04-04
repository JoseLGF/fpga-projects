-------------------------------------------------------------------------------
--
-- Component name: Generic N-bit parallel subtractor
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;

entity parallel_subtractor_n_bit is
	generic (
		-- n must be >= 2 for this component to synthesize properly
		-- parallel subtractor n
		ps_n	: integer := 4
	);
	
	port(
		X		: in  std_logic_vector(ps_n-1 downto 0);
		Y		: in  std_logic_vector(ps_n-1 downto 0);
		DIFF	: out std_logic_vector(ps_n-1 downto 0);
		BORROW	: out std_logic
	);
end entity;

architecture gen of parallel_subtractor_n_bit is

	component parallel_adder is
		generic (
			-- n must be >= 2 for this component to synthesize properly
			n	: integer := 4
		);
		port (
			A		: in  std_logic_vector(ps_n-1 downto 0);
			B		: in  std_logic_vector(ps_n-1 downto 0);
			C0		: in  std_logic;
			Sum		: out std_logic_vector(ps_n   downto 0)
		);
	end component;
	
	component half_adder is
		port(
			a     : in  std_logic;
			b     : in  std_logic;
			sum   : out std_logic;
			carry : out std_logic
		);
	end component;
	
	-- Parallel adder sums
	signal pa_sums			: std_logic_vector(ps_n   downto 0) := (others => '0');
	
	-- half adder signals
	signal ha_out_carries	: std_logic_vector(ps_n-1 downto 0) := (others => '0');
	signal ha_ins_a			: std_logic_vector(ps_n-1 downto 0) := (others => '0');
	signal ha_ins_b			: std_logic_vector(ps_n-1 downto 0) := (others => '0');
	signal ha_sums			: std_logic_vector(ps_n-1 downto 0) := (others => '0');
	
	signal not_Y			: std_logic_vector(ps_n-1 downto 0) := (others => '0');
	
begin
	
	-- Parallel adder port mapping
	pa_pm : parallel_adder		 
	generic map (
		n => ps_n
	)
	
	port map (
		A		=> X,
		B		=> not_Y,
		C0		=> '1',
		Sum		=> pa_sums
	);
	
	-- generate half adder port mappings
	gen_ha_pm:
	for I in 0 to ps_n-1 generate
		ha_gpm : half_adder port map (
			a		=> ha_ins_a(I),
			b		=> ha_ins_b(I),
			sum		=> ha_sums(I),
			carry	=> ha_out_carries(I)
		);
   end generate gen_ha_pm;
   
   BORROW <= not pa_sums(ps_n);
   
   -- Xor's connections
	xors_conns : for j in 0 to ps_n-1 generate
		ha_ins_a(j) <= pa_sums(j) xor ( not pa_sums(ps_n) );
	end generate;
	
	-- Connect output carries to b inputs on half adders
	ha_carries_b_gen : for k in 1 to ps_n-1 generate
		ha_ins_b(k) <= ha_out_carries(k-1);
	end generate;
	
	-- Borrow is LSB in half adders
	ha_ins_b(0) <= not pa_sums(ps_n);
	
	-- assign half adder sums as difference port
	DIFF <= ha_sums;
	
	-- negate Y input
	not_Y <= not Y;
	
end gen;