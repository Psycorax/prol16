--------------------------------------------------------------------------------
-- Title       : ALU
-- Project     : prol16
--------------------------------------------------------------------------------
-- RevCtrl     : 
-- Authors     : Reisinger Thomas
--------------------------------------------------------------------------------
-- Description : 
--------------------------------------------------------------------------------

architecture Rtl of alu is

begin

  aluproc : process(side_a_i, side_b_i, carry_i, alu_func_i)
    
    variable add_b     : std_ulogic_vector(side_b_i'range) := (others => '0');
    variable add_cin   : std_logic                         := '0';
    variable cout      : std_logic                         := '0';
    variable alu_res   : std_ulogic_vector(result_o'range) := (others => '0');
    variable inv_carry : std_logic                         := '0';

    procedure add (add_b : in std_ulogic_vector; add_cin : in std_ulogic; inv_carry : in std_logic; add_res : out std_ulogic_vector; add_cout : out std_ulogic) is
      variable res : unsigned(bit_width_g+1 downto 0);
    begin
      
      res     := unsigned ('0' & side_a_i & '1') + unsigned ('0' & add_b & add_cin);
      add_res := std_ulogic_vector (res(res'high-1 downto res'low+1));
      if inv_carry = '1' then
        add_cout := not(res(res'high));
      else
        add_cout := res(res'high);
      end if;
      
      
    end;

  begin

    alu_res   := (others => '0');
    cout      := '0';
    inv_carry := '0';

    case alu_func_i is
      when alu_pass_a_c =>
        alu_res := side_a_i;
        
      when alu_pass_b_c =>
        alu_res := side_b_i;
        
      when alu_and_c =>
        alu_res := side_a_i and side_b_i;
        
      when alu_or_c =>
        alu_res := side_a_i or side_b_i;
        
      when alu_xor_c =>
        alu_res := side_a_i xor side_b_i;
        
      when alu_not_c =>
        alu_res := not(side_a_i);

      when alu_add_c | alu_sub_c | alu_inc_c | alu_dec_c =>
        case alu_func_i is
          when alu_add_c =>
            add_b   := side_b_i;
            add_cin := carry_i;
            
          when alu_sub_c =>
            add_b     := not side_b_i;
            add_cin   := not carry_i;
            inv_carry := '1';
            
          when alu_inc_c =>
            add_b   := (others => '0');
            add_cin := '1';
            
          when alu_dec_c =>
            add_b     := (others => '1');
            add_cin   := '0';
            inv_carry := '1';

          when others =>
            add_b   := (others => 'X');
            add_cin := 'X';

        end case;
        add(add_b, add_cin, inv_carry, alu_res, cout);
        
      when alu_slc_c =>
        cout    := side_a_i(side_a_i'high);
        alu_res := side_a_i(side_a_i'high-1 downto side_a_i'low) & carry_i;
        
      when alu_src_c =>
        cout    := side_a_i(side_a_i'low);
        alu_res := carry_i & side_a_i(side_a_i'high downto side_a_i'low+1);
        
      when others =>
        cout    := 'X';
        alu_res := (others => 'X');
    end case;

    carry_o  <= cout;
    result_o <= alu_res;
    if unsigned(alu_res) = 0 then
      zero_o <= '1';
    else
      zero_o <= '0';
    end if;

  end process aluproc;

end RTL;
