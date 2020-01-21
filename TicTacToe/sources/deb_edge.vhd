library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity deb_edge is
  Port (
               CLK            : in  std_logic;
               in_btn         : in  std_logic; -- button signal
               out_edge       : out std_logic  -- debounce and edge
       );
end deb_edge;

architecture Structural of deb_edge is
    -- components
    component debounce 
             Port(
               clk            : IN  STD_LOGIC;
               button         : IN  STD_LOGIC; 
               result         : OUT STD_LOGIC   
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
    -- signals
        signal s_deb : std_logic; -- debounced button signal
begin
    -- port maps
    db:debounce port map( 
               clk          => CLK,
               button       => in_btn,
               result       => s_deb
     );

    ed: edge_detector port map( 
               i_clk        => CLK,
               i_rstb       => '1',
               i_input      => s_deb,
               o_pulse      => out_edge
     );

end Structural;
