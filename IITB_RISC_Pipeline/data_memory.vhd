library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
	port( 
	 mem_addr_in: in std_logic_vector(15 downto 0);
	 mem_data_in: in std_logic_vector(15 downto 0);
	 mem_out: out std_logic_vector(15 downto 0);
	 mem_read: in std_logic;
	 mem_write: in std_logic;
	 clk : in std_logic
	 );
	 end entity;
	 
architecture working of data_mem is
	type mem_array is array (0 to 31 ) of std_logic_vector (15 downto 0);

	signal mem_data: mem_array := (
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
	memory_read: process(mem_addr_in,mem_read,mem_data )
	begin
	     if(mem_read = '1') then
			mem_out <= mem_data(to_integer(unsigned(mem_addr_in)));
	     end if;		
	end process;
	mem_action: process(clk)
	
	begin
	if (rising_edge(clk)) then
	  if(mem_write = '1') then
	 mem_data(to_integer(unsigned(mem_addr_in))) <= mem_data_in;
	end if;
	end if;
	end process;
end working;
	
	
	
	