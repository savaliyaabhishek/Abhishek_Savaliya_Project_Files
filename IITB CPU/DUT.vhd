library ieee;
use ieee.std_logic_1164.all;
entity DUT is
port ( input_vector : in std_logic_vector(0 downto 0);
			output_vector: out std_logic_vector(6 downto 0));
end entity;

architecture DutWrap of DUT is
	signal state: std_logic_vector(5 downto 0 ):="000001";
	signal next_state: std_logic_vector(5 downto 0 ):="000001";
	signal clk: std_logic;
	signal reset: std_logic;
	signal curr_ins, w_addr2, w_addr3,  w_pc_reg_up, w_t2_reg, w_alu_pc, w_dout, w_din_t3, w_din_t2, w_shift7_reg, w_t3_in, w_t3, w_t2, w_t2_in, w_pc_alu,  w_pc_reg, w_t3_pc, w_t2_din, w_alu_t2, w_t3_alu, w_t2_alu, w_se10, w_ins_addr: std_logic_vector(15 downto 0);
	signal w1,w2,w3: std_logic_vector(2 downto 0);
	signal w4: std_logic_vector(8 downto 0);
	signal w5: std_logic_vector(5 downto 0);
	signal w0: std_logic_vector(3 downto 0);
	signal carry, zero: std_logic;
   component ins_decoder is
      port(
        next_state: out std_logic_vector(5 downto 0);
		  state: in std_logic_vector(5 downto 0);
		  op_code: in std_logic_vector(3 downto 0);
		  cz: in std_logic_vector(1 downto 0);
		  imm: in std_logic_vector(8 downto 0);
		  carry: in std_logic;
		  zero: in std_logic
		  );
		  
   end component;
	
	component ins_setter is 
		port(   reset,clock:in std_logic;
        next_state: in std_logic_vector(5 downto 0);
		  state: out std_logic_vector(5 downto 0)
		  );
	end component;
	
	component t1 is
	   port (
		RF_A1: out std_logic_vector(2 downto 0);
		RF_A2: out std_logic_vector(2 downto 0);
		RF_A3: out std_logic_vector(2 downto 0);
		SE9in: out std_logic_vector(8 downto 0);
		SE6in: out std_logic_vector(5 downto 0);
		op_code: out std_logic_vector(3 downto 0);
		M_data:in std_logic_vector(15 downto 0);
		clk  : in std_logic;
		state: in std_logic_vector(5 downto 0)
	   ) ;
	end component;
	
	component mem is
	port( t2_addr: in std_logic_vector(15 downto 0);
	t3_addr: in std_logic_vector(15 downto 0);
	 state: in std_logic_vector(5 downto 0);
	 data_t3: in std_logic_vector(15 downto 0);
	 data_t2: in std_logic_vector(15 downto 0);
	 data_2: out std_logic_vector(15 downto 0);
	 t1_data: out std_logic_vector(15 downto 0);
	 op_code: in std_logic_vector(3 downto 0);
	 ins_addr: in std_logic_vector(15 downto 0);
	 clk : in std_logic
	 );
	end component;
	
	component registers is 
	port (reg_a1: in std_logic_vector(2 downto 0);
			reg_a2: in std_logic_vector(2 downto 0);
			reg_a3: in std_logic_vector(2 downto 0);
			t2: out std_logic_vector(15 downto 0);
			t2_in: in std_logic_vector(15 downto 0);
			t3: out std_logic_vector(15 downto 0);
			t3_in: in std_logic_vector(15 downto 0);
			shift7: in std_logic_vector(15 downto 0); 
			clk: in std_logic;
			state: in std_logic_vector(5 downto 0);
			pc: in std_logic_vector(15 downto 0);
			pc_update: in std_logic_vector(15 downto 0)
	);
	end component;
	
	component t2 is 
	port(
		ALU_A     : out std_logic_vector(15 downto 0);
		M_data    : out std_logic_vector(15 downto 0);
		RF_D3     : out std_logic_vector(15 downto 0);
		M_add     : out std_logic_vector(15 downto 0);
		RF_D1     : in std_logic_vector(15 downto 0);
		clk       : in std_logic;
		M_data_in : in std_logic_vector(15 downto 0);
		state     : in std_logic_vector(5 downto 0);
		ALU_C     : in std_logic_vector(15 downto 0);
		op_code   : in std_logic_vector(3 downto 0)
	   );
	end component;
	
	
	component sign_extender_10_component is
	port(ir_5_0: in std_logic_vector(5 downto 0);
	 alu: out std_logic_vector(15 downto 0);
	 state: in std_logic_vector(5 downto 0)
	 );
	end component;
	
	component shifter_7 is 
	port (ir_8_0: in std_logic_vector(8 downto 0);
			rf_d3: out std_logic_vector(15 downto 0);
			state: in std_logic_vector(5 downto 0)
	);
	end component;
	
	
	component  pc is 
	port (alu_c: in std_logic_vector(15 downto 0);
			t3   : in std_logic_vector(15 downto 0);
			state: in std_logic_vector(5 downto 0);
			clk  : in std_logic;
			alu_a: out std_logic_vector(15 downto 0);
			m_add: out std_logic_vector(15 downto 0);
			RF_D3: out std_logic_vector(15 downto 0);
			R7   : out std_logic_vector(15 downto 0)
	      );
	end component;
	

