library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity t2 is 
	port(
		ALU_A     : out std_logic_vector(15 downto 0);
		M_data    : out std_logic_vector(15 downto 0);
		RF_D3     : out std_logic_vector(15 downto 0);
		M_add     : out std_logic_vector(15 downto 0);
		RF_D1     : in std_logic_vector(15 downto 0);
		clk       : in std_logic;
		M_data_in : in std_logic_vector(15 downto 0);
		state     : in std_logic_vector(5 downto 0);
		ALU_C     : in std_logic_vector(15 downto 0);
		op_code   : in std_logic_vector(3 downto 0)
	   );
end t2;

architecture temp2 of t2 is
signal T2: std_logic_vector(15 downto 0);
begin
	T2_out: process(T2, state, op_code, clk)
	begin
		
		if    (state="000011" or state="000101" or state="010001") then
		   ALU_A <= T2;
			
		elsif (state="001011" and op_code="0101") then
			M_data <= T2;
			
		elsif (state="000100" or state="000110" or state="001010") then
			RF_D3 <= T2;
			
		elsif ((state="001001" and op_code="0110") or (state="001011" and op_code="0111"))then
			M_add<= T2;
			
		end if;
	end process;

	T2_in: process(clk)
	begin 
		if(rising_edge(clk)) then
			if (state="000010") then
				T2 <= RF_D1;
			elsif (state="001001" and op_code="0100") then
				T2 <= M_data_in;
			elsif(state="000011" or state="000101" or state="010001") then
				T2 <= ALU_C;
			end if;
		end if;
	end process;
end temp2;