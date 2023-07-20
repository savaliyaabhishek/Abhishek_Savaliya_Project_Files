library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ins_setter is
port(   reset,clock:in std_logic;
        next_state: in std_logic_vector(5 downto 0);
		  state: out std_logic_vector(5 downto 0)
		  );
end ins_setter;

architecture working of ins_setter is
 constant S1 : STD_LOGIC_VECTOR(5 downto 0) := "000001";
 
 
begin

clock_proc:process(clock,reset)
begin
    if(clock='1' and clock' event) then
        if(reset='1') then
            state<=S1;
        else
            state<=next_state;
        end if;
    end if;
    
end process;

end working;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ins_decoder is
port(
        next_state: out std_logic_vector(5 downto 0);
		  state: in std_logic_vector(5 downto 0);
		  op_code: in std_logic_vector(3 downto 0);
		  cz: in std_logic_vector(1 downto 0);
		  imm: in std_logic_vector(8 downto 0);
		  carry: in std_logic;
		  zero: in std_logic
		  );
end ins_decoder;

architecture working of ins_decoder is
  
 signal imm_copy : std_logic_vector(8 downto 0) := imm(8 downto 0);
 signal i:integer := 1;
 signal j:integer := 0;
 constant S1 : STD_LOGIC_VECTOR(5 downto 0) := "000001";
 constant S2 : STD_LOGIC_VECTOR(5 downto 0) := "000010";
 constant S3 : STD_LOGIC_VECTOR(5 downto 0) := "000011";
 constant S4 : STD_LOGIC_VECTOR(5 downto 0) := "000100"; 
 constant S5 : STD_LOGIC_VECTOR(5 downto 0) := "000101";
 constant S6 : STD_LOGIC_VECTOR(5 downto 0) := "000110";
 constant S7 : STD_LOGIC_VECTOR(5 downto 0) := "000111";
 constant S8 : STD_LOGIC_VECTOR(5 downto 0) := "001000";
 constant S9 : STD_LOGIC_VECTOR(5 downto 0) := "001001";
 constant S10: STD_LOGIC_VECTOR(5 downto 0) := "001010";
 constant S11: STD_LOGIC_VECTOR(5 downto 0) := "001011";
 constant S12: STD_LOGIC_VECTOR(5 downto 0) := "001100";
 constant S13: STD_LOGIC_VECTOR(5 downto 0) := "001101";
 constant S14: STD_LOGIC_VECTOR(5 downto 0) := "001110";
 constant S15: STD_LOGIC_VECTOR(5 downto 0) := "001111";
 constant S16: STD_LOGIC_VECTOR(5 downto 0) := "010000";
 constant S17: STD_LOGIC_VECTOR(5 downto 0) := "010001";
 constant S18: STD_LOGIC_VECTOR(5 downto 0) := "010010";
 constant S19: STD_LOGIC_VECTOR(5 downto 0) := "010011";
 constant S20: STD_LOGIC_VECTOR(5 downto 0) := "010100";
 constant S21: STD_LOGIC_VECTOR(5 downto 0) := "010101";
 constant S22: STD_LOGIC_VECTOR(5 downto 0) := "010110";
 constant S23: STD_LOGIC_VECTOR(5 downto 0) := "010111";
 constant S24: STD_LOGIC_VECTOR(5 downto 0) := "011000";
 constant S25: STD_LOGIC_VECTOR(5 downto 0) := "011001";
 constant S26: STD_LOGIC_VECTOR(5 downto 0) := "011010";
 constant S27: STD_LOGIC_VECTOR(5 downto 0) := "011011";
 constant S28: STD_LOGIC_VECTOR(5 downto 0) := "011100";
 constant S29: STD_LOGIC_VECTOR(5 downto 0) := "011101";
 constant S30: STD_LOGIC_VECTOR(5 downto 0) := "011110";
 constant S31: STD_LOGIC_VECTOR(5 downto 0) := "011111";
 constant S32: STD_LOGIC_VECTOR(5 downto 0) := "100000";
 constant S33: STD_LOGIC_VECTOR(5 downto 0) := "100001";
 constant S_stop_1: STD_LOGIC_VECTOR(5 downto 0) := "110000";
 constant S_stop_2: STD_LOGIC_VECTOR(5 downto 0) := "111001";
 
 begin
 
 next_state_process: process(state,op_code,cz,imm,carry,zero)
 
	begin
	case state is
	
	when "111111" =>
		next_state <= "111111";
	when S1 =>
	if(op_code = "1111") then
		next_state <= "111111";
	else
		next_state <= S2;
	end if;
   when S2 =>
	--add/c/z , ndu/c/z and beq
	if ((op_code = "1100") OR (((op_code = "0000") OR (op_code= "0010")) AND ((cz = "00") OR (cz = "01" AND zero='1') OR (cz = "10" AND carry='1'))))  then
		next_state <= S3;
	
	--adi
	elsif (op_code = "0001") then
		next_state <= S5;
	
	--lhi
	elsif(op_code = "0011") then
		next_state <= S7;
		
	--lw and sw
	elsif(op_code(3 downto 1) = "010") then 
		next_state <= S8;
	
	--lm
	elsif(op_code = "0110")then
		if(imm(0) = '1') then
		next_state <=S9;
		else
		next_state <= S17;
		end if;
		
	
	--jlr and jal
	elsif(op_code(3 downto 1) = "100") then 
		next_state <= S14;

	--sm
	elsif(op_code = "0111") then
	if(imm(0) = '1') then
		next_state <= S26;
		else
		next_state <= S17;
		end if;
	

	end if;

	when S3 =>
	--add/z/c and ndu/c/z
	if(op_code = "0000" or op_code = "0010") then
		next_state <= S4;
	
	--beq
	elsif(op_code = "1100") then 
		next_state <= S13;
		
	end if;
	
	when S4 =>
		next_state <= S1;
		
	when S5 =>
	if(op_code = "0001") then
		next_state <= S6;
	end if;
	
	when S6 =>
		next_state <= S1;
		
	when S7 =>
		next_state <= S1;
		
	when S8 =>
	--lw
	if(op_code = "0100") then
		next_state <= S9;
		
	--sw
	elsif(op_code = "0101") then
		next_state <= s11;
		
	end if;
		
	when S9 =>
	--lw
	if(op_code = "0100") then 
		next_state <= S10;
	
	--lm
	elsif(op_code = "0110") then
			j <= i - 1;
			next_state <= S_stop_1;
			end if;
			
		when S_stop_1 =>
				if(j=0)then
				next_state <= S18;
				elsif(j=1)then
				next_state <= S19;
				elsif(j=2)then
				next_state <= S20;
				elsif(j=3)then
				next_state <= S21;
				elsif(j=4)then
				next_state <= S22;
				elsif(j=5)then
				next_state <= S23;
				elsif(j=6)then
				next_state <= S24;
				elsif(j=7)then
				next_state <= S25;
				end if;
				
		when S_stop_2 =>
		if(op_code="0110") then
			if(i>7)then	
			i<=1;
			next_state <= S1;
			elsif(imm(i)='1')then
			i<=i+1;
			next_state <= S9;
			elsif(imm(i)='0') then
			i<=i+1;
			next_state <= S17;

			end if;
			
		elsif(op_code="0111")then
			if (i>7) then
			i<=1;
				next_state<=S1;
			elsif(imm(i)='1')then
				if(i=1)then
				next_state<=S27;
				elsif(i=2)then
				next_state<=S28;
				elsif(i=3)then
				next_state<=S29;
				elsif(i=4)then
				next_state<=S30;
				elsif(i=5)then
				next_state<=S31;
				elsif(i=6)then
				next_state<=S32;
				elsif(i=7)then
				next_state<=S33;
				end if;
			i<=i+1;
			else
			next_state<=S17;
			i<=i+1;
			end if;
		end if;
	
	when S10 =>
	if(op_code = "0100") then
		next_state <= S1;
	end if;
	
	when S11 =>
	if(op_code = "0101") then
		next_state <= S1;	
	elsif(op_code = "0111") then
		next_state <= S17;
	end if;
		
	when S13 =>
	if(op_code = "1100") then
		next_state <= S1;
	end if;
		
	when S14 =>
	--jal
	if(op_code = "1000") then 
		next_state <= S15;
	--jlr	
	elsif(op_code = "1001") then 
		next_state <= S16;
		
	end if;
		
	when S15 =>
	if(op_code = "1000") then 
		next_state <= S1;
	end if;
		
	when S16 =>
	if(op_code = "1001") then 
		next_state <= S1;
	end if;
		
	when S17 =>
	if(op_code="0110") then
			if(i>7)then	
			i<=1;
			next_state<=S1;
			elsif(imm(i)='1')then
			i<=i+1;
			next_state<=S9;
			elsif(imm(i)='0') then
			i<=i+1;
			next_state<=S_stop_2;
			end if;
		elsif(op_code="0111")then
			if (i>7) then
			i<=1;
				next_state<=S1;
			elsif(imm(i)='1')then
				if(i=1)then
				next_state<=S27;
				elsif(i=2)then
				next_state<=S28;
				elsif(i=3)then
				next_state<=S29;
				elsif(i=4)then
				next_state<=S30;
				elsif(i=5)then
				next_state<=S31;
				elsif(i=6)then
				next_state<=S32;
				elsif(i=7)then
				next_state<=S33;
				end if;
			i<=i+1;
			else
			next_state<=S_stop_2;
			i<=i+1;
			end if;
		end if;
		
		
		
	when S18 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S19 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S20 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S21 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S22 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S23 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S24 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S25 =>
   if(op_code = "0110") then
	next_state <= S17;
	end if;
	
	when S26 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S27 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S28 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S29 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S30 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S31 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S32 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when S33 =>
   if(op_code = "0111") then
	next_state <= S11;
	end if;
	
	when others =>
	next_state<= S1;
	end case;
end process;
end working;