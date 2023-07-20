-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;

entity DUT is
    port(clock        : in std_logic;
	      reset        : in std_logic;
       	output_vector: out std_logic_vector(15 downto 0));
end entity;

architecture DutWrap of DUT is
  --signals
  signal freeze_set : std_logic:= '0';
  signal pc_output, pc_in_select, update_pc_out, cmem_to_p1, id_to_p2, RF_D3_in, RF_D1_out, RF_D2_out, alu1_a, alu1_b, alu1_c, comp, mem_data_out, alu2_output: std_logic_vector(15 downto 0) := x"0000";
  signal RF_A1_in, RF_A2_in, RF_A3_in : std_logic_vector(2 downto 0) := "000";
  signal p1_in,pipreg1 : std_logic_vector(31 downto 0);
  signal p2_in,pipreg2 : std_logic_vector(47 downto 0);
  signal p3_in,pipreg3 : std_logic_vector(79 downto 0);
  signal p4_in,pipreg4 : std_logic_vector(68 downto 0);
  signal p5_in,pipreg5 : std_logic_vector(68 downto 0);
  
  
  --components
  component pc is
    port (pc_in :in std_logic_vector(15 downto 0);
	      pc_out:out std_logic_vector(15 downto 0);
			rst: in std_logic;
			clk: in std_logic
	      );
	end component;
	
	component UpdatePC is
	port (PC : IN STD_LOGIC_VECTOR(15 downto 0);
         PC_new: OUT STD_LOGIC_VECTOR(15 downto 0));
   end component;
	
	component code_mem is
	port( 
	 mem_in: in std_logic_vector(15 downto 0);
	 mem_out: out std_logic_vector(15 downto 0);
	 clk : in std_logic
	 );
   end component;
	
	component pip_reg1 is
	port (data_in : IN STD_LOGIC_VECTOR(31 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(31 downto 0));
	end component;		

   component Instruction_decode is
	port (inst: in std_logic_vector(15 downto 0);
			control_signal: out std_logic_vector(15 downto 0)
		
	) ;
	end component;	

  component pip_reg2 is
	port (data_in : IN STD_LOGIC_VECTOR(47 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(47 downto 0));
	end component;		
  
  component pip_reg3 is
	port (data_in : IN STD_LOGIC_VECTOR(79 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(79 downto 0));
	end component;	
	
	component pip_reg4 is
	port (data_in : IN STD_LOGIC_VECTOR(68 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(68 downto 0));
	end component;	
	
	component pip_reg5 is
	port (data_in : IN STD_LOGIC_VECTOR(68 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(68 downto 0));
	end component;	
	
	component RF is 
	port (RF_a1: in std_logic_vector(2 downto 0);
			RF_a2: in std_logic_vector(2 downto 0);
			RF_a3: in std_logic_vector(2 downto 0);
			RF_D3: in std_logic_vector(15 downto 0);
			PC: in std_logic_vector(15 downto 0);
			RF_D1: out std_logic_vector(15 downto 0);
			RF_D2: out std_logic_vector(15 downto 0);
			RF_read: in std_logic;
			clk: in std_logic;
			RF_write: in std_logic
			
	);
	end component;	
   
	component alu is
	port(
	 alu_a:  in std_logic_vector(15 downto 0);
	 alu_b:  in std_logic_vector(15 downto 0);
	 alu_c:  out std_logic_vector(15 downto 0);
	 alu_op: in std_logic_vector(1 downto 0);
	 carry_in: in std_logic_vector(0 downto 0);
	 zero_in: in std_logic;
	 carry_out: out std_logic_vector(0 downto 0);
	 zero_out: out std_logic;
	 compare_out: out std_logic
	 );
	 end component;
  
  component  data_mem is
	port( 
	 mem_addr_in: in std_logic_vector(15 downto 0);
	 mem_data_in: in std_logic_vector(15 downto 0);
	 mem_out: out std_logic_vector(15 downto 0);
	 mem_read: in std_logic;
	 mem_write: in std_logic;
	 clk : in std_logic
	 );
	 end component;
  
  component Alu_2 is
	port(
	 pc_in:  in std_logic_vector(15 downto 0);
	 imm:  in std_logic_vector(8 downto 0);
	 alu_c:  out std_logic_vector(15 downto 0)
	 );
	 end component;
  
  
  begin
  --processes
  pc_input : process( pipreg5,update_pc_out,alu2_output)
  begin
  if(pipreg5(44 downto 43) = "01") then
    pc_in_select <= alu2_output;         --output of alu2 is pc + 2*Imm (or ra+ 2*imm)
  elsif(pipreg5(44 downto 43) = "10") then
    pc_in_select <= pipreg5(63 downto 48);  --this is storing regB in pc
  else
   pc_in_select <= update_pc_out;

  end if;	 
  end process; 
  
  
  
  RF_write_inputs : process ( pipreg5 )
  begin
  
  if(pipreg5(46 downto 45) = "01") then
     if(pipreg5(47)='1') then
	    RF_A3_in <= pipreg5(11 downto 9);
       RF_D3_in <= pipreg5(31 downto 16);
	  else
	   RF_A3_in <= pipreg5(11 downto 9);
      RF_D3_in <= pipreg5(63 downto 48); 
	  end if;
	  
  elsif(pipreg5(46 downto 45) = "10") then
     if(pipreg5(47)='1') then
	    RF_A3_in <= pipreg5(11 downto 9);
       RF_D3_in(8 downto 0) <= pipreg5(8 downto 0);
		 RF_D3_in(15 downto 9) <= "0000000";
	  else
	   RF_A3_in <= pipreg5(11 downto 9);
      RF_D3_in <= pipreg5(31 downto 16); 
	  end if;  
  elsif(pipreg5(37) = '1') then   -- ADI
       RF_A3_in <= pipreg5(8 downto 6);
       RF_D3_in <= pipreg5(63 downto 48);
  else
  RF_A3_in <= pipreg5(5 downto 3);
  RF_D3_in <= pipreg5(63 downto 48);
   
  end if;
  end process;
  
  alu1a_input: process (pipreg3)
  begin
  if(pipreg3(46 downto 45) = "11" or pipreg3(37) = '1' ) then
    alu1_a <= pipreg3(63 downto 48);
  else
    alu1_a <= pipreg3(79 downto 64);  
  end if;  
  end process;
  
  complement : process (pipreg3)
  begin
  if(pipreg3(46 downto 45) = "11" and pipreg3(2) = '1' ) then
      for i in 0 to 7 loop
            comp(i) <= not(pipreg3(64 + i));
       end loop;
	else
     comp<= pipreg3(79 downto 64);
	 end if; 
  end process;
  
  alu1b_input: process (pipreg3,comp,pipreg5)
  begin
  if(pipreg3(46 downto 45) = "01" ) then
  alu1_b <= std_logic_vector(resize(signed(pipreg5(5 downto 0)), 16));
  else
  alu1_b <= comp;
  end if;
  end process;
  
  
  
  --pipreg_inputs
  p1_in(15 downto 0) <= pc_output;
  p1_in(31 downto 16) <= cmem_to_p1; 
  p2_in(31 downto 0) <= pipreg1;
  p2_in(47 downto 32) <= id_to_p2; 
  p3_in(47 downto 0) <= pipreg2; 
  p3_in(63 downto 48) <= RF_D1_out; 
  p3_in(79 downto 64) <= RF_D2_out; 
  p4_in(47 downto 32) <= pipreg3(47 downto 32);
  p4_in(15 downto 0) <= pipreg3(15 downto 0);
  p4_input_store: process (pipreg3, alu1_c)
  begin 
  if( pipreg3(34) = '1' ) then
     p4_in(31 downto 16) <= alu1_c;
	else
     p4_in(31 downto 16) <= pipreg3(31 downto 16);     	
  end if;
  end process;
  
  p4_input: process (pipreg3, alu1_c)
  begin 
  if(pipreg3(46 downto 45) = "11" or pipreg3(37) = '1' ) then
  p4_in(63 downto 48) <= alu1_c;
  elsif(pipreg3(46 downto 45) = "10" ) then
  p4_in(63 downto 48) <= pipreg3(63 downto 48);
  elsif(pipreg3(46 downto 45) = "01" ) then
  p4_in(63 downto 48) <= pipreg3(79 downto 64);
  else
  p4_in(63 downto 48) <= alu1_c;
  end if;
  end process;
  
  p4_in(64) <= pipreg4(66);
  p4_in(65) <= pipreg4(67);
  p5_in(47 downto 0) <= pipreg4(47 downto 0);
  p5_in(68 downto 64) <= pipreg4(68 downto 64);
  
  p5_input: process (pipreg4, mem_data_out)
  begin 
  if( pipreg4(42) = '1' ) then
     p5_in(63 downto 48) <= mem_data_out;
	else
     p5_in(63 downto 48) <= pipreg4(63 downto 48);     	
  end if;
  end process;
  
  --component instances
  pc_instance: pc 
    port map(
	 pc_in => pc_in_select,
	 pc_out => pc_output,
	 rst => reset,
	 clk => clock
	 );
	
  alu0_instance: UpdatePC
    port map (
	 PC => pc_output,
	 PC_new => update_pc_out
	 );
	 
	codemem_instance: code_mem 
	port map( 
	 mem_in => pc_output,
	 mem_out => cmem_to_p1,
	 clk => clock
	 ); 
	 
	 pipreg1_instance: pip_reg1 
	 port map(
	    data_in => p1_in,
		 freeze => freeze_set,
		  clr => reset,
	     clk => clock,
		 data_out => pipreg1
		 );
		 
   id_instance: Instruction_decode 
	port map(inst =>  pipreg1(15 downto 0),
			  control_signal => id_to_p2
	        ) ; 
	
   pipreg2_instance: pip_reg2 
	 port map(
	    data_in => p2_in,
		 freeze => freeze_set,
		  clr => reset,
	     clk => clock,
		 data_out => pipreg2
		 );	
	
	RF_instance: RF 
	port map(
	      RF_a1 => pipreg2(11 downto 9),
			RF_a2 => pipreg2(8 downto 6),
			RF_a3 => RF_A3_in,
			RF_D3 => RF_D3_in,
			PC    => update_pc_out,
			RF_D1 => RF_D1_out,
			RF_D2 => RF_D2_out,
			RF_read => pipreg2(42),
			clk   => clock,
			RF_write => pipreg5(41)
	);
	
	
   pipreg3_instance: pip_reg3 
	 port map(
	    data_in => p3_in,
		 freeze => freeze_set,
		  clr => reset,
	     clk => clock,
		 data_out => pipreg3
		 );
		
	alu1_instance: alu 
	port map(
	 alu_a => alu1_a,
	 alu_b => alu1_b,
	 alu_c => alu1_c,
	 alu_op => pipreg3(40 downto 39),
	 carry_in => pipreg4(67 downto 67),
	 zero_in  => pipreg4(66),
	 carry_out=> p4_in(67 downto 67),
	 zero_out => p4_in(66),
	 compare_out=> p4_in(68)
	 );	
		
	pipreg4_instance: pip_reg4
	 port map(
	    data_in => p4_in,
		 freeze => freeze_set,
		  clr => reset,
	     clk => clock,
		 data_out => pipreg4
		 );

	data_mem_instance:  data_mem 
	port map( 
	 mem_addr_in => pipreg4(31 downto 16),
	 mem_data_in => pipreg4(63 downto 48),
	 mem_out      => mem_data_out,
	 mem_read     => pipreg4(36),
	 mem_write    => pipreg4(35),
	 clk => clock
	 );
	 
		
		
	pipreg5_instance: pip_reg5 
	 port map(
	    data_in => p5_in,
		 freeze =>freeze_set,
		  clr => reset,
	     clk => clock,
		 data_out => pipreg5
		 );	
		 
	alu2_instance:Alu_2 
	port map(
	 pc_in => pipreg5(31 downto 16),
	 imm   => pipreg5(8 downto 0),
	 alu_c => alu2_output
	 );
	 
	output_vector <= pc_output;
end DutWrap;