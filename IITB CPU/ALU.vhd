library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;

entity alu is
	port(state: in std_logic_vector(5 downto 0);
	 t1: in std_logic_vector(15 downto 0);
	 t2: in std_logic_vector(15 downto 0);
	 t3: in std_logic_vector(15 downto 0);
	 pc_in: in std_logic_vector(15 downto 0);
	 sign_extender_10: in std_logic_vector(15 downto 0);
	 alu_out : out std_logic_vector(15 downto 0); -- substitute for t2 out
	 carry_out: out std_logic;
	 zero_out: out std_logic;
	 pc_out: out std_logic_vector(15 downto 0);
	 clk: in std_logic
	 );
	 end entity;
	 
architecture working of alu is
signal carry: std_logic:='0';
signal zero: std_logic:='0';
begin
	carry_out <= carry;
	zero_out<= zero;
	compute : process(t1,t2,t3, pc_in, sign_extender_10, state,clk)
	variable temp: integer;
	begin
	
	if(state="000001") then
	temp := to_integer(unsigned(pc_in)) + 1;
	pc_out <= std_logic_vector(to_unsigned(temp,16)); 
	
	 elsif (state="000011") then
	 if(t1(15 downto 12) = "0000") then
		
		 temp := to_integer(unsigned(t2)) + to_integer(unsigned(t3));
		 if (temp>=65536) then
			carry <= '1';
			alu_out <= std_logic_vector(to_unsigned(temp-65536,16));
		else
			carry <= '0';
			alu_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		
		if(t1(1 downto 0)="10") then
		
		if (carry='1') then ---adc
			temp := to_integer(unsigned(t2)) + to_integer(unsigned(t3));
			 if (temp>65535) then
				carry <= '1';
				alu_out <= std_logic_vector(to_unsigned(temp-65535,16));
			else
				carry <= '0';
				alu_out <= std_logic_vector(to_unsigned(temp,16));
			end if;
		end if;
		end if;
		
		if(t1(1 downto 0)="01") then
		
		if (zero='1') then---adz
			temp := to_integer(unsigned(t2)) + to_integer(unsigned(t3));
			 if (temp>65535) then
				carry <= '1';
				alu_out <= std_logic_vector(to_unsigned(temp-65535,16));
			else
				carry <= '0';
				alu_out <= std_logic_vector(to_unsigned(temp,16));
			end if;
		end if;
		
	end if;
		
		elsif(t1(15 downto 12)) = "0010" then ---ndu
		
			alu_out <= t2 nand t3;
			if ((t3 nand t2) = x"0000") then
			zero <= '0';
			end if;
		
		if(t1(1 downto 0)="10") then
		if(carry='1') then---ndc
			alu_out <= t3 nand t2;
			if ((t3 nand t2) = x"0000") then
			zero <= '0';
			end if;
		end if;
		end if;
		
		if(t1(1 downto 0)="01") then
		if(zero='1') then---ndz
		alu_out <= t2 nand t3;
		if ((t3 nand t2) = x"0000") then
			zero <= '1';
		end if;
		end if;
		end if;
		
		elsif(t1(15 downto 12)) = "1100" then --beq
		
		if (t2 = t3) then
			zero <= '1';
		else
			zero<= '0';
	end if; 
	end if;
		
	elsif (state="000101") then---adi

		 temp := to_integer(unsigned(t2)) + to_integer(unsigned(sign_extender_10));
		 if (temp>65535) then
			carry <= '1';
			alu_out <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			carry <= '0';
			alu_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		
	elsif (state="001000") then--sw
	
		 temp := to_integer(unsigned(t2)) + to_integer(unsigned(sign_extender_10));
		 if (temp>65535) then
			alu_out <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			alu_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		
	elsif(state="001101") then--beq
		temp := to_integer(unsigned(pc_in)) + to_integer(unsigned(sign_extender_10));
		if(t1(11 downto 9) = t1(8 downto 6)) then
		 if (temp>65535) then
			pc_out <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			pc_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		end if;
		
		elsif(state="001111") then--jal
		temp := to_integer(unsigned(pc_in)) + to_integer(unsigned(sign_extender_10));
		 if (temp>65535) then
			pc_out <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			pc_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		
		elsif(state="010001") then ---lm and sm
		temp := to_integer(unsigned(t2)) + 1;
		alu_out <= std_logic_vector(to_unsigned(temp,16));
		
		
	end if;
	end process;
end working;