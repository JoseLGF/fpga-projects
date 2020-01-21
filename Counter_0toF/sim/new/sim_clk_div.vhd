----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.09.2018 18:01:59
-- Design Name: 
-- Module Name: sim_clk_div - Behavioral
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

entity sim_clk_div is
end sim_clk_div;

architecture Behavioral of sim_clk_div is
    -- components
    component clk_div
        PORT (
            clk_100: in std_logic;
            clk_1s: out std_logic
          );
    end component;
    
    -- input signals
    signal CLK: std_logic := '0';
    -- output signals
    signal CLK1S: std_logic;
    -- clock period definition
    constant CLK_period : time := 10 ns;
begin
    uut: clk_div port map(CLK, CLK1S);
    
    -- clock process
    CLK_process: process
    begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
    end process;

end Behavioral;
