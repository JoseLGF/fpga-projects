library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
    Port (
               clk            : in  std_logic;
               --RST          : in  std_logic;
               --sw             : in  std_logic_vector(8 downto 0);
               btnU           : in  std_logic;
               btnD           : in  std_logic;
               btnL           : in  std_logic;
               btnR           : in  std_logic;
               btnC           : in  std_logic;
               Hsync          : out std_logic; 
               Vsync          : out std_logic; 
               vgaRed         : out std_logic_vector(3 downto 0); 
               vgaGreen       : out std_logic_vector(3 downto 0); 
               vgaBlue        : out std_logic_vector(3 downto 0);
               led            : out std_logic_vector(1 downto 0);
               seg            : out std_logic_vector(7 downto 0);
               an             : out std_logic_vector(3 downto 0)
         );
end Top;

architecture Structural of Top is
    -- components
    component Tic_Tac_Renderer 
             Port(
               clk            : in  std_logic;
               RST_BTN        : in  std_logic;
               BLUE           : in  std_logic_vector(8 downto 0);
               RED            : in  std_logic_vector(8 downto 0);
               GREEN          : in  std_logic_vector(8 downto 0);
               VGA_HS_O       : out std_logic;
               VGA_VS_O       : out std_logic;
               VGA_R          : out std_logic_vector(3 downto 0);
               VGA_G          : out std_logic_vector(3 downto 0);
               VGA_B          : out std_logic_vector(3 downto 0)
                 ); 
         end component; 

     component Core 
        Port (
               clk            : in  std_logic;
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
               --p_turn       : out std_logic -- who's turn it is
         );
      end component; 

      component deb_edge 
            Port (
               clk            : in  std_logic;
               in_btn         : in  std_logic; -- button signal
               out_edge       : out std_logic  -- debounce and edge
                   );
       end component; 

       component edge_detector
           port (
               i_clk          : in  std_logic;
               i_rstb         : in  std_logic;
               i_input        : in  std_logic;
               o_pulse        : out std_logic
           );
            end component; 

        component Counter0F 
            Port (
               pulse          : in  STD_LOGIC;
               count          : out STD_LOGIC_VECTOR (3 DOWNTO 0)
           );
             end component; 

        component four_single_sseg 
             Port(
               clk            : in  std_logic;
               D0             : in  std_logic_vector(3 downto 0); 
               D1             : in  std_logic_vector(3 downto 0); 
               D2             : in  std_logic_vector(3 downto 0); 
               D3             : in  std_logic_vector(3 downto 0); 
               segments       : out std_logic_vector(7 downto 0);
               anodes         : out std_logic_vector(3 downto 0)
             ); 
             end component; 



    -- signals
      signal s_r : std_logic_vector(8 downto 0);
      signal s_g : std_logic_vector(8 downto 0);
      signal s_b : std_logic_vector(8 downto 0);

      signal s_db_btU : std_logic; -- debounced button Up
      signal s_db_btD : std_logic; -- debounced button Down
      signal s_db_btL : std_logic; -- debounced button Left 
      signal s_db_btR : std_logic; -- debounced button Right
      signal s_db_btC : std_logic; -- debounced button Center

      signal s_b_cnt : std_logic_vector(3 downto 0) := "0000"; -- blue score count
      signal s_r_cnt : std_logic_vector(3 downto 0) := "0000"; -- red  score count

      signal s_red_win     : std_logic;
      signal s_ed_red_win  : std_logic;
      signal s_blue_win    : std_logic;
      signal s_ed_blue_win : std_logic;

begin
    -- port maps
    TTR: Tic_Tac_Renderer port map( 
               clk           => clk,
               RST_BTN       => '1', 
               BLUE          => s_b (8 downto 0),
               RED           => s_r (8 downto 0),
               GREEN         => s_g (8 downto 0),
               VGA_HS_O      => Hsync,
               VGA_VS_O      => Vsync,
               VGA_R         => vgaRed (3 downto 0),
               VGA_G         => vgaGreen (3 downto 0),
               VGA_B         => vgaBlue (3 downto 0)
     );

    CR: Core port map( 
               clk           => clk,
               btnU          => s_db_btU,
               btnD          => s_db_btD,
               btnL          => s_db_btL,
               btnR          => s_db_btR,
               btnC          => s_db_btC,
               red           => s_r (8 downto 0),
               green         => s_g (8 downto 0),
               blue          => s_b (8 downto 0),
               o_red_win     => s_red_win,
               o_blue_win    => s_blue_win
               --p_turn       
     );

    dbU: deb_edge port map( 
               clk           => clk,
               in_btn        => btnU,
               out_edge      => s_db_btU
     );
    dbD: deb_edge port map( 
               clk           => clk,
               in_btn        => btnD,
               out_edge      => s_db_btD
     );
    dbL: deb_edge port map( 
               clk           => clk,
               in_btn        => btnL,
               out_edge      => s_db_btL
     );
    dbR: deb_edge port map( 
               clk           => clk,
               in_btn        => btnR,
               out_edge      => s_db_btR
     );
    dbC: deb_edge port map( 
               clk           => clk,
               in_btn        => btnC,
               out_edge      => s_db_btC
     );

    r_ed: edge_detector port map( 
               i_clk        => clk,
               i_rstb       => '1',
               i_input      => s_red_win,
               o_pulse      => s_ed_red_win
     );

    b_ed: edge_detector port map( 
               i_clk        => clk,
               i_rstb       => '1',
               i_input      => s_blue_win,
               o_pulse      => s_ed_blue_win
     );

    r_cnt: Counter0F port map( 
               pulse        => s_ed_red_win,
               count        => s_r_cnt(3 downto 0)
     );

    b_cnt: Counter0F port map( 
               pulse        => s_ed_blue_win,
               count        => s_b_cnt(3 downto 0)
     );

    sseg: four_single_sseg port map( 
               clk           => clk,
               D0            => s_b_cnt(3 downto 0),
               D1            => "0000",
               D2            => "0000",
               D3            => s_r_cnt(3 downto 0),
               segments      => seg(7 downto 0),
               anodes        => an(3 downto 0) 
     );

end Structural;
