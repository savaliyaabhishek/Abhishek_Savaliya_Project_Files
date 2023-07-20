library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UpdatePC is
	port (PC : IN STD_LOGIC_VECTOR(15 downto 0);
         PC_new: OUT STD_LOGIC_VECTOR(15 downto 0));
end UpdatePC;


architecture behave of UpdatePC is
  constant one: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001";
  begin
      process(PC)
      begin
			  PC_new <= STD_LOGIC_VECTOR(unsigned(PC) + unsigned(one));
		end process;
end behave;