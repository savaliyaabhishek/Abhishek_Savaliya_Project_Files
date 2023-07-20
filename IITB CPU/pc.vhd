
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pc is 
	port (alu_c: in std_logic_vector(15 downto 0);
			t3   : in std_logic_vector(15 downto 0);
			state: in std_logic_vector(5 downto 0);
			clk  : in std_logic;
			alu_a: out std_logic_vector(15 downto 0);
			m_add: out std_logic_vector(15 downto 0);
			RF_D3: out std_logic_vector(15 downto 0);
			R7   : out std_logic_vector(15 downto 0)
	      );
	end entity;
	
architecture program of pc is 
signal pc: std_logic_vector(15 downto 0) := x"0000"; 
begin
R7 <= pc; 
pc_out: process(state)
begin 
	if (state = "000001") then
		m_add <= pc;
		alu_a <= pc;
	elsif (state="001110") then
		RF_D3 <= pc;
	end if;
 end process;
 
pc_in: process(clk)
begin
 if (rising_edge(clk)) then
	if (state = "000001" or state="001111" or state="001101" ) then
		pc <= alu_c;
	elsif (state="010000") then
		pc <= t3;
	end if;
end if;	
end process;
end program;