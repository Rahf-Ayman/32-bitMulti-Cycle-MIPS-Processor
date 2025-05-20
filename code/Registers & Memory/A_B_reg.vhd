-- Project: MIPS32 multi-cycle
-- Module:  A_B_reg
library ieee;
use ieee.std_logic_1164.all;

entity A_B_reg is
    port (
        clk   : in std_logic;
        AIn   : in std_logic_vector(31 downto 0);
        BIn   : in std_logic_vector(31 downto 0);
        AOut  : out std_logic_vector(31 downto 0);
        BOut  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of A_B_reg is
    signal regA, regB : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            regA <= AIn;
            regB <= BIn;
        end if;
    end process;

    AOut <= regA;
    BOut <= regB;
end architecture;
