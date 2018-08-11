library ieee;
use ieee.std_logic_1164.all;

library work;
use work.prol16_pack.all;

entity cpu is
  
  port (
    clk_i : in std_ulogic;
    res_i : in std_ulogic;

    -- scan test
    test_mode_i   : in std_ulogic;
    scan_enable_i : in std_ulogic;

    -- don't use user types (netlist)
    mem_addr_o : out std_ulogic_vector(data_vec_length_c - 1 downto 0);
    mem_data_o : out std_ulogic_vector(data_vec_length_c - 1 downto 0);
    mem_data_i : in  std_ulogic_vector(data_vec_length_c - 1 downto 0);
    mem_ce_no  : out std_ulogic;        -- chip enable (low active)
    mem_oe_no  : out std_ulogic;        -- output enable (low active)
    mem_we_no  : out std_ulogic;        -- write enable (low active)

    illegal_inst_o : out std_ulogic;
    cpu_halt_o     : out std_ulogic);

end cpu;

architecture rtl of cpu is

  signal res              : std_ulogic;  -- synchronized reset
  signal op_code          : op_code_t;
  signal reg_decode_error : std_ulogic;
  signal sel_pc           : std_ulogic;
  signal sel_load         : std_ulogic;
  signal sel_addr         : std_ulogic;
  signal clk_en_pc        : std_ulogic;
  signal clk_en_reg_file  : std_ulogic;
  signal clk_en_op_code   : std_ulogic;
  signal alu_func         : alu_func_t;
  signal carry_in         : std_ulogic;
  signal carry_out        : std_ulogic;
  signal zero             : std_ulogic;
  signal mem_rd_stb       : std_ulogic;
  signal mem_wr_stb       : std_ulogic;
  
begin  -- rtl

  datapath_inst : datapath
    port map (
      clk_i              => clk_i,
      res_i              => res,
      op_code_o          => op_code,
      reg_decode_error_o => reg_decode_error,
      sel_pc_i           => sel_pc,
      sel_load_i         => sel_load,
      sel_addr_i         => sel_addr,
      clk_en_pc_i        => clk_en_pc,
      clk_en_reg_file_i  => clk_en_reg_file,
      clk_en_op_code_i   => clk_en_op_code,
      alu_func_i         => alu_func,
      carry_i            => carry_in,
      carry_o            => carry_out,
      zero_o             => zero,
      mem_addr_o         => mem_addr_o,
      mem_data_o         => mem_data_o,
      mem_data_i         => mem_data_i);

  control_inst : control
    port map (
      clk_i              => clk_i,
      res_i              => res,
      op_code_i          => op_code,
      reg_decode_error_i => reg_decode_error,
      sel_pc_o           => sel_pc,
      sel_load_o         => sel_load,
      sel_addr_o         => sel_addr,
      clk_en_pc_o        => clk_en_pc,
      clk_en_reg_file_o  => clk_en_reg_file,
      clk_en_op_code_o   => clk_en_op_code,
      alu_func_o         => alu_func,
      carry_o            => carry_in,
      carry_i            => carry_out,
      zero_i             => zero,
      mem_rd_stb_o       => mem_rd_stb,
      mem_wr_stb_o       => mem_wr_stb,
      illegal_inst_o     => illegal_inst_o,
      cpu_halt_o         => cpu_halt_o);

  mem_ce_no <= '0' when (mem_rd_stb = '1' xor mem_wr_stb = '1') else '1';
  mem_oe_no <= '0' when (clk_i = '0' and mem_rd_stb = '1')      else '1';
  mem_we_no <= '0' when (clk_i = '0' and mem_wr_stb = '1')      else '1';

--  sync_reset_inst: sync_reset
--    generic map (
--        nr_of_sync_ffs_g => nr_of_sync_ffs_c)
--    port map (
--        clk_i       => clk_i,
--        res_i       => res_i,
--        test_mode_i => test_mode_i,
--        res_sync_o  => res);

  -- at the moment, reset is not yet synchronized
  res <= res_i;

end rtl;
