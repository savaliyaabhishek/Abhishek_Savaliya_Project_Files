library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity code_mem is
	port( 
	 mem_in: in std_logic_vector(15 downto 0);
	 mem_out: out std_logic_vector(15 downto 0);
	 clk : in std_logic
	 );
	 end entity;
	 
architecture working of code_mem is
	type mem_array is array (0 to 31 ) of std_logic_vector (15 downto 0);

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
	mem_read: process(mem_in, mem_ins)
	begin
			mem_out <= mem_ins(to_integer(unsigned(mem_in)));		
	end process;
end working;
	
	
	
	