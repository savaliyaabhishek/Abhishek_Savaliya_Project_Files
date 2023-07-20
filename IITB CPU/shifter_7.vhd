
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shifter_7 is 
	port (ir_8_0: in std_logic_vector(8 downto 0);
			rf_d3: out std_logic_vector(15 downto 0);
			state: in std_logic_vector(5 downto 0)
	);
	end entity;
	
architecture working of shifter_7 is
begin
	ir_proc: process(ir_8_0)
	variable i: integer;
	begin
	 if (state="000111") then
	 rf_d3(6 downto 0) <= "0000000";
		 FOR i IN 7 TO 15 LOOP
	        rf_d3(i) <= ir_8_0(i-7);
	      END LOOP;
	end if;
	end process;
end working;