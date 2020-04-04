----------------------------------------------------------------------------------
--
-- Component Name: Generic N-bit parallel subtractor testbench
-- Description:
-- A simulation to test the proper behavior of full subtractor component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity parallel_subtractor_tb is
end parallel_subtractor_tb;

architecture sim of parallel_subtractor_tb is
	-- constant declaration for generics instantiating
	constant N : integer := 4;

    -- components
    component parallel_subtractor_n_bit is
		generic (
			-- n must be >= 2 for this component to synthesize properly
			ps_n	: integer := 4
		);
		
		port(
			X		: in  std_logic_vector(n-1 downto 0);
			Y		: in  std_logic_vector(n-1 downto 0);
			DIFF	: out std_logic_vector(n-1 downto 0);
			BORROW	: out std_logic
		);
	end component;
    
    -- input signals
    signal X		: std_logic_vector(n-1 downto 0) := "0000";
	signal Y		: std_logic_vector(n-1 downto 0) := "0000";
	signal DIFF		: std_logic_vector(n-1 downto 0) := "0000";
	signal BORROW	: std_logic := '0';

begin
    parallel_subtractor_pm: parallel_subtractor_n_bit 
	generic map (
		ps_n => N
	)
	
	port map(
		X		=> X,
		Y		=> Y,
		DIFF	=> DIFF,
		BORROW	=> BORROW
	);

    -- Subtractor values iteration
	process begin
		wait for 10 ns;
		X <= std_logic_vector( unsigned(X) + 1 );
	end process;
	
	process begin
		wait for 160 ns;
		Y <= std_logic_vector ( unsigned(Y) + 1);
	end process;
	
end sim;
