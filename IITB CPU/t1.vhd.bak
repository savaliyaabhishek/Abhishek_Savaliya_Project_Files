library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t1 is
	port (
		RF_A1: out std_logic_vector(2 downto 0);
		RF_A2: out std_logic_vector(2 downto 0);
		RF_A3: out std_logic_vector(2 downto 0);
		SE9in: out std_logic_vector(8 downto 0);
		SE6in: out std_logic_vector(5 downto 0);
		M_data:in std_logic_vector(15 downto 0);
		clk  : in std_logic;
		state: in std_logic_vector(5 downto 0)
	) ;
end t1;

architecture temp of t1 is
signal t1: std_logic_vector(15 downto 0);
begin
	write_process: process(clk)
	begin
	if(falling_edge(clk)) then
		if(state="000001") then
			t1 <= M_data;
	end if;
	end if;
	end process;
	
	read_process: process(t1, state)
	begin
	
	if    (state="000010") then
		RF_A1  <=t1(11 downto 9);
		RF_A2  <= t1(8 downto 6);
		
	elsif (state="000100") then	
		RF_A3 <= t1(5 downto 3);
		
	elsif(state="000101" or state="001000" or state="001101" or state="001111") then
		SE6in <= t1(5 downto 0);	
		
	elsif (state="000110") then
		RF_A3 <=t1(8 downto 6);	
		
	elsif (state="000111") then
		SE9in <= t1(8 downto 0);
		RF_A3 <= t1(11 downto 9);
		
	elsif(state="001010" or state="1110") then
		RF_A3 <= t1(11 downto 9);
		
	end if;
	end process;

end temp;







