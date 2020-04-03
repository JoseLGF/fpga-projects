-------------------------------------------------------------------------------
-- Component name: full subtractor
-- Description:
-- full subtractor component that can be used as a building block other components.
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity full_subtractor is
	port(
		x		: in  std_logic;
		y		: in  std_logic;
		b_in	: in  std_logic; -- Borrow in
		diff	: out std_logic;
		borrow	: out std_logic
	);
end entity;

architecture mixed of full_subtractor is

	component half_subtractor
        port (
			x		: in  std_logic;
			y		: in  std_logic;
			diff	: out std_logic;
			borrow	: out std_logic
		);
    end component;
	
	signal int_diff		: std_logic := '0';
	signal int_borrow_1	: std_logic := '0';
	signal int_borrow_2	: std_logic := '0';

begin
	
	hs1_pm : half_subtractor port map
	(
		x		=> x,
		y		=> y,
		diff	=> int_diff,
		borrow	=> int_borrow_1
	);
	
	hs2_pm : half_subtractor port map
	(
		x		=> int_diff,
		y		=> b_in,
		diff	=> diff,
		borrow	=> int_borrow_2
	);
	
	borrow <= int_borrow_1 or int_borrow_2;
	
end mixed;
