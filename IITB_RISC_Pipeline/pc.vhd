
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pc is 
	port (pc_in :in std_logic_vector(15 downto 0);
	      pc_out:out std_logic_vector(15 downto 0);
			rst: in std_logic;
			clk: in std_logic
	      );
	end entity;
	
architecture program of pc is 
signal pc: std_logic_vector(15 downto 0) := x"0000";
begin
  
pc_read: process(pc_in, pc)
begin 
	pc_out <= pc;
 end process;
 
pc_write: process(clk,pc, pc_in,rst)
begin
 if (rst = '1') then
	 pc <= x"0000";
 elsif (rising_edge(clk)) then
	 pc <= pc_in;
end if;	
end process;
end program;