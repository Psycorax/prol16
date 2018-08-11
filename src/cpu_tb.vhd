library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library work;
use work.prol16_pack.all;

entity cpu_tb is
  
  generic (
    file_base_g : string := "main");    -- file name base for ass/log/hex

end cpu_tb;

architecture beh of cpu_tb is

  component memory
    generic (
      file_base_g : string := "main");  -- base name for assember, log and dump file
    port (
      mem_addr_i : in    std_ulogic_vector(15 downto 0);  -- address input
      mem_dat_io : inout std_logic_vector(15 downto 0);   -- data i/o
      mem_ce_ni  : in    std_ulogic;    -- chip enable (low active)
      mem_oe_ni  : in    std_ulogic;    -- output enable (low active)
      mem_we_ni  : in    std_ulogic);   -- write enable (low active)
  end component;

  signal clk          : std_ulogic := '0';
  signal res          : std_ulogic;
  signal test_mode    : std_ulogic;
  signal scan_enable  : std_ulogic;
  signal mem_addr     : std_ulogic_vector(data_vec_length_c - 1 downto 0);
  signal mem_data_out : std_ulogic_vector(data_vec_length_c - 1 downto 0);
  signal mem_data_in  : std_ulogic_vector(data_vec_length_c - 1 downto 0);
  signal mem_data_io  : std_logic_vector(data_vec_length_c - 1 downto 0);
  signal mem_ce_n     : std_ulogic;
  signal mem_oe_n     : std_ulogic;
  signal mem_we_n     : std_ulogic;
  signal illegal_inst : std_ulogic;
  signal cpu_halt     : std_ulogic;

begin  -- beh

  ----------------------------------------------------------------------
  -- clock and reset generation
  
  clk <= clk when cpu_halt = '1' else
         not clk after clock_period_c/2;

  res <= reset_active_nc, not reset_active_nc after clock_period_c;

  ----------------------------------------------------------------------
  -- our device under test

  dut : cpu
    port map (
      clk_i          => clk,
      res_i          => res,
      test_mode_i    => test_mode,
      scan_enable_i  => scan_enable,
      mem_addr_o     => mem_addr,
      mem_data_o     => mem_data_out,
      mem_data_i     => mem_data_in,
      mem_ce_no      => mem_ce_n,
      mem_oe_no      => mem_oe_n,
      mem_we_no      => mem_we_n,
      illegal_inst_o => illegal_inst,
      cpu_halt_o     => cpu_halt);

  -- for now, we operate in mission mode
  test_mode   <= '0';
  scan_enable <= '0';

  -- FIXME: model bidirectional pad
  mem_data_in <= to_stdulogicvector(mem_data_io);
  mem_data_io <= to_stdlogicvector(mem_data_out) when mem_we_n = '0' else (others => 'Z');

  assert now = 0 ns or illegal_inst = '0'
    report "illegal instruction" severity warning;

  ----------------------------------------------------------------------
  -- memory behavioral model
  
  memory_inst : memory
    generic map (
      file_base_g => file_base_g)
    port map (
      mem_addr_i => mem_addr,
      mem_dat_io => mem_data_io,
      mem_ce_ni  => mem_ce_n,
      mem_oe_ni  => mem_oe_n,
      mem_we_ni  => mem_we_n);

  ----------------------------------------------------------------------
  -- print out current op code as debugging aid

  debug_stuff : block
    signal pc : data_vec_t;
    signal ir : data_vec_t;
  begin  -- block debug_stuff

    init_signal_spy("/dut/datapath_inst/reg_pc", "pc");
    init_signal_spy("/dut/datapath_inst/reg_opcode", "ir");

    process
      variable line_v : line;
    begin  -- process
      wait until ir'event;
      write(line_v, to_integer(unsigned(pc)), field => 6);
      write(line_v, string'(": "));
      write(line_v, mnemonic_table_c(to_integer(unsigned(ir(op_code_range_t)))));
      writeline(output, line_v);
    end process;
    
  end block debug_stuff;
  
end beh;
