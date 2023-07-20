library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_decode is
	port (inst: in std_logic_vector(15 downto 0);
			control_signal: out std_logic_vector(15 downto 0)
		
	) ;
	
--control_signal(1) = SE_16_Wb
--control_signal(2) = Store instruction
--control_signal(3) = Mem_write_data
--control_signal(4) = Mem_read_data	
--control_signal(5) = SE_16_mux_exe
--control_signal(6) = Comp_mux_exe
--control_signal(7) = Alu_op(0)
--control_signal(8) = Alu_op(1)
--control_signal(9) = RF_write_data
--control_signal(10)= RF_read_data
--00 => Add
--01 => nand
--10 => sub
--11 => add with carry
--control_signal(11)= Branch_mux_wb(0)
--control_signal(12)= Branch_mux_wb(1)
--00 => alu0
--01 => regB
--10 => alu2
--11 => regA + Imm
--control_signal(13)= ins_type(0)
--control_signal(14)= ins_type(1)
--00 => nope
--01 => i type
--10 => j type
--11 => r type	
end Instruction_decode;

architecture temp of Instruction_decode is
begin
	out_process: process(inst)
	begin
	
	if ((inst(15 downto 12)="0001")and(inst(2)='0')and((inst(1 downto 0)="00")or(inst(1 downto 0)="10")or(inst(1 downto 0)="01"))) then
		control_signal <= "0110011000000000";
		
		
	elsif ((inst(15 downto 12)="0001")and(inst(2)='0')and(inst(1 downto 0)="11")) then
		control_signal <= "0110011110000000";
		
	elsif ((inst(15 downto 12)="0001")and(inst(2)='1')and((inst(1 downto 0)="00")or(inst(1 downto 0)="10")or(inst(1 downto 0)="01"))) then
		control_signal <= "0110011001000000";	
		
	elsif ((inst(15 downto 12)="0001")and(inst(2)='1')and(inst(1 downto 0)="11")) then
		control_signal <= "0110011111000000";
		
	elsif ((inst(15 downto 12)="0010")and(inst(2)='0')and((inst(1 downto 0)="00")or(inst(1 downto 0)="10")or(inst(1 downto 0)="01"))) then
		control_signal <= "0110011010000000";	
	
	elsif ((inst(15 downto 12)="0010")and(inst(2)='1')and((inst(1 downto 0)="00")or(inst(1 downto 0)="10")or(inst(1 downto 0)="01"))) then
		control_signal <= "0110011011000000";
		
	elsif (inst(15 downto 12) ="0011") then
		control_signal <= "0100001000000000";
		
	elsif (inst(15 downto 12) ="0100") then
		control_signal <= "0010011000110000";
		
	elsif (inst(15 downto 12) ="0101") then
		control_signal <= "0010010000101100";
		
	elsif ((inst(15 downto 12) ="1000")or(inst(15 downto 12) ="1001")or(inst(15 downto 12) ="1010")) then
		control_signal <= "0010010000000010";
		
	elsif (inst(15 downto 12) ="1100") then
		control_signal <= "0100001000000010";
		
	elsif (inst(15 downto 12) ="1101") then
		control_signal <= "0010111000000000";
		
	elsif (inst(15 downto 12) ="1111") then
		control_signal <= "0101110000000010";
	else
      control_signal <= x"0000";	
	end if;
	end process;

end temp;