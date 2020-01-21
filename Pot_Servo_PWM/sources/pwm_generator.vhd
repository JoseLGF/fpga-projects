library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_generator is
  Port (    clk400      :  in std_logic;
            pulse_width :  in std_logic_vector (7 downto 0);
            pwm_out     :  out std_logic );
end pwm_generator;

architecture Behavioral of pwm_generator is
    constant max_count : integer := (5000);
    signal PWMout : std_logic := '0';
begin
   pwm: process (clk400,pulse_width)
      variable pulse_counter : integer := 0;
   begin
      if (rising_edge(clk400)) then
         if (pulse_counter < (to_integer(unsigned(pulse_width)) + 250)) then
               PWMout <= '1';
         else
               PWMout <= '0';
         end if;
         if (pulse_counter >= MAX_COUNT) then 
            PWM_out <= '0'; 
            pulse_counter := 0; 
         else
            pulse_counter := pulse_counter + 1; 
         end if; 
      end if; 
      pwm_out <= PWMout; 
   end process pwm; 
end Behavioral;