component t3 is 
	port(
		ALU_A    : out std_logic_vector(15 downto 0);
		M_add    : out std_logic_vector(15 downto 0);
	   M_data   : out std_logic_vector(15 downto 0);
		pc       : out std_logic_vector(15 downto 0);
		RF_D3    : out std_logic_vector(15 downto 0);
		M_data_in: in std_logic_vector(15 downto 0);
		RF_D2    : in std_logic_vector(15 downto 0);
		ALU_C    : in std_logic_vector(15 downto 0);
		state    : in std_logic_vector(5 downto 0);
		clk      : in std_logic;
		op_code  : in std_logic_vector(3 downto 0)
	   );
end component;


component alu is
	port(state: in std_logic_vector(5 downto 0);
	 t1: in std_logic_vector(15 downto 0);
	 t2: in std_logic_vector(15 downto 0);
	 t3: in std_logic_vector(15 downto 0);
	 pc_in: in std_logic_vector(15 downto 0);
	 sign_extender_10: in std_logic_vector(15 downto 0);
	 alu_out : out std_logic_vector(15 downto 0); -- substitute for t2 out
	 carry_out: out std_logic;
	 zero_out: out std_logic;
	 pc_out: out std_logic_vector(15 downto 0);
	 clk: in std_logic
	 );
	 end component;
	 
	 
begin
	output_vector(5 downto 0) <= state;
	output_vector(6) <= carry;
   stateTrans_instance: ins_decoder
			port map (
					next_state => next_state,
					state => state,
					op_code => w0,
 					cz => curr_ins(1 downto 0),
					imm => curr_ins(8 downto 0),
					carry=> carry,
					zero=> zero
 					);
					
	stateSet_instance: ins_setter
		port map (
			clock => input_vector(0),
			next_state => next_state,
			state => state,
			reset => reset
		);
		
		t1_instance: t1
			port map(
			clk => input_vector(0),
			state => state,
		   M_data => curr_ins,
			SE9in => w4,
			RF_A1 => w1,
			RF_A2 => w2,
			RF_A3 => w3,
			SE6in => w5,
			op_code => w0
			);
			
		mem_instance: mem
			port map(
				state => state,
				clk => input_vector(0),
				t2_addr => w_addr2,
				t3_addr => w_addr3,
				data_t2 => w_din_t2,
				data_t3=>  w_din_t3,
				data_2 => w_dout,
				t1_data => curr_ins,
				ins_addr => w_ins_addr,
				op_code => w0
			);
			
			reg_instance: registers
				port map(
					reg_a1 => w1,
					reg_a2 => w2,
					reg_a3 => w3,
					state => state,
					clk => input_vector(0),
					pc => w_pc_reg,
					shift7 => w_shift7_reg,
					t2_in => w_t2_in,
					t2 => w_t2,
					t3 => w_t3,
					t3_in => w_t3_in,
					pc_update => w_pc_reg_up
				);
				
			t2_instance: t2
				port map (
					state => state,
					clk => input_vector(0),
					RF_D1 => w_t2,
					M_data_in => w_dout,
					ALU_C => w_alu_t2,
					ALU_A => w_t2_alu,
					M_data => w_din_t2,
					RF_D3 => w_t2_in,
					M_add => w_addr2,
					op_code => w0
				);
				
				
			t3_instance: t3
					port map (
						state => state,
						clk => input_vector(0),
						M_data_in => w_dout,
						RF_D2 => w_t3,
						ALU_C => w_alu_t2,
						op_code => w0,
						ALU_A => w_t3_alu,
						pc => w_t3_pc,
						M_add => w_addr3,
						M_data => w_din_t3,
						RF_D3 => w_t3_in
					);
				
				
				alu_instance: alu
					port map(
						state => state,
						t1 => curr_ins,
						t2 => w_t2_alu,
						t3 => w_t3_alu,
						pc_in => w_pc_alu,
						sign_extender_10 => w_se10,
						pc_out => w_alu_pc,
						carry_out=> carry,
						zero_out=> zero,
						alu_out => w_alu_t2,
						clk => input_vector(0)
					);
					
				pc_instance: pc
					port map (
					state=> state,
					clk => input_vector(0),
					alu_c => w_alu_pc,
					t3=> w_t3_pc,
					m_add => w_ins_addr,
					alu_a=> w_pc_alu,
					RF_D3=> w_pc_reg,
					R7=> w_pc_reg_up
					);
					
			
					
				shift7_instance: shifter_7
					port map (
					 state=> state,
					 ir_8_0=> w4,
					 rf_d3=>w_shift7_reg
					);
					
				sign_ex10_instance: sign_extender_10_component --SE6
					port map (
						state=> state,
						ir_5_0=> w5,
						alu=> w_se10
					);
					
				
					
end DutWrap;

