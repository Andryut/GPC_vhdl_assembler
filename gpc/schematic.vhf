--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : sch2vhdl
--  /   /         Filename : schematic.vhf
-- /___/   /\     Timestamp : 02/28/2019 11:34:54
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: C:\Xilinx92i\bin\nt\sch2vhdl.exe -intstyle ise -family spartan3e -flat -suppress -w C:/Users/Andre/Desktop/carpeta_arquitectura/Assembler_arch/gpc/schematic.sch schematic.vhf
--Design Name: schematic
--Device: spartan3e
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesis and simulted, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity schematic is
   port ( Din      : in    std_logic_vector (3 downto 0); 
          go       : in    std_logic; 
          mainClk  : in    std_logic; 
          reset    : in    std_logic; 
          done     : out   std_logic; 
          Dout     : out   std_logic_vector (3 downto 0); 
          inFlags  : out   std_logic_vector (7 downto 0); 
          monClk   : out   std_logic; 
          outFlags : out   std_logic_vector (7 downto 0));
end schematic;

architecture BEHAVIORAL of schematic is
   signal XLXN_6   : std_logic;
   component Button
      port ( CLK : in    std_logic; 
             RST : in    std_logic; 
             x   : in    std_logic; 
             y   : out   std_logic);
   end component;
   
   component GPC_Hvd_a
      port ( clk      : in    std_logic; 
             rst      : in    std_logic; 
             enter    : in    std_logic; 
             Din      : in    std_logic_vector (3 downto 0); 
             done     : out   std_logic; 
             Dout     : out   std_logic_vector (3 downto 0); 
             inFlags  : out   std_logic_vector (7 downto 0); 
             outFlags : out   std_logic_vector (7 downto 0));
   end component;
   
   component ClkMon
      port ( clk : in    std_logic; 
             rst : in    std_logic; 
             y   : out   std_logic);
   end component;
   
begin
   XLXI_1 : Button
      port map (CLK=>mainClk,
                RST=>reset,
                x=>go,
                y=>XLXN_6);
   
   XLXI_2 : GPC_Hvd_a
      port map (clk=>mainClk,
                Din(3 downto 0)=>Din(3 downto 0),
                enter=>XLXN_6,
                rst=>reset,
                done=>done,
                Dout(3 downto 0)=>Dout(3 downto 0),
                inFlags(7 downto 0)=>inFlags(7 downto 0),
                outFlags(7 downto 0)=>outFlags(7 downto 0));
   
   XLXI_3 : ClkMon
      port map (clk=>mainClk,
                rst=>reset,
                y=>monClk);
   
end BEHAVIORAL;


