library ieee;
use ieee.std_logic_1164.all;

entity Mux3To1_32 is
	port(
	in0:in std_logic_vector(31 downto 0); 
	in1:in std_logic_vector(31 downto 0); 
    in2:in std_logic_vector(31 downto 0); 
	selector: in std_logic_vector(1 downto 0);
	output:out std_logic_vector(31 downto 0)
	);
end entity;

architecture behave of Mux3To1_32 is
begin	
	with selector select 
	output<= in0 when "00",
	in1 when "01",
	in2 when "10",
	(others=>'0') when others;
	
end architecture ;