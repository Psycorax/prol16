--------------------------------------------------------------------------------
-- Title       : control
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

entity control is

  port (
    clk_i : in std_ulogic;
    res_i : in std_ulogic;

    -- datapath
    op_code_i          : in op_code_t;
    reg_decode_error_i : in std_ulogic;

    sel_pc_o   : out std_ulogic;
    sel_load_o : out std_ulogic;
    sel_addr_o : out std_ulogic;

    clk_en_pc_o       : out std_ulogic;
    clk_en_reg_file_o : out std_ulogic;
    clk_en_op_code_o  : out std_ulogic;

    -- alu
    alu_func_o : out alu_func_t;
    carry_o    : out std_ulogic;
    carry_i    : in  std_ulogic;
    zero_i     : in  std_ulogic;

    -- memory
    mem_rd_stb_o : out std_ulogic;
    mem_wr_stb_o : out std_ulogic;

    -- error flag (invalid opcode or register decode error)
    illegal_inst_o : out std_ulogic;
    -- sleep instruction encountered
    cpu_halt_o     : out std_ulogic);

end control;

architecture rtl of control is

  type aState is (Cycle1, Cycle2, CycleFinal, Halt);

  type reg_set_t is record
    state     : aState;
    executing : std_ulogic;
    carry     : std_ulogic;
    zero      : std_ulogic;
    mem_rd    : std_ulogic;
    mem_wr    : std_ulogic;
  end record reg_set_t;

  constant cInitValR : reg_set_t := (
    state     => Cycle1,
    executing => '0',
    carry     => '0',
    zero      => '0',
    mem_rd    => '0',
    mem_wr    => '0'
    );

  signal R, NextR : reg_set_t;

  signal opc_nop : op_code_t;           -- TODO: poor solution
  
  procedure UpdatePC(signal alu_func  : out alu_func_t;
                     signal clk_en_pc : out std_ulogic;
                     signal sel_pc    : out std_ulogic;
                     signal op_code   : in  op_code_t) is
  begin
    if op_code = opc_jump_c or
      (op_code = opc_jumpc_c and R.carry = '1') or
      (op_code = opc_jumpz_c and R.zero = '1')
    then                                -- jump
      sel_pc   <= '0';                  -- Ra register to new pc
      alu_func <= alu_pass_a_c;         -- no alu_func used
    else
      sel_pc <= '1';                    -- alu res to new pc
    end if;
    clk_en_pc <= '1';                   -- store pc
    alu_func  <= alu_inc_c;             -- increment pc
  end procedure;

begin  -- rtl
  opc_nop <= opc_nop_c;

  SetNextR : process(clk_i, res_i)
  begin
    if (res_i = not('1')) then
      R <= cInitValR;
    elsif rising_edge(clk_i) then
      R <= NextR;
    end if;
  end process SetNextR;

  Comb : process (R, op_code_i, reg_decode_error_i, carry_i, zero_i)
  begin
    -- default values
    NextR        <= R;
    NextR.mem_rd <= '0';
    NextR.mem_wr <= '0';

    sel_pc_o          <= '0';
    sel_load_o        <= '0';
    sel_addr_o        <= '1';
    clk_en_pc_o       <= '0';
    clk_en_reg_file_o <= '0';
    clk_en_op_code_o  <= '0';
    alu_func_o        <= alu_pass_a_c;
    carry_o           <= '0';
    cpu_halt_o        <= '0';
    illegal_inst_o    <= '0';

    if R.executing = '1' then
      if unsigned(op_code_i) = to_unsigned(5, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(6, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(7, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(9, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(13, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(14, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(15, op_code_t'length) or
        unsigned(op_code_i) = to_unsigned(25, op_code_t'length) or
        reg_decode_error_i = '1'
      then
        illegal_inst_o <= '1';
      end if;
    end if;

    case R.state is
      when Cycle1 =>
        NextR.state <= CycleFinal;

        if R.executing = '0' then       -- reset
          NextR.mem_rd <= '1';
        else                            -- check op code
          if op_code_i = opc_store_c then
            NextR.mem_wr <= '1';
            NextR.state  <= Cycle2;
          else
            NextR.mem_rd <= '1';
            if op_code_i = opc_loadi_c or op_code_i = opc_load_c then
              NextR.state <= Cycle2;
            end if;
          end if;
          UpdatePC(alu_func_o, clk_en_pc_o, sel_pc_o, op_code_i);
        end if;


      when Cycle2 =>                    -- load and store need extra cycle
        NextR.state  <= CycleFinal;
        NextR.mem_rd <= '1';

        if op_code_i = opc_loadi_c then
          clk_en_reg_file_o <= '1';
          sel_load_o        <= '1';
          sel_addr_o        <= '0';
          UpdatePC(alu_func_o, clk_en_pc_o, sel_pc_o, op_code_i);
        elsif op_code_i = opc_load_c then
          clk_en_reg_file_o <= '1';
          sel_load_o        <= '1';
        end if;

      when CycleFinal =>
        NextR.state      <= Cycle1;
        sel_addr_o       <= '0';        -- load next..
        clk_en_op_code_o <= '1';        -- ..operation
        if R.executing = '0' then
          NextR.executing <= '1';
        else
          case op_code_i is
            when opc_nop_c   => null;
            when opc_sleep_c => cpu_halt_o <= '1'; NextR.state <= Halt;
            when opc_loadi_c => null;
            when opc_load_c  => null;
            when opc_store_c => null;
            when opc_jump_c  => null;
            when opc_jumpc_c => null;
            when opc_jumpz_c => null;
            when opc_move_c  =>
              alu_func_o        <= alu_pass_b_c;
              clk_en_reg_file_o <= '1';
            when opc_and_c =>
              alu_func_o        <= alu_and_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= '0';
              NextR.zero        <= zero_i;
            when opc_or_c =>
              alu_func_o        <= alu_or_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= '0';
              NextR.zero        <= zero_i;
            when opc_xor_c =>
              alu_func_o        <= alu_xor_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= '0';
              NextR.zero        <= zero_i;
            when opc_not_c =>
              alu_func_o        <= alu_not_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= '0';
              NextR.zero        <= zero_i;
            when opc_add_c =>
              alu_func_o        <= alu_add_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_addc_c =>
              alu_func_o        <= alu_add_c;
              carry_o           <= R.carry;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_sub_c =>
              alu_func_o        <= alu_sub_c;
              carry_o           <= '0';
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_subc_c =>
              alu_func_o        <= alu_sub_c;
              carry_o           <= R.carry;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_comp_c =>
              alu_func_o  <= alu_sub_c;
              carry_o     <= '0';
              NextR.carry <= carry_i;
              NextR.zero  <= zero_i;
            when opc_inc_c =>
              alu_func_o        <= alu_inc_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_dec_c =>
              alu_func_o        <= alu_dec_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_shl_c =>
              alu_func_o        <= alu_slc_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_shr_c =>
              alu_func_o        <= alu_src_c;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_shlc_c =>
              alu_func_o        <= alu_slc_c;
              carry_o           <= R.carry;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when opc_shrc_c =>
              alu_func_o        <= alu_src_c;
              carry_o           <= R.carry;
              clk_en_reg_file_o <= '1';
              NextR.carry       <= carry_i;
              NextR.zero        <= zero_i;
            when others => null;
          end case;
        end if;

      when others =>                    -- stay here
        cpu_halt_o <= '1';

    end case;

  end process Comb;

  mem_rd_stb_o <= R.mem_rd;
  mem_wr_stb_o <= R.mem_wr;

end rtl;
