library ieee;
use ieee.std_logic_1164.all;

--A package declaration is used to store a set of common declarations, such as components.
--These declarations can then be imported into other design units using a use clause.

package Gates is
  component INVERTER is
   port (A: in std_logic; Y: out std_logic);
  end component INVERTER;

  component AND_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component AND_2;

  component NAND_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component NAND_2;

  component OR_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component OR_2;

  component AND_3 is
   port (A, B, C: in std_logic; Y: out std_logic);
  end component AND_3;

  component OR_3 is
   port (A, B, C: in std_logic; Y: out std_logic);
  end component OR_3;

  component NOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component NOR_2;

  component XOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component XOR_2;

  component XNOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
  end component XNOR_2;

  component HALF_ADDER is
   port (A, B: in std_logic; S, C: out std_logic);
  end component HALF_ADDER;

  component FULL_ADDER is
   port (A, B, C: in std_logic; S, Cout: out std_logic);
  end component FULL_ADDER;

  component A4as is
   port (A3, A2, A1, A0, B3, B2, B1, B0, M: in std_logic; C_out, S3, S2, S1, S0: out std_logic);
  end component A4as;
end package Gates;


library ieee;
use ieee.std_logic_1164.all;
entity INVERTER is
   port (A: in std_logic; Y: out std_logic);
end entity INVERTER;

architecture Equations of INVERTER is
begin
   Y <= not A;
end Equations;
  

library ieee;
use ieee.std_logic_1164.all;
entity AND_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity AND_2;

architecture Equations of AND_2 is
begin
   Y <= A and B;
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
entity NAND_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity NAND_2;

architecture Equations of NAND_2 is
begin
   Y <= not (A and B);
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
entity OR_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity OR_2;

architecture Equations of OR_2 is
begin
   Y <= A or B;
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
entity NOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity NOR_2;

architecture Equations of NOR_2 is
begin
   Y <= not (A or B);
end Equations;
  

library ieee;
use ieee.std_logic_1164.all;
entity XOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity XOR_2;

architecture Equations of XOR_2 is
begin
   Y <= A xor B;
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
entity XNOR_2 is
   port (A, B: in std_logic; Y: out std_logic);
end entity XNOR_2;

architecture Equations of XNOR_2 is
begin
   Y <= not (A xor B);
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
entity HALF_ADDER is
   port (A, B: in std_logic; S, C: out std_logic);
end entity HALF_ADDER;

architecture Equations of HALF_ADDER is
begin
   S <= (A xor B);
   C <= (A and B);
end Equations;

library ieee;
use ieee.std_logic_1164.all;
entity FULL_ADDER is
   port (A, B, C: in std_logic; S, Cout: out std_logic);
end entity FULL_ADDER;

architecture Equations of FULL_ADDER is
begin
   S <= (A xor B xor C);
   Cout <= (A and B) or (A and C) or (B and C);
end Equations;
  
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity A4as is
  port (A3, A2, A1, A0, B3, B2, B1, B0, M: in std_logic; C_out, S3, S2, S1, S0: out std_logic);
end entity A4as;

architecture Struct of A4as is
  signal K3, K2, K1, K0, Y1, Y2, Y3 : std_logic;
begin
  -- component instances
  XOR0: XOR_2 port map (A => B0, B => M, Y => K0);
  XOR1: XOR_2 port map (A => B1, B => M, Y => K1);
  XOR2: XOR_2 port map (A => B2, B => M, Y => K2);
  XOR3: XOR_2 port map (A => B3, B => M, Y => K3);
  FA0: FULL_ADDER port map (A => K0, B => A0, C => M, S => S0, Cout => Y1);
  FA1: FULL_ADDER port map (A => K1, B => A1, C => Y1, S => S1, Cout => Y2);
  FA2: FULL_ADDER port map (A => K2, B => A2, C => Y2, S => S2, Cout => Y3);
  FA3: FULL_ADDER port map (A => K3, B => A3, C => Y3, S => S3, Cout => C_out);
  
  end struct;

library ieee;
use ieee.std_logic_1164.all;
entity OR_3 is
   port (A, B, C: in std_logic; Y: out std_logic);
end entity OR_3;

architecture Equations of OR_3 is
begin
   Y <= ((A or B)or C);
end Equations;

library ieee;
use ieee.std_logic_1164.all;
entity AND_3 is
   port (A, B, C: in std_logic; Y: out std_logic);
end entity AND_3;

architecture Equations of AND_3 is
begin
   Y <= ((A and B)and C);
end Equations;
