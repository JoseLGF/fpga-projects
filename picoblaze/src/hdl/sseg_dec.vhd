------------------------------------------------------------------------
-- CPE 133 VHDL File: sseg_dec.vhd
-- Description: Special seven segment display driver;
--
--  two special inputs: 
-- 
--      VALID: if valid = 0, four dashes will be display
--             if valid = 1, decimal number appears on display
--
--       SIGN: if sign = 1, a minus sign appears in left-most digit
--             if sign = 0, no minus sign appears
--      
--
-- Author: bryan mealy (12-16-10)
--
-- revisions: 
------------------------------------------------------------------------

-----------------------------------------------------------------------
-----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-------------------------------------------------------------
-- 4 digit seven-segment display driver. Outputs are active
-- low and configured ABCEDFG in "segment" output. 
--------------------------------------------------------------
entity sseg_dec is
    Port (      ALU_VAL : in std_logic_vector(7 downto 0); 
					    SIGN : in std_logic;
						VALID : in std_logic;
                    CLK : in std_logic;
                DISP_EN : out std_logic_vector(3 downto 0);
               SEGMENTS : out std_logic_vector(7 downto 0));
end sseg_dec;

-------------------------------------------------------------
-- description of ssegment decoder
-------------------------------------------------------------
architecture my_sseg of sseg_dec is

   -- declaration of 8-bit binary to 2-digit BCD converter --
   component bin2bcdconv 
       Port ( BIN_CNT_IN : in std_logic_vector(7 downto 0);
                 LSD_OUT : out std_logic_vector(3 downto 0);
                 MSD_OUT : out std_logic_vector(3 downto 0);
                MMSD_OUT : out std_logic_vector(3 downto 0));
   end component;

	component clk_div
		 Port (  clk : in std_logic;
				  sclk : out std_logic);
	end component;
	
   -- intermediate signal declaration -----------------------
   signal   cnt_dig : std_logic_vector(1 downto 0); 
   signal   digit : std_logic_vector (3 downto 0); 
   signal   lsd,msd,mmsd : std_logic_vector(3 downto 0); 
	signal   sclk : std_logic; 

begin

   -- instantiation of bin to bcd converter -----------------
   my_conv: bin2bcdconv 
	port map ( BIN_CNT_IN => ALU_VAL, 
                 LSD_OUT => lsd, 
                 MSD_OUT => msd, 
                MMSD_OUT => mmsd); 

   my_clk: clk_div 
	port map (clk => clk,
	          sclk => sclk ); 

   -- advance the count (used for display multiplexing) -----
   process (SCLK)
   begin
      if (rising_edge(SCLK)) then 
         cnt_dig <= cnt_dig + 1; 
      end if; 
   end process; 


   -- select the display sseg data abcdefg (active low) -----
   segments <= "00000011" when digit = "0000"  else
               "10011111" when digit = "0001"  else
               "00100101" when digit = "0010"  else
               "00001101" when digit = "0011"  else
               "10011001" when digit = "0100"  else
               "01001001" when digit = "0101"  else
               "01000001" when digit = "0110"  else
               "00011111" when digit = "0111"  else
               "00000001" when digit = "1000"  else
               "00001001" when digit = "1001"  else
					"11111101" when digit = "1110" else   -- dash
					"11111111" when digit = "1110" else   -- blank
               "11111111"; 

   -- actuate the correct display --------------------------
   disp_en <= "1110" when cnt_dig = "00" else 
              "1101" when cnt_dig = "01" else
              "1011" when cnt_dig = "10" else
              "0111" when cnt_dig = "11" else
              "1111"; 

 
	process (cnt_dig, lsd, msd, mmsd, sign, valid)
	   variable mmsd_v, msd_v : std_logic_vector(3 downto 0);    
	begin
	   mmsd_v := mmsd; 
		msd_v := msd; 
		
		-- do the lead zero blanking for two msb's
		if (mmsd_v = X"0") then 
		   if (msd_v = X"0") then 
			   msd_v := X"F"; 
			end if; 
		   mmsd_v := X"F"; 
		end if; 
			
		if (valid = '1') then
			if (sign = '0') then
				case cnt_dig is
					when "00" => digit <= "1111"; 
					when "01" => digit <= mmsd_v; 
					when "10" => digit <= msd_v; 
					when "11" => digit <= lsd; 
					when others => digit <= "0000"; 
				end case; 
			else
				case cnt_dig is 
					when "00" => digit <= "1110"; 
					when "01" => digit <= mmsd_v; 
					when "10" => digit <= msd_v; 
					when "11" => digit <= lsd; 
					when others => digit <= "0000";
				end case;
			end if;
		else digit <= "1110";
		end if;
	end process;
			

end my_sseg;




