library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        operand1    : in  std_logic_vector(31 downto 0);
        operand2    : in  std_logic_vector(31 downto 0);
        Alu_Control : in  std_logic_vector(3 downto 0);
        Alu_Result  : out std_logic_vector(31 downto 0);
        zero        : out std_logic
    );
end entity;

architecture behave of ALU is
    signal temp : std_logic_vector(31 downto 0);
begin

    process(operand1, operand2, Alu_Control)
    begin
        case Alu_Control is
            when "0000" => -- AND
                temp <= operand1 and operand2;

            when "0001" => -- OR
                temp <= operand1 or operand2;

            when "0010" => -- ADD
                temp <= std_logic_vector(unsigned(operand1) + unsigned(operand2));

            when "0110" => -- SUBTRACT
                temp <= std_logic_vector(unsigned(operand1) - unsigned(operand2));

            when "0011" => -- XOR
                temp <= operand1 xor operand2;

            when "1100" => -- NOR
                temp <= not (operand1 or operand2);

            when "0111" => -- SLT (set less than)
                if signed(operand1) < signed(operand2) then
                    temp <= std_logic_vector(to_unsigned(1, 32));
                else
                    temp <= (others => '0');
                end if;

            when "1000" => -- Shift left logical (SLL)
                temp <= std_logic_vector(shift_left(unsigned(operand1),  to_integer(unsigned(operand2(10 downto 6)))));

            when "1001" => -- Shift right logical (SRL)
                temp <= std_logic_vector(shift_right(unsigned(operand1), to_integer(unsigned(operand2(10 downto 6)))));

            when "1010" => -- Shift right arithmetic (SRA)
                temp <= std_logic_vector(shift_right(signed(operand1), to_integer(unsigned(operand2(10 downto 6)))));

            when others =>
                temp <= (others => '0');
        end case;
    end process;

    Alu_Result <= temp;
    zero <= '1' when temp =  "00000000000000000000000000000000" else '0';

end architecture;

