--------------------------------------------------------------------------------
-- Title       : Spike Filter / Edge Detection testbench
-- Project     : FPGA Based Digital Signal Processing
--               FH OÖ Hagenberg/HSD, CHD5
--------------------------------------------------------------------------------
-- Authors     : Thomas Reisinger, Hagenberg/Austria, Copyright (c) 2012-2017
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity spikefilter_tb is
end spikefilter_tb;

architecture bhv of spikefilter_tb is
  constant cPeriod : time := 62.5 ns;

  signal InputPin      : std_ulogic := '0';
  signal RiseEdgeOnPin : std_ulogic;
  signal FallEdgeOnPin : std_ulogic;
  signal LevelOnPin    : std_ulogic;
  signal Clk           : std_ulogic := '0';
  signal nReset        : std_ulogic := '0';
begin
  DUT : entity work.spikefilter_5
    generic map
    (
      no_sync_ffs_g => 5
      )
    port map
    (
      clk_i              => Clk,
      res_i              => nReset,
      input_pin_i        => InputPin,
      rise_edge_on_pin_o => RiseEdgeOnPin,
      fall_edge_on_pin_o => FallEdgeOnPin,
      level_on_pin_o     => LevelOnPin
      );

  Clk <= not(Clk) after cPeriod / 2;

  InputPin <= '0' after 80 ns,
              '1' after 160 ns,
              '0' after 170 ns,
              '1' after 180 ns,
              '0' after 240 ns,
              '1' after 500 ns,
              'L' after 850 ns,
              'H' after 950 ns,
              'L' after 1300 ns,
              '1' after 1406245 ps;     -- violate setup time
  
  nReset <= '1';
end bhv;
