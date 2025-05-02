-- Project: MIPS32 multi-cycle
-- Module:  Control unit

library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
	
	port(
	-- input
	ALUOp : in std_logic_vector(1 downto 0);
	func : in std_logic_vector(5 downto 0);
	Op : in std_logic_vector(5 downto 0);
	-- output
	operation : out std_logic_vector(3 downto 0)
	);
	
end ALUControl;

architecture behavior of ALUControl is
begin
	
operation <= "0010" when ALUOp = "00" else -- add (LW or SW instruc) (I_type instruc)
"0110" when ALUOp = "01" else -- subtract (beq instruc)	(I_type instruc)
"0000" when ALUOp = "11" and Op = "001100" else -- andi (I_type instruc)
"0001" when ALUOp = "11" and Op = "001101" else -- ori (I_type instruc)	
"0010" when ALUOp = "10" and func = "100000" else --add (R_type instruc)
"0110" when ALUOp = "10" and func = "100010" else --subtract (R_type instruc)
"0000" when ALUOp = "10" and func = "100100" else --AND (R_type instruc)
"0001" when ALUOp = "10" and func = "100101" else --OR (R_type instruc)
"0011" when ALUOp = "10" and func = "100110" else --XOR (R_type instruc)	
"1100" when ALUOp = "10" and func = "100111" else --NOR (R_type instruc)	
"0111" when ALUOp = "10" and func = "101010" else --slt(set on less than) (R_type instruc)
"1000" when ALUOp = "10" and func = "000000" else --sll (shift left logical) (R_type instruc)	
"1001" when ALUOp = "10" and func = "000010" else --srl (shift right logical) (R_type instruc)
"1010" when ALUOp = "10" and func = "000011" else --sra (shift right arithmatic) (R_type instruc)
"0000";

end behavior;	