-- Project: MIPS32 multi-cycle
-- Module:  ShiftLeft32
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ShiftLeft1 is
	port(
	i:in std_logic_vector(31 downto 0);
	o:out  std_logic_vector(31 downto 0)
	
	);
end entity;

architecture behave of ShiftLeft1 is
begin	
	 o <= std_logic_vector(unsigned(i) sll 2);
end architecture ;