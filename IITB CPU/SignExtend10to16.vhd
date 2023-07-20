library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;


entity sign_extender_10_component is
	port(ir_5_0: in std_logic_vector(5 downto 0);
	 alu: out std_logic_vector(15 downto 0);
	 state: in std_logic_vector(5 downto 0)
	 );
end entity;
	 
architecture working of sign_extender_10_component is
begin
	process(ir_5_0, state)
	variable temp: integer;
	begin
	 if (state="000101" or state = "001000" or state="001101" or state="001111") then
		 temp := to_integer(unsigned(ir_5_0));
		 alu <= std_logic_vector(to_unsigned(temp, 16));
		end if;
	end process;
end working;