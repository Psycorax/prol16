--------------------------------------------------------------------------------
-- Title       : Spike Filter / Edge Detection
-- Project     : FPGA Based Digital Signal Processing
--               FH OÖ Hagenberg/HSD, CHD5
--------------------------------------------------------------------------------
-- Authors     : Thomas Reisinger, Hagenberg/Austria, Copyright (c) 2012-2017
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity spikefilter is
  
  generic
    (no_sync_ffs_g : integer := 3);
  port
    (clk_i : in std_ulogic;             -- system clock
     res_i : in std_ulogic;             -- asynchronous reset

     input_pin_i        : in  std_ulogic;  -- input pin -> signal that should be filtered
     rise_edge_on_pin_o : out std_ulogic;  -- '1' when output pin has a rising edge
     fall_edge_on_pin_o : out std_ulogic;  -- '1' when output pin has a falling edge
     level_on_pin_o     : out std_ulogic);  -- output pin -> input signal that is syncronized and filtered

end spikefilter;

architecture rtl of spikefilter is
  signal CaptureFlipFlop : std_ulogic_vector(0 to no_sync_ffs_g - 1) := (others => 'U');
  signal Level           : std_ulogic                                := 'U';
  signal PrevLevel       : std_ulogic                                := 'U';
begin
  assert (no_sync_ffs_g > 1) report "at least 2 FFs are needed to filter correctly" severity error;

  process (clk_i, res_i)
  begin

    if res_i = not('1') then
      CaptureFlipFlop <= (others => '0');
      Level           <= '0';
      PrevLevel       <= '0';
    elsif rising_edge(clk_i) then

      -- check input
      case input_pin_i is
        when '0' | 'L' => CaptureFlipFlop(0) <= '0';
        when '1' | 'H' => CaptureFlipFlop(0) <= '1';
        when others    => CaptureFlipFlop(0) <= input_pin_i;
      end case;

      -- shift through FFs
      for i in CaptureFlipFlop'low to CaptureFlipFlop'high - 1 loop
        CaptureFlipFlop(i + 1) <= CaptureFlipFlop(i);
      end loop;

      -- check last 2 FFs for output
      if (CaptureFlipFlop(CaptureFlipFlop'high - 1) = '0') and
        (CaptureFlipFlop(CaptureFlipFlop'high) = '0')
      then
        Level <= '0';
      elsif (CaptureFlipFlop(CaptureFlipFlop'high - 1) = '1') and
        (CaptureFlipFlop(CaptureFlipFlop'high) = '1')
      then
        Level <= '1';
      end if;

      PrevLevel <= Level;
    end if;
  end process;

  -- concurrent signal assignment
  level_on_pin_o     <= Level;
  rise_edge_on_pin_o <= Level and not(PrevLevel);
  fall_edge_on_pin_o <= not(Level) and PrevLevel;
  
end rtl;
