library ieee;
use ieee.std_logic_1164.all;

entity Mux2To1_32_tb is
end entity;

architecture sim of Mux2To1_32_tb is 
signal in0: std_logic_vector(31 downto 0):=(others=>'0'); 
signal	in1: std_logic_vector(31 downto 0):=(others=>'1');
signal	selector:  std_logic:='0';
signal	output: std_logic_vector(31 downto 0);
begin	
f:entity Mux2To1_32 port map(in0=>in0,in1=>in1,selector=>selector,output=>output);
	selector<=not selector after 50ns;
	
end architecture ;