-- Project: MIPS32 multi-cycle
-- Module:  ALU_tb
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ALU_tb is 
end entity;

architecture sim of ALU_tb is
signal operand1: std_logic_vector(31 downto 0); 
signal operand2: std_logic_vector(31 downto 0);
signal Alu_Control: std_logic_vector(3 downto 0); 
signal Alu_Result: std_logic_vector(31 downto 0);  
signal zero:std_logic ;	
constant DELAY_PERIOD : time := 5 ns;
begin
	ALU_inst : entity ALU
		port map (
				operand1 => operand1,
				operand2 => operand2,
				ALU_Control => ALU_Control,
				Alu_Result => Alu_Result,
				zero => zero
			);
			stimulus : process
    begin
    	--AND
    	operand1 <= "00000000000000000000000000000100";
        operand2 <= "00000000000000000000000000000101";
        ALU_Control<= "0000";
        wait for DELAY_PERIOD;

         -- OR
        operand1 <= "00000000000000000000000000001000";
        operand2 <= "00000000000000000000000000000100";
        ALU_Control <= "0001";
        wait for DELAY_PERIOD;

        --ADD
        operand1 <= "00000000000000000000000000001111";
        operand2 <= "00000000000000000000000000001100";
        ALU_Control <= "0010";
        wait for DELAY_PERIOD;

        -- SUB 
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000000001100";
        ALU_Control <= "0110";
        wait for DELAY_PERIOD;

        -- NOR 
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000000001100";
        ALU_Control <= "1100";
        wait for DELAY_PERIOD;

        -- XOR
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000000001100";
        ALU_Control <= "0011";
        wait for DELAY_PERIOD;	
		
	    -- SLT
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000000001100";
        ALU_Control <= "0111";
        wait for DELAY_PERIOD;

        -- SLL
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000110000000";-- Shift by 6
        ALU_Control <= "1000";
        wait for DELAY_PERIOD;

         -- SRL
        operand1 <= "00000000000000000000000000001010";
        operand2 <= "00000000000000000000000011000000"; -- Shift by 3 
        ALU_Control<= "1001";
        wait for DELAY_PERIOD;
		
		-- SRA
        operand1 <= "11111111111111111111111111111010";
        operand2 <= "00000000000000000000000011000000"; -- Shift by 3
        ALU_Control<= "1010";
        wait for DELAY_PERIOD;

        -- test zero
 		operand1 <= "00000000000000000000000000001001";
 		operand2 <= "00000000000000000000000000001001";
    	ALU_Control <= "0110"; -- Subtraction
		wait for DELAY_PERIOD;
        wait;
		end process;
		
end architecture;

