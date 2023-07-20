library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
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
	 end entity;
	 
architecture working of mem is
	type mem_array is array (0 to 31 ) of std_logic_vector (15 downto 0);
	signal mem_data: mem_array :=(
   x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
   x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000"
   ); 
	
	
	signal mem_ins: mem_array := (
	b"0000000001010000",x"FFFF", x"FFFF", x"FFFF",
	x"FFFF",x"FFFF", x"FFFF", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
   x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000"
	);
	begin
	mem_action: process(clk)
	begin
	if (rising_edge(clk)) then
	if(state="001011" and op_code= "0101") then ---s11 for sw
	 mem_data(to_integer(unsigned(t3_addr))) <= data_t2;
	elsif(state="001011" and op_code= "0111") then ---s11 for sm
		 mem_data(to_integer(unsigned(t2_addr))) <= data_t3;
	end if;
	end if;
	end process;
	mem_read: process(state, t2_addr, t3_addr)
	begin
		if(state ="001001" and op_code = "0110") then---s9 for lm
			data_2 <= mem_data(to_integer(unsigned(t2_addr)));
			
		elsif(state ="001001" and op_code = "0100") then---s9 for lw
			data_2 <= mem_data(to_integer(unsigned(t3_addr)));	
		end if;
	end process;
	t1_data <= mem_ins(to_integer(unsigned(ins_addr)));
end working;
	
	
	
	