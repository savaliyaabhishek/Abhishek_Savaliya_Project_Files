library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;

entity Alu_2 is
	port(
	 pc_in:  in std_logic_vector(15 downto 0);
	 imm:  in std_logic_vector(8 downto 0);
	 alu_c:  out std_logic_vector(15 downto 0)
	 );
	 end entity;
	 
architecture working of Alu_2 is
signal inter: std_logic_vector(15 downto 0);
begin

	addition: process(pc_in, imm,inter)
	variable answer: integer;
	begin
	
	inter <= std_logic_vector(resize(signed(imm), 16));
	
	answer := to_integer(unsigned(pc_in)) + to_integer(unsigned(inter));
	
	if(answer>=65536) then
		alu_c <= std_logic_vector(to_unsigned(answer-65536,16));
		
	else
	alu_c <= std_logic_vector(to_unsigned(answer,16));
	
	end if;
	end process;
	
end working;