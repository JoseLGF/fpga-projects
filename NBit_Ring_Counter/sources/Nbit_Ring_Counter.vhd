----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.09.2018 16:36:11
-- Design Name: 
-- Module Name: Nbit_Ring_Counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nbit_Ring_Counter is
generic ( N : integer:=4 );
port (
        CLK: in std_logic; -- clock
        RESET: in std_logic; -- reset
        Q_OUT: out std_logic_vector(N-1 downto 0) -- output
      );
end Nbit_Ring_Counter;

architecture Behavioral of Nbit_Ring_Counter is
signal not_QN: std_logic;
signal Q: std_logic_vector(N-1 downto 0):=(others => '0');
begin
not_QN <= not Q(N-1);
process (CLK, RESET)
begin
    if(RESET='1') then -- asynchronous reset
    Q <= (others => '0');
    elsif (rising_edge(CLK)) then
    Q <= Q(N-2 downto 0) & not_QN; -- switch tail ring counter
    end if;
end process;
Q_OUT <= Q;
end Behavioral;