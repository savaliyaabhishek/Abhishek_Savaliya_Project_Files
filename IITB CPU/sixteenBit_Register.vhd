library ieee;
use ieee.std_logic_1164.all;

entity sixteenBit_Register is
	port (d : IN STD_LOGIC_VECTOR(15 downto 0);
				load : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;

				q : OUT STD_LOGIC_VECTOR(15 downto 0));
end sixteenBit_Register;


architecture behav of sixteenBit_Register is
		begin
			process (clk, clr, d, load)
			begin
				if clr = '1' then
					q <= "0000000000000000";
				elsif rising_edge(clk) then
					if load = '1' then
						q <= d;
					end if;
					end if;
			end process;
end behav;