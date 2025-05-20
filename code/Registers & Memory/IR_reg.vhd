-- Project: MIPS32 multi-cycle
-- Module:  IR_reg
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_reg is
    port (
        clk        : in std_logic;
        reset      : in std_logic;
        enable     : in std_logic;
        IR_in      : in std_logic_vector(31 downto 0);
        Op_code    : out std_logic_vector(31 downto 26);
        rs         : out std_logic_vector(25 downto 21);
        rt         : out std_logic_vector(20 downto 16);
        immediate  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of IR_reg is
    signal rd            : std_logic_vector(4 downto 0);
    signal funct         : std_logic_vector(5 downto 0);
    signal jump_address  : std_logic_vector(25 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            Op_code    <= (others => '0');
            rs         <= (others => '0');
            rt         <= (others => '0');
            immediate  <= (others => '0');

        elsif rising_edge(clk) then
            if enable = '1' then
                Op_code       <= IR_in(31 downto 26);
                rs            <= IR_in(25 downto 21);
                rt            <= IR_in(20 downto 16);
                rd            <= IR_in(15 downto 11);
                funct         <= IR_in(5 downto 0);
                immediate     <= IR_in(15 downto 0);
                jump_address  <= IR_in(25 downto 0);
            end if;
        end if;
    end process;
end architecture;
