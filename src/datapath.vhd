--------------------------------------------------------------------------------
-- Title       : datapath
-- Project     : prol16
--------------------------------------------------------------------------------
-- RevCtrl     : 
-- Authors     : Reisinger Thomas
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.prol16_pack.all;

entity datapath is

  port (
    clk_i : in std_ulogic;
    res_i : in std_ulogic;

    -- control
    op_code_o          : out op_code_t;
    -- asserted on register index decode error    
    reg_decode_error_o : out std_ulogic;

    sel_pc_i   : in std_ulogic;
    sel_load_i : in std_ulogic;
    sel_addr_i : in std_ulogic;

    clk_en_pc_i       : in std_ulogic;
    clk_en_reg_file_i : in std_ulogic;
    clk_en_op_code_i  : in std_ulogic;

    -- alu
    alu_func_i : in  alu_func_t;
    carry_i    : in  std_ulogic;
    carry_o    : out std_ulogic;
    zero_o     : out std_ulogic;

    -- memory
    mem_addr_o : out data_vec_t;
    mem_data_o : out data_vec_t;
    mem_data_i : in  data_vec_t);

end datapath;

architecture rtl of datapath is

  -- registers in datapath
  signal reg_sel_ra : reg_idx_t;
  signal reg_sel_rb : reg_idx_t;
  signal reg_opcode : data_vec_t;
  signal reg_tmp_ra : data_vec_t;
  signal reg_tmp_rb : data_vec_t;
  signal reg_pc     : data_vec_t;

  -- for register file
  signal regs_in    : data_vec_t;
  signal regs_out_a : data_vec_t;
  signal regs_out_b : data_vec_t;

  -- for ALU
  signal alu_in_a : data_vec_t;
  signal alu_in_b : data_vec_t;
  signal alu_out  : data_vec_t;

begin

  -- mapping
  registerFile : entity work.reg_file(rtl)
    port map (clk_i             => clk_i,
              res_i             => res_i,
              reg_a_idx_i       => reg_sel_ra,
              reg_b_idx_i       => reg_sel_rb,
              clk_en_reg_file_i => clk_en_reg_file_i,
              reg_i             => regs_in,
              reg_a_o           => regs_out_a,
              reg_b_o           => regs_out_b
              );

  ALU : entity work.alu(rtl)
    generic map (bit_width_g => data_vec_length_c
                 )
    port map (side_a_i   => alu_in_a,
              side_b_i   => alu_in_b,
              carry_i    => carry_i,
              alu_func_i => alu_func_i,
              result_o   => alu_out,
              carry_o    => carry_o,
              zero_o     => zero_o
              );

  -- registers
  writeRegs : process(clk_i, res_i, clk_en_op_code_i, clk_en_pc_i)
  begin
    if res_i = not('1') then
      reg_opcode <= (others => '0');
      reg_tmp_ra <= (others => '0');
      reg_tmp_rb <= (others => '0');
      reg_pc     <= (others => '0');
    elsif rising_edge(clk_i) then
      -- opcode registers
      if clk_en_op_code_i = '1' then
        reg_opcode <= mem_data_i;
      end if;

      -- program counter register
      if clk_en_pc_i = '1' then
        case sel_pc_i is
          when '0'    => reg_pc <= regs_out_a;
          when '1'    => reg_pc <= alu_out;
          when others => reg_pc <= (others => 'X');
        end case;
      end if;

      -- temp registers
      reg_tmp_ra <= regs_out_a;
      reg_tmp_rb <= regs_out_b;
    end if;
  end process writeRegs;


  -- check for invalid register index
  regIdxCheck : process(reg_opcode)
    variable tmp_ra : integer;
    variable tmp_rb : integer;
  begin
    tmp_ra := to_integer(unsigned(reg_opcode(ra_range_t)));
    tmp_rb := to_integer(unsigned(reg_opcode(ra_range_t)));
    if tmp_ra > reg_idx_t'low and tmp_ra < registers_c and
      tmp_rb > reg_idx_t'low and tmp_rb < registers_c
    then
      reg_sel_ra         <= to_integer(unsigned(reg_opcode(ra_range_t)));
      reg_sel_rb         <= to_integer(unsigned(reg_opcode(rb_range_t)));
      reg_decode_error_o <= '0';
    else
      reg_sel_ra         <= reg_idx_t'low;
      reg_sel_rb         <= reg_idx_t'low;
      reg_decode_error_o <= '1';
    end if;
  end process regIdxCheck;

  -- reg file
  regs_in <= mem_data_i when sel_load_i = '1' else
             alu_out when sel_load_i = '0' else
             (others => 'X');

  -- alu
  alu_in_a <= reg_tmp_ra when sel_pc_i = '0' else
              reg_pc when sel_pc_i = '1' else
              (others => 'X');
  
  alu_in_b <= reg_tmp_rb;

  -- op code
  op_code_o <= reg_opcode(op_code_range_t);

  -- memory
  mem_data_o <= reg_tmp_ra;

  mem_addr_o <= reg_pc when sel_addr_i = '0' else
                reg_tmp_rb when sel_addr_i = '1' else
                (others => '0');

end rtl;
