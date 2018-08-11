--------------------------------------------------------------------------------
-- Title       : ALU
-- Project     : prol16
--------------------------------------------------------------------------------
-- RevCtrl     : 
-- Authors     : Thomas Reisinger
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.prol16_pack.all;

entity alu is

  generic (
    bit_width_g : integer := 16);

  port (
    side_a_i   : in std_ulogic_vector(bit_width_g -1 downto 0);
    side_b_i   : in std_ulogic_vector(bit_width_g -1 downto 0);
    carry_i    : in std_ulogic;
    alu_func_i : in alu_func_t;

    result_o : out std_ulogic_vector(bit_width_g -1 downto 0);
    carry_o  : out std_ulogic;
    zero_o   : out std_ulogic);

end alu;