--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------------------
-- interface description for bin to bcd converter 
--------------------------------------------------------------------
entity bin2bcdconv is
    Port ( BIN_CNT_IN : in std_logic_vector(7 downto 0);
              LSD_OUT : out std_logic_vector(3 downto 0);
              MSD_OUT : out std_logic_vector(3 downto 0);
             MMSD_OUT : out std_logic_vector(3 downto 0));
end bin2bcdconv;

---------------------------------------------------------------------
-- description of 8-bit binary to 3-digit BCD converter 
---------------------------------------------------------------------
architecture my_ckt of bin2bcdconv is
begin
   process(bin_cnt_in)
       variable cnt_tot : INTEGER range 0 to 255 := 0; 
	    variable lsd,msd,mmsd : INTEGER range 0 to 9 := 0; 
   begin
	 
	 -- convert input binary value to decimal
	 cnt_tot := 0; 
    if (bin_cnt_in(7) = '1') then cnt_tot := cnt_tot + 128;  end if; 
    if (bin_cnt_in(6) = '1') then cnt_tot := cnt_tot +  64;  end if; 
    if (bin_cnt_in(5) = '1') then cnt_tot := cnt_tot +  32;  end if; 
    if (bin_cnt_in(4) = '1') then cnt_tot := cnt_tot +  16;  end if; 
    if (bin_cnt_in(3) = '1') then cnt_tot := cnt_tot +   8;  end if; 
    if (bin_cnt_in(2) = '1') then cnt_tot := cnt_tot +   4;  end if; 
    if (bin_cnt_in(1) = '1') then cnt_tot := cnt_tot +   2;  end if; 
    if (bin_cnt_in(0) = '1') then cnt_tot := cnt_tot +   1;  end if; 

	 -- initialize intermediate signals
    msd  := 0; 
	 mmsd := 0; 
	 lsd  := 0;
           
    --  calculate the MMSB
    for I in 1 to 2 loop
	    exit when (cnt_tot >= 0 and cnt_tot < 100); 
	    mmsd := mmsd + 1; -- increment the mmds count
	    cnt_tot := cnt_tot - 100;
    end loop; 
      	         
     --  calculate the MSB
    for I in 1 to 9 loop	     
       exit when (cnt_tot >= 0 and cnt_tot < 10); 
       msd := msd + 1; -- increment the mds count
	    cnt_tot := cnt_tot - 10;
    end loop; 
      	    
	 lsd := cnt_tot;   -- lsd is what is left over

	 -- convert lsd to binary
	 case lsd is 
	    when 9 =>  lsd_out <= "1001"; 
	    when 8 =>  lsd_out <= "1000"; 
	    when 7 =>  lsd_out <= "0111"; 
	    when 6 =>  lsd_out <= "0110"; 
	    when 5 =>  lsd_out <= "0101"; 
	    when 4 =>  lsd_out <= "0100"; 
	    when 3 =>  lsd_out <= "0011"; 
	    when 2 =>  lsd_out <= "0010"; 
	    when 1 =>  lsd_out <= "0001"; 
	    when 0 =>  lsd_out <= "0000"; 
	    when others =>  lsd_out <= "0000"; 
    end case; 

	 -- convert msd to binary
	 case msd is 
	    when 9 =>  msd_out <= "1001"; 
	    when 8 =>  msd_out <= "1000"; 
	    when 7 =>  msd_out <= "0111"; 
	    when 6 =>  msd_out <= "0110"; 
	    when 5 =>  msd_out <= "0101"; 
	    when 4 =>  msd_out <= "0100"; 
	    when 3 =>  msd_out <= "0011"; 
	    when 2 =>  msd_out <= "0010"; 
	    when 1 =>  msd_out <= "0001"; 
	    when 0 =>  msd_out <= "0000"; 
	    when others =>  msd_out <= "0000"; 
      end case; 

	 -- convert msd to binary
	 case mmsd is  
	    when 2 =>  mmsd_out <= "0010"; 
	    when 1 =>  mmsd_out <= "0001"; 
	    when 0 =>  mmsd_out <= "0000"; 
	    when others =>  mmsd_out <= "0000"; 
    end case; 

   end process; 
end my_ckt;


-----------------------------------------------------------------------
-----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------------------------------------
-- Module to divide the clock 
-----------------------------------------------------------------------
entity clk_div is
    Port (  clk : in std_logic;
           sclk : out std_logic);
end clk_div;

architecture my_clk_div of clk_div is
   constant max_count : integer := (2200);  
   signal tmp_clk : std_logic := '0'; 
begin
   my_div: process (clk,tmp_clk)              
      variable div_cnt : integer := 0;   
   begin
      if (rising_edge(clk)) then   
         if (div_cnt = MAX_COUNT) then 
            tmp_clk <= not tmp_clk; 
            div_cnt := 0; 
         else
            div_cnt := div_cnt + 1; 
         end if; 
      end if; 
      sclk <= tmp_clk; 
   end process my_div; 
end my_clk_div;





