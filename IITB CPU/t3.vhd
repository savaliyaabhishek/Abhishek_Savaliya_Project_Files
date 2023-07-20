library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity t3 is 
	port(
		ALU_A    : out std_logic_vector(15 downto 0);
		M_add    : out std_logic_vector(15 downto 0);
	   M_data   : out std_logic_vector(15 downto 0);
		pc       : out std_logic_vector(15 downto 0);
		RF_D3    : out std_logic_vector(15 downto 0);
		M_data_in: in std_logic_vector(15 downto 0);
		RF_D2    : in std_logic_vector(15 downto 0);
		ALU_C    : in std_logic_vector(15 downto 0);
		state    : in std_logic_vector(5 downto 0);
		clk      : in std_logic;
		op_code  : in std_logic_vector(3 downto 0)
	   );
end t3;

architecture temp3 of t3 is
signal T3: std_logic_vector(15 downto 0);
begin
	t3_out: process(T3, state, op_code)
	begin
		if (state="000011" ) then
		ALU_A  <= T3;

		elsif (state="001000") then
		ALU_A  <= T3;
		
		elsif (state="010000") then
		pc  <= T3;

		elsif ((state="001001" and op_code="0100") or (state="001011" and op_code="0101")) then
		M_add <= T3;
		
		elsif (state="001011" and op_code="0111") then
		M_data <= T3;
		
		elsif (state="010010" or state="010011" or state="010100" or state="010101" or state="010110" or state="010111" or state="011000" or state="011001") then
		RF_D3  <=T3;
		end if;
	end process;

	write_proc: process(clk)
	begin 
		if(rising_edge(clk)) then
		if (state="000010" or state="011010" or state="011011" or state="011100" or state="011101" or state="011110" or state="011111" or state="100000" or state="100001") then
		T3 <= RF_D2;
      elsif (state="001000") then
		T3 <= ALU_C;
		elsif (state="001001" and op_code="0110") then
		T3 <= M_data_in;
			
		end if;
		end if;
	end process;
end temp3;