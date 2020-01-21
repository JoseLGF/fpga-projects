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

entity sim_clk_div is
end sim_clk_div;

architecture Behavioral of sim_clk_div is
    -- components
    component clk_div_400
        PORT (
            clk: in std_logic;      -- CLOCK
            sclk: out std_logic     -- Slow CLOCK (400 pulses)
          );
    end component;
    
    -- input signals
    signal CLK: std_logic := '0';
    -- output signals
    signal SCLK: std_logic;
    -- clock period definition
    constant CLK_period : time := 10 ns;
begin
    uut: clk_div_400 
        port map( clk   => CLK,
                  sclk  => SCLK);
    
    -- clock process
    CLK_process: process
    begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
    end process;

end Behavioral;
