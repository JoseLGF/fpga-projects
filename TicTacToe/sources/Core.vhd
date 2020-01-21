-- Core entity for the Tic Tac Toe game

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Core is
    Port (
               CLK            : in  std_logic;
               btnU           : in  std_logic;
               btnD           : in  std_logic;
               btnL           : in  std_logic;
               btnR           : in  std_logic;
               btnC           : in  std_logic;
               red            : out std_logic_vector(8 downto 0);
               green          : out std_logic_vector(8 downto 0);
               blue           : out std_logic_vector(8 downto 0);
               o_red_win      : out std_logic;
               o_blue_win     : out std_logic
               --p_turn         : out std_logic -- who's turn it is
         );
end Core;

architecture Behavioral of Core is
               signal Pn, Pp  : std_logic_vector(8 downto 0) := "000010000"; -- Square pointers
               signal s_r     : std_logic_vector(8 downto 0) := "000000000"; -- red tokens
               signal s_b     : std_logic_vector(8 downto 0) := "000000000"; -- blue tokens
               signal Tp, Tn  : std_logic; -- Present turn, next turn
               signal red_win   : std_logic := '0'; 
               signal blue_win   : std_logic := '0'; 
begin

-- pointer process
-- Function:A player can move a green square that points to the location where the move will be made, if the square is empty.
pointer: process(CLK, btnU, btnL, btnR, btnD) begin 
    if (falling_edge(CLK)) then 
        if (btnU='1') then
            case Pp is
                when "100000000" => Pn <= "100000000";
                when "010000000" => Pn <= "010000000";
                when "001000000" => Pn <= "001000000";
                when "000100000" => Pn <= "100000000";
                when "000010000" => Pn <= "010000000";
                when "000001000" => Pn <= "001000000";
                when "000000100" => Pn <= "000100000";
                when "000000010" => Pn <= "000010000";
                when "000000001" => Pn <= "000001000";
                when others      => Pn <= "100000000";
            end case;
        elsif (btnD='1') then
            case Pp is
                when "100000000" => Pn <= "000100000";
                when "010000000" => Pn <= "000010000";
                when "001000000" => Pn <= "000001000";
                when "000100000" => Pn <= "000000100";
                when "000010000" => Pn <= "000000010";
                when "000001000" => Pn <= "000000001";
                when "000000100" => Pn <= "000000100";
                when "000000010" => Pn <= "000000010";
                when "000000001" => Pn <= "000000001";
                when others      => Pn <= "100000000";
            end case;
        elsif (btnL='1') then
            case Pp is
                when "100000000" => Pn <= "100000000";
                when "010000000" => Pn <= "100000000";
                when "001000000" => Pn <= "010000000";
                when "000100000" => Pn <= "000100000";
                when "000010000" => Pn <= "000100000";
                when "000001000" => Pn <= "000010000";
                when "000000100" => Pn <= "000000100";
                when "000000010" => Pn <= "000000100";
                when "000000001" => Pn <= "000000010";
                when others      => Pn <= "100000000";
            end case;
        elsif (btnR='1') then
            case Pp is
                when "100000000" => Pn <= "010000000";
                when "010000000" => Pn <= "001000000";
                when "001000000" => Pn <= "001000000";
                when "000100000" => Pn <= "000010000";
                when "000010000" => Pn <= "000001000";
                when "000001000" => Pn <= "000001000";
                when "000000100" => Pn <= "000000010";
                when "000000010" => Pn <= "000000001";
                when "000000001" => Pn <= "000000001";
                when others      => Pn <= "100000000";
            end case;
        end if;
    end if;
 end process;

     green (8 downto 0) <= Pn(8 downto 0);
     Pp <= Pn;

-- move process:
-- Function: By pressing the Center button, the player is able to make his next move in the current square, if it is empty.
     move: process(CLK, btnC) begin 
         if (falling_edge(CLK)) then 
             if (btnC='1') then 
                 -- if th game is in a "won" state, reset everything
                 if (red_win='1' 
                    or blue_win='1' 
                    or (s_r xor s_b)="111111111") then
                     s_r      <= "000000000";
                     s_b      <= "000000000";
                     Tn       <= '0';
                     red_win  <= '0';
                     blue_win <= '0';

                 elsif (Tp='0') then -- 0: Blue
                     --s_b <= s_b or Pn;
                     Tn  <= '1' when (Pn and (s_r or s_b)) = b"000000000" else '0';
                     s_b <= ((not (s_b or s_r)) and Pn) or s_b;
                 else -- 1: Red
                     --s_r <= s_r or Pn; -- if the square is empty, mark it
                     Tn  <= '0' when (Pn and (s_r or s_b)) = b"000000000" else '1';
                     s_r <= ((not (s_b or s_r)) and Pn) or s_r;
                  end if;
                end if;
            end if;

        -- Determines if a player has won the game
       red_win <= (s_r(8) and s_r(7) and s_r(6)) -- top   row red
               or (s_r(5) and s_r(4) and s_r(3)) -- mid   row red 
               or (s_r(2) and s_r(1) and s_r(0)) -- low   row red 
               or (s_r(8) and s_r(5) and s_r(2)) -- left  col red 
               or (s_r(7) and s_r(4) and s_r(1)) -- mid   col red 
               or (s_r(6) and s_r(3) and s_r(0)) -- right col red 
               or (s_r(8) and s_r(4) and s_r(0)) -- diag  UL  red 
               or (s_r(2) and s_r(4) and s_r(6)) -- diag  BL  red 
               ;
      blue_win <= (s_b(8) and s_b(7) and s_b(6)) -- top   row blue
               or (s_b(5) and s_b(4) and s_b(3)) -- mid   row blue
               or (s_b(2) and s_b(1) and s_b(0)) -- low   row blue
               or (s_b(8) and s_b(5) and s_b(2)) -- left  col blue
               or (s_b(7) and s_b(4) and s_b(1)) -- mid   col blue
               or (s_b(6) and s_b(3) and s_b(0)) -- right col blue
               or (s_b(8) and s_b(4) and s_b(0)) -- diag  UL  blue
               or (s_b(2) and s_b(4) and s_b(6)) -- diag  BL  blue
               ;
          end process;
     red  (8 downto 0) <= s_r(8 downto 0);
     blue (8 downto 0) <= s_b(8 downto 0);
     Tp <= Tn;
      o_red_win  <= red_win;
      o_blue_win <= blue_win;

end Behavioral;
