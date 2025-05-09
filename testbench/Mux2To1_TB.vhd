library ieee;
use ieee.std_logic_1164.all;

entity Mux2To1_tb is
end entity;

architecture sim of Mux2To1_tb is  
component  Mux2To1  
	generic(n:integer:=32);
	port(
	in0:in std_logic_vector(n-1 downto 0); 
	in1:in std_logic_vector(n-1 downto 0);
	selector: in std_logic;
	output:out std_logic_vector(n-1 downto 0)
	);	 
end component;

signal in0: std_logic_vector(31 downto 0):=(others=>'0'); 
signal	in1: std_logic_vector(31 downto 0):=(others=>'1');
signal	selector:  std_logic:='0';
signal	output: std_logic_vector(31 downto 0);
signal width:integer:=32;
begin	
f: Mux2To1 generic map(n=>width)
port map(in0=>in0,in1=>in1,selector=>selector,output=>output);
	selector<=not selector after 50ns;
	
end architecture ;
