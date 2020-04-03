----------------------------------------------------------------------------------
--
-- Module Name: parallel adder testbench
-- Description:
-- A simulation to test the proper behavior of parallel adder component.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;
USE ieee.numeric_std.ALL;

entity parallel_adder_tb is
end parallel_adder_tb;

architecture test of parallel_adder_tb is
	-- constant declaration for generics instantiating
	constant N : integer := 4;

    -- components
    component parallel_adder
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
    end component;
    
	
	signal A		: std_logic_vector	(N-1 downto 0) := "0000";
	signal B		: std_logic_vector	(N-1 downto 0) := "0000";
	signal Sum		: std_logic_vector	(N   downto 0) := "00000";
	signal C0		: std_logic := '0';

begin

    parallel_adder_pm: parallel_adder
	generic map (
		n => N
	)
	
	port map(
		A	=> A,
		B	=> B,
		C0	=> C0,
		Sum	=> Sum
	);
	
	-- Adder values iteration
	process begin
		wait for 10 ns;
		A <= std_logic_vector( unsigned(A) + 1 );
	end process;
	
	process begin
		wait for 160 ns;
		B <= STD_LOGIC_VECTOR ( unsigned(B) + 1);
	end process;
	
	process begin
		wait for 2560 ns;
		C0 <= '1';
	end process;
	
end test;
