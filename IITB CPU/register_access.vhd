library ieee;
use ieee.std_logic_1164.all;

entity register_access is
	port (R0, R1, R2, R3, R4, R5, R6, R7 : IN STD_LOGIC_VECTOR(15 downto 0);
				Rinput : IN STD_LOGIC_VECTOR(2 downto 0);

				Routput: OUT STD_LOGIC_VECTOR(15 downto 0));
end register_access;


architecture behav of register_access is
		begin
			process (Rinput, R0, R1, R2, R3, R4, R5, R6, R7)
			begin
				case Rinput is
	        when "000" =>
	                Routput <= R0;
					when "001" =>
	                Routput <= R1;
					when "010" =>
	                Routput <= R2;
					when "011" =>
	                Routput <= R3;
					when "100" =>
	                Routput <= R4;
					when "101" =>
	                Routput <= R5;
					when "110" =>
	                Routput <= R6;
					when "111" =>
	                Routput <= R7;
					when others =>
									Routput <= R0;
	      end case;
			end process;
end behav;