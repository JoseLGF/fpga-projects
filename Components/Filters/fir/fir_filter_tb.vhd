----------------------------------------------------------------------------------
--
-- Component Name: FIR filter testbench.
--
----------------------------------------------------------------------------------

Library IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.numeric_std.all;
Use STD.TEXTIO.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture behavioral of fir_filter_tb is
Component fir_filter is
	generic (
		input_width		: integer	:= 8;	-- set input width by user
		output_width	: integer	:= 16;	-- set output width by user
		coef_width		: integer	:= 8;	-- set coefficient width by user
		tap				: integer	:= 11;	-- set filter order
		guard			: integer	:= 4		-- log2(tap)+1
	);
	port(
		Din		: in	std_logic_vector(input_width-1 downto 0);	-- input data
		Clk		: in	std_logic;									-- input clk
		reset	: in	std_logic;									-- input reset
		Dout	: out	std_logic_vector(output_width-1 downto 0)	-- output data
	);
end Component;


signal	Din				: std_logic_vector(7 downto 0);
signal	Clk				: std_logic := '0';
signal	reset			: std_logic := '1';
signal	output_ready	: std_logic := '0';
signal	Dout			: std_logic_vector(15 downto 0);
signal	input			: std_logic_vector(7 downto 0);
file	my_input		: text open READ_MODE	is "input101.txt";
file	my_output		: text open WRITE_MODE	is "output101_functional_sim.txt";

begin

	FIR_int : fir_filter
		generic map (
			input_width		=> 8,
			output_width	=> 16,
			coef_width		=> 8,
			tap				=> 11,
			guard			=> 0
		)

		port map (
			Din		=> Din,
			Clk		=> Clk,
			reset	=> reset,
			Dout	=> Dout
		);

	process(clk)
	begin
		Clk	<= not Clk after 10 ns;
	end process;

	reset	<= '1', '1' after 100 ns, '0' after 503 ns;

	-- Writing output result to output file
	process(clk)
		variable my_input_line : line;
		variable input1: integer;
	begin
		if reset ='1' then
			Din <= (others=> '0');
			input <= (others=> '0');
			output_ready <= '0';
		elsif rising_edge(clk) then
			if not endfile(my_input) then
				readline(my_input, my_input_line);
				read(my_input_line,input1);
				Din <= std_logic_vector(to_signed(input1, 8));
				output_ready <= '1';
			end if;
		end if;
	end process;

	process(clk)
		variable my_output_line : line;
		variable input1 : integer;
	begin
		if falling_edge(clk) then
			if output_ready ='1' then
				write(my_output_line, to_integer(signed(Dout)));
				writeline(my_output, my_output_line);
			end if;
		end if;
	end process;

 end Architecture;