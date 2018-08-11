--------------------------------------------------------------------------------
-- Title       : register file
-- Project     : prol16
--------------------------------------------------------------------------------
-- RevCtrl     : 
-- Authors     : Reisinger Thomas
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.prol16_pack.all;

entity reg_file is
  
  generic (
    registers_g : integer := registers_c);

  port (
    clk_i : in std_ulogic;
    res_i : in std_ulogic;

    reg_a_idx_i       : in reg_idx_t;
    reg_b_idx_i       : in reg_idx_t;
    clk_en_reg_file_i : in std_ulogic;

    reg_i   : in  data_vec_t;
    reg_a_o : out data_vec_t;
    reg_b_o : out data_vec_t);

end reg_file;

architecture rtl of reg_file is
  
  type   register_t is array(registers_g-1 downto 0) of data_vec_t;
  signal regs : register_t := (others => (others => '0'));

begin  -- rtl

  -- write synchronus
  writeReg : process (clk_i, res_i)
  begin  -- process writeReg
    if res_i = not('1') then                   -- reset
      regs <= (others => (others => '0'));
    elsif rising_edge(clk_i) then              -- clk edge
      if clk_en_reg_file_i = '1' then          -- enable write
        if reg_a_idx_i > reg_idx_t'low then  -- valid index
          regs(reg_a_idx_i) <= reg_i;
        end if;
      end if;
    end if;
  end process writeReg;

  -- read asynchronus
  reg_a_o <= regs(reg_a_idx_i) when reg_a_idx_i > reg_idx_t'low else (others => 'X');
  reg_b_o <= regs(reg_b_idx_i) when reg_b_idx_i > reg_idx_t'low else (others => 'X');
  
end rtl;
