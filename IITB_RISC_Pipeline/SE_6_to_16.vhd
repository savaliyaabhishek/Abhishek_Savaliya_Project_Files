library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sign_Extended_6_to_16 is
	port (input : IN STD_LOGIC_VECTOR(5 downto 0);

				output : OUT STD_LOGIC_VECTOR(15 downto 0));
end Sign_Extended_6_to_16;


architecture info of Sign_Extended_6_to_16 is
		begin
			process (input)
			begin
				output <= std_logic_vector(resize(signed(input), 16));
			end process;
end info;