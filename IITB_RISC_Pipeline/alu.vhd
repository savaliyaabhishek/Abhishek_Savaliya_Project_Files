library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;

entity alu is
	port(
	 alu_a:  in std_logic_vector(15 downto 0);
	 alu_b:  in std_logic_vector(15 downto 0);
	 alu_c:  out std_logic_vector(15 downto 0);
	 alu_op: in std_logic_vector(1 downto 0);
	 carry_in: in std_logic_vector(0 downto 0);
	 zero_in: in std_logic;
	 carry_out: out std_logic_vector(0 downto 0);
	 zero_out: out std_logic;
	 compare_out: out std_logic
	 );
	 end entity;
	 
architecture working of alu is
begin
 
	compute : process(alu_op, alu_a, alu_b, carry_in, zero_in)
	variable temp : integer;
	begin
	if( alu_op ="00") then
      	 temp := to_integer(unsigned(alu_a)) + to_integer(unsigned(alu_b));
			 
		     if (temp>=65536) then
			   carry_out(0) <= '1';
			   alu_c <= std_logic_vector(to_unsigned(temp-65536,16));
		     else
			   carry_out(0) <= '0';
			   alu_c <= std_logic_vector(to_unsigned(temp,16));
		     end if;
			  
			   if (temp = 0) then
			     zero_out <= '1';
			   else
			     zero_out <= '0';
			   end if;
			compare_out <= '0';	
  	elsif(alu_op = "01") then
            alu_c <= alu_a nand alu_b;
			   if ((alu_a nand alu_b) = x"0000") then
			   zero_out <= '0';
				else 
				zero_out <= zero_in;
			   end if;	
				carry_out <= carry_in;
				compare_out <= '0';
	elsif(alu_op = "10") then
	         if(alu_a = alu_b) then
				  zero_out <= '1';
				  compare_out <= '0';
				elsif(alu_a  < alu_b) then
				 compare_out <= '1';
				 zero_out <= '1';
				else
			     zero_out <= zero_in;
				  compare_out <= '0';
				end if;
		      carry_out <= carry_in;
				alu_c <= x"0000";
  else
temp := to_integer(unsigned(alu_a)) + to_integer(unsigned(alu_b)) + to_integer(unsigned(carry_in));
			 
		     if (temp>=65536) then
			   carry_out(0) <= '1';
			   alu_c <= std_logic_vector(to_unsigned(temp-65536,16));
		     else
			   carry_out(0) <= '0';
			   alu_c <= std_logic_vector(to_unsigned(temp,16));
		     end if;
			  
			   if (temp= 0) then
			     zero_out <= '1';
			   else
			     zero_out <= '0';
			   end if;
			compare_out <= '0';
  
	end if;
	end process;
end working;