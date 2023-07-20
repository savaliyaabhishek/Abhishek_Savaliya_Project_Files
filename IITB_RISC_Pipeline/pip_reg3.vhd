library ieee;
use ieee.std_logic_1164.all;

entity pip_reg3 is
	port (data_in : IN STD_LOGIC_VECTOR(79 downto 0);
				freeze : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;

				data_out : OUT STD_LOGIC_VECTOR(79 downto 0));
end pip_reg3;


architecture info of pip_reg3 is
signal p1: std_logic_vector(79 downto 0) :=  x"00000000000000000000";
begin

  
piperead: process(data_in, freeze, p1)
begin 
data_out <= p1;

 end process;
 
pipewrite: process(clk,clr)
begin
 if (clr = '1') then
	 p1 <= x"00000000000000000000";
 elsif (rising_edge(clk)) then
 if freeze = '0' then
	 p1 <= data_in;
end if;	
end if;
end process;

		--begin
			---process (clk, clr, data_in, freeze)
			--begin
				--if clr = '1' then
				---	data_out <= x"00000000000000000000";
				--elsif rising_edge(clk) then
				--	if freeze = '0' then
				--		data_out <= data_in;
				--	end if;
				--	end if;
			--end process;
end info;