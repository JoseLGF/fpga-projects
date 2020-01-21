module Tic_Tac_Renderer(
    input wire CLK,             // board clock: 100 MHz on Basys 3
    input wire RST_BTN,         // reset button
    input wire [8:0] BLUE,      // Blue player positions
    input wire [8:0] RED,       // Red player positions
    input wire [8:0] GREEN,     // Green player positions
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
    );

    wire rst = ~RST_BTN;  // reset is active low on Arty

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );

    // Red Elements
    wire r_11, r_12, r_13, r_21, r_22, r_23, r_31, r_32, r_33;
    assign r_11 = ((x > 010) & (y >  010) & (x < 200) & (y < 150)) ? 1 : 0;
    assign r_12 = ((x > 220) & (y >  010) & (x < 410) & (y < 150)) ? 1 : 0;
    assign r_13 = ((x > 430) & (y >  010) & (x < 620) & (y < 150)) ? 1 : 0;
    assign r_21 = ((x > 010) & (y >  170) & (x < 200) & (y < 310)) ? 1 : 0;
    assign r_22 = ((x > 220) & (y >  170) & (x < 410) & (y < 310)) ? 1 : 0;
    assign r_23 = ((x > 430) & (y >  170) & (x < 620) & (y < 310)) ? 1 : 0;
    assign r_31 = ((x > 010) & (y >  330) & (x < 200) & (y < 470)) ? 1 : 0;
    assign r_32 = ((x > 220) & (y >  330) & (x < 410) & (y < 470)) ? 1 : 0;
    assign r_33 = ((x > 430) & (y >  330) & (x < 620) & (y < 470)) ? 1 : 0;
    assign VGA_R[3] = (r_11 & RED[8])
                    | (r_12 & RED[7]) 
                    | (r_13 & RED[6]) 
                    | (r_21 & RED[5]) 
                    | (r_22 & RED[4]) 
                    | (r_23 & RED[3]) 
                    | (r_31 & RED[2]) 
                    | (r_32 & RED[1]) 
                    | (r_33 & RED[0]);         

    // Blue Elements
    wire b_11, b_12, b_13, b_21, b_22, b_23, b_31, b_32, b_33;
    assign b_11 = ((x > 010) & (y >  010) & (x < 200) & (y < 150)) ? 1 : 0;
    assign b_12 = ((x > 220) & (y >  010) & (x < 410) & (y < 150)) ? 1 : 0;
    assign b_13 = ((x > 430) & (y >  010) & (x < 620) & (y < 150)) ? 1 : 0;
    assign b_21 = ((x > 010) & (y >  170) & (x < 200) & (y < 310)) ? 1 : 0;
    assign b_22 = ((x > 220) & (y >  170) & (x < 410) & (y < 310)) ? 1 : 0;
    assign b_23 = ((x > 430) & (y >  170) & (x < 620) & (y < 310)) ? 1 : 0;
    assign b_31 = ((x > 010) & (y >  330) & (x < 200) & (y < 470)) ? 1 : 0;
    assign b_32 = ((x > 220) & (y >  330) & (x < 410) & (y < 470)) ? 1 : 0;
    assign b_33 = ((x > 430) & (y >  330) & (x < 620) & (y < 470)) ? 1 : 0;
    assign VGA_B[3] = (b_11 & BLUE[8])
                    | (b_12 & BLUE[7]) 
                    | (b_13 & BLUE[6]) 
                    | (b_21 & BLUE[5]) 
                    | (b_22 & BLUE[4]) 
                    | (b_23 & BLUE[3]) 
                    | (b_31 & BLUE[2]) 
                    | (b_32 & BLUE[1]) 
                    | (b_33 & BLUE[0]);         

    // Green Elements
    wire g_11, g_12, g_13, g_21, g_22, g_23, g_31, g_32, g_33;
    assign g_11 = ((x > 010) & (y >  010) & (x < 200) & (y < 150)) ? 1 : 0;
    assign g_12 = ((x > 220) & (y >  010) & (x < 410) & (y < 150)) ? 1 : 0;
    assign g_13 = ((x > 430) & (y >  010) & (x < 620) & (y < 150)) ? 1 : 0;
    assign g_21 = ((x > 010) & (y >  170) & (x < 200) & (y < 310)) ? 1 : 0;
    assign g_22 = ((x > 220) & (y >  170) & (x < 410) & (y < 310)) ? 1 : 0;
    assign g_23 = ((x > 430) & (y >  170) & (x < 620) & (y < 310)) ? 1 : 0;
    assign g_31 = ((x > 010) & (y >  330) & (x < 200) & (y < 470)) ? 1 : 0;
    assign g_32 = ((x > 220) & (y >  330) & (x < 410) & (y < 470)) ? 1 : 0;
    assign g_33 = ((x > 430) & (y >  330) & (x < 620) & (y < 470)) ? 1 : 0;
    assign VGA_G[3] = (g_11 & GREEN[8])
                    | (g_12 & GREEN[7]) 
                    | (g_13 & GREEN[6]) 
                    | (g_21 & GREEN[5]) 
                    | (g_22 & GREEN[4]) 
                    | (g_23 & GREEN[3]) 
                    | (g_31 & GREEN[2]) 
                    | (g_32 & GREEN[1]) 
                    | (g_33 & GREEN[0]);         

endmodule
