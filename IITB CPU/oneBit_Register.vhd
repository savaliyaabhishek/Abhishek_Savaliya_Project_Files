library ieee;
use ieee.std_logic_1164.all;

entity oneBit_Register is
	port (d : IN STD_LOGIC;
				load : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;

				q : OUT STD_LOGIC);
end oneBit_Register;


architecture behav of oneBit_Register is
		begin
			process (d, load, clk, clr)
			begin
				if clr = '1' then
					q <= '0';
				elsif rising_edge(clk) then
					if load = '1' then
						q <= d;
					end if;
					end if;
			end process;
end behav;