
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RF is 
	port (RF_a1: in std_logic_vector(2 downto 0);
			RF_a2: in std_logic_vector(2 downto 0);
			RF_a3: in std_logic_vector(2 downto 0);
			RF_D3: in std_logic_vector(15 downto 0);
			PC: in std_logic_vector(15 downto 0);
			RF_D1: out std_logic_vector(15 downto 0);
			RF_D2: out std_logic_vector(15 downto 0);
			RF_read: in std_logic;
			clk: in std_logic;
			RF_write: in std_logic
			
	);
	end entity;
	
architecture working of RF is 
type mem_array is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal regs: mem_array :=(
   x"0001",x"0001", x"FFFF", x"FFFF",
	x"FFFF",x"FFFF", x"FFFF", x"FFFF"
   ); 
begin
regs_read: process(RF_a1, RF_a2, RF_read,regs)
begin 
   if (RF_read ='1') then
	RF_D1 <= regs(to_integer(unsigned(RF_a1)));
	RF_D2 <= regs(to_integer(unsigned(RF_a2)));	
	end if;
 end process;
 
regs_write: process(clk)
begin
 if (rising_edge(clk)) then
   regs(0) <= pc;
	if( RF_a3 = "000") then
	regs(0) <= pc;
	else
	regs(to_integer(unsigned(RF_a3))) <= RF_D3;
	end if;
	end if;
end process;
end working;