library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;


entity sign_extender_7_component is
	port(t1_8_0: in std_logic_vector(8 downto 0);
	 shifter_7: out std_logic_vector(15 downto 0);
	 state: in std_logic_vector(5 downto 0)
	 );
end entity;
	 
architecture working of sign_extender_7_component is
begin
	ir_proc: process(ir_8_0, state)
	variable temp: integer;
	begin
	 if (state = "000111") then
		 temp := to_integer(unsigned(t1_8_0));
		 shifter_7 <= std_logic_vector(to_unsigned(temp, 16));
		end if;
	end process;
end working;