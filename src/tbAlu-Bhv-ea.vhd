--------------------------------------------------------------------------------
-- Title       : ALU testbench
-- Project     : prol16
--------------------------------------------------------------------------------
-- RevCtrl     : 
-- Authors     : Thomas Reisinger
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------

library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library work;
use work.prol16_pack.all;

entity tbAlu is
end tbAlu;

architecture Bhv of tbAlu is

  constant bit_width_c : integer := 16;
  signal side_a        : std_ulogic_vector(bit_width_c -1 downto 0);
  signal side_b        : std_ulogic_vector(bit_width_c -1 downto 0);
  signal result        : std_ulogic_vector(bit_width_c -1 downto 0);
  signal cin           : std_ulogic;
  signal cout          : std_ulogic;
  signal zero          : std_ulogic;
  signal alu_func      : alu_func_t;

  type testcase_t is record
    side_a   : std_ulogic_vector(bit_width_c-1 downto 0);
    side_b   : std_ulogic_vector(bit_width_c-1 downto 0);
    carry    : std_ulogic;
    alu_func : alu_func_t;

    ExpectedResult : std_ulogic_vector(bit_width_c-1 downto 0);
    ExpectedCarry  : std_ulogic;
    ExpectedZero   : std_ulogic;
    FailString     : string(1 to 16);
  end record;

  type testcase_array_t is array (natural range <>) of testcase_t;

  constant testcases : testcase_array_t :=
    (
      -- invalid input 000
      (
        alu_func => (others => 'X'),
        side_a   => (others => 'X'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (others => 'X'),
        ExpectedCarry  => 'X',
        ExpectedZero   => 'X',
        FailString => " invalid inputs "
        ),
      -- Test Pass a, b 001-002
      (
        alu_func       => alu_pass_a_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " pass a         "
        ),
      (
        alu_func       => alu_pass_b_c,
        side_a         => (others => 'X'),
        side_b         => std_ulogic_vector(to_unsigned(16#23#, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(16#23#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " pass b         "
        ),

      -- Test Logic Operators 003-008
      (
        alu_func => alu_and_c,
        side_a   => (others => '0'),
        side_b   => (others => '1'),
        carry    => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " a and b        "
        ),
      (
        alu_func       => alu_and_c,
        side_a         => std_ulogic_vector(to_unsigned(16#3232#, bit_width_c)),
        side_b         => (others => '1'),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(16#3232#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a and b        "
        ),
      (
        alu_func       => alu_or_c,
        side_a         => std_ulogic_vector(to_unsigned(16#5555#, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(16#AAAA#, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(16#FFFF#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a or b         "
        ),
      (
        alu_func       => alu_xor_c,
        side_a         => std_ulogic_vector(to_unsigned(16#FFF0#, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(16#1210#, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(16#EDE0#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a xor b        "
        ),
      (
        alu_func       => alu_not_c,
        side_a         => std_ulogic_vector(to_unsigned(16#6767#, bit_width_c)),
        side_b         => (others => 'X'),
        carry          => '0',

        ExpectedResult => not std_ulogic_vector(to_unsigned(16#6767#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " not a          "
        ),
      (
        alu_func       => alu_not_c,
        side_a         => (others => '1'),
        side_b         => (others => 'X'),
        carry          => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " not a          "
        ),

      -- Test add: SideA + SideB + CarryIn 009-016
      (
        alu_func => alu_add_c,
        side_a   => (others => '1'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (others => 'X'),
        ExpectedCarry  => 'X',
        ExpectedZero   => 'X',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => std_ulogic_vector(to_unsigned(16#5555#, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(16#AAAA#, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(16#FFFF#, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (others => '0'),
        side_b         => (others => '0'),
        carry          => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (others => '0'),
        side_b         => (others => '0'),
        carry          => '1',

        ExpectedResult => (0 => '1', others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (0 => '1', others => '0'),
        side_b         => (0 => '0', others => '1'),
        carry          => '0',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (0 => '1', others => '0'),
        side_b         => (others => '1'),
        carry          => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '1',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (others => '1'),
        side_b         => (others => '1'),
        carry          => '0',

        ExpectedResult => (0 => '0', others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a + b + cin    "
        ),
      (
        alu_func       => alu_add_c,
        side_a         => (others => '1'),
        side_b         => (others => '1'),
        carry          => '1',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a + b + cin    "
        ),

      -- Test sub: SideA - SideB - CarryIn 017-024
      (
        alu_func => alu_sub_c,
        side_a   => (others => '0'),
        side_b   => (others => '0'),
        carry    => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => (others => '1'),
        side_b         => (others => '1'),
        carry          => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => (others => '0'),
        side_b         => (others => '0'),
        carry          => '1',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => (others => '1'),
        side_b         => (others => '1'),
        carry          => '1',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => std_ulogic_vector(to_unsigned(100, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(99, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_unsigned(1, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => std_ulogic_vector(to_unsigned(100, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(99, bit_width_c)),
        carry          => '1',

        ExpectedResult => std_ulogic_vector(to_unsigned(0, bit_width_c)),
        ExpectedCarry  => '0',
        ExpectedZero   => '1',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => std_ulogic_vector(to_unsigned(99, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(100, bit_width_c)),
        carry          => '0',

        ExpectedResult => std_ulogic_vector(to_signed(-1, bit_width_c)),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - b - cin    "
        ),
      (
        alu_func       => alu_sub_c,
        side_a         => std_ulogic_vector(to_unsigned(99, bit_width_c)),
        side_b         => std_ulogic_vector(to_unsigned(100, bit_width_c)),
        carry          => '1',

        ExpectedResult => std_ulogic_vector(to_signed(-2, bit_width_c)),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - b - cin    "
        ),

      -- Test increment A by 1 025-27
      (
        alu_func => alu_inc_c,
        side_a   => (others => '1'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '1',
        FailString => " a + 1          "
        ),
      (
        alu_func       => alu_inc_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '0',

        ExpectedResult => (0 => '1', others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a + 1          "
        ),
      (
        alu_func       => alu_inc_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (0 => '1', others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a + 1          "
        ),

      -- Decrement A by 1 028-030
      (
        alu_func => alu_dec_c,
        side_a   => (others => '1'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (0 => '0', others => '1'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a - 1          "
        ),
      (
        alu_func       => alu_dec_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '0',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - 1          "
        ),
      (
        alu_func       => alu_dec_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (others => '1'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a - 1          "
        ),

      -- Test shift left A 031-033
      (
        alu_func => alu_slc_c,
        side_a   => (side_a'left => '1', others => '0'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '1',
        FailString => " a << 1         "
        ),
      (
        alu_func       => alu_slc_c,
        side_a         => (side_a'left => '1', others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (0 => '1', others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a << 1         "
        ),
      (
        alu_func       => alu_slc_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (0 => '1', others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a << 1         "
        ),

      -- Test shift right A 034-036
      (
        alu_func => alu_src_c,
        side_a   => (0 => '1', others => '0'),
        side_b   => (others => 'X'),
        carry    => '0',

        ExpectedResult => (others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '1',
        FailString => " a >> 1         "
        ),
      (
        alu_func       => alu_src_c,
        side_a         => (0 => '1', others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (side_a'left => '1', others => '0'),
        ExpectedCarry  => '1',
        ExpectedZero   => '0',
        FailString => " a >> 1         "
        ),
      (
        alu_func       => alu_src_c,
        side_a         => (others => '0'),
        side_b         => (others => 'X'),
        carry          => '1',

        ExpectedResult => (side_a'left => '1', others => '0'),
        ExpectedCarry  => '0',
        ExpectedZero   => '0',
        FailString => " a >> 1         "
        )
      );

begin

  TheAlu : entity work.alu
    generic map (
      bit_width_g => bit_width_c)
    port map (
      side_a_i   => side_a,
      side_b_i   => side_b,
      carry_i    => cin,
      alu_func_i => alu_func,
      result_o   => result,
      carry_o    => cout,
      zero_o     => zero);

  stimuli : process
    variable vErrorCnt : natural := 0;
  begin
    for i in testcases'range loop       -- run all test cases
      side_a   <= testcases(i).side_a;
      side_b   <= testcases(i).side_b;
      cin      <= testcases(i).carry;
      alu_func <= testcases(i).alu_func;
      wait for 20 ns;

      -- check the output
      if result /= testcases(i).ExpectedResult or cout /= testcases(i).ExpectedCarry or zero /= testcases(i).ExpectedZero then
        -- log error message
        assert result = testcases(i).ExpectedResult report "Error: Result on test " & integer'image(i) & testcases(i).FailString severity error;
        assert cout = testcases(i).ExpectedCarry report "Error: Carry Flag on test " & integer'image(i) & testcases(i).FailString severity error;
        assert zero = testcases(i).ExpectedZero report "Error: Zero Flag on test " & integer'image(i) & testcases(i).FailString severity error;

        vErrorCnt := vErrorCnt + 1;
      end if;
    end loop;

    if vErrorCnt = 0 then
      report "Test completed without errors." severity note;
    else
      report "Test failed with " & integer'image(vErrorCnt) & " errors!" severity note;
    end if;

    wait;
  end process stimuli;

end Bhv;
