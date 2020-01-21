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

entity sim_pwm_generator is
end sim_pwm_generator;

architecture Behavioral of sim_pwm_generator is
    -- components
    component pwm_generator is
      Port (    clk400      :  in std_logic;
                pulse_width :  in std_logic_vector (7 downto 0);
                pwm_out     :  out std_logic );
    end component;
    
    -- input signals
    signal s_clk:       std_logic := '0';               -- input clock
--    signal s_pulse:     std_logic_vector (7 downto 0) := "11111111";  -- 2 ms pulse
--    signal s_pulse:     std_logic_vector (7 downto 0) := "00000000";  -- 1 ms pulse
    signal s_pulse:     std_logic_vector (7 downto 0) := "10000000";  -- 1.5 ms pulse
    -- output signals
    signal s_pwm_out: std_logic; 
    
    -- clock period definition (the pwm_generator is fed by a 400x slower clock)
    constant CLK_period : time := 4000 ns;
begin

    pwm_pm: pwm_generator 
        port map( clk400      => s_clk,
                  pulse_width => s_pulse,
                  pwm_out     => s_pwm_out
                  );
    
    -- clock process
    CLK_process: process
    begin
    s_clk <= '0';
    wait for CLK_period/2;
    s_clk <= '1';
    wait for CLK_period/2;
    end process;

end Behavioral;
