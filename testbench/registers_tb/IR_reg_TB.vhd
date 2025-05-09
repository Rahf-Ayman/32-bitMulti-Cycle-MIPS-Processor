library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_reg_tb is
end entity;

architecture behavior of IR_reg_tb is
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal enable     : std_logic := '0';
    signal IR_in      : std_logic_vector(31 downto 0) := (others => '0');
    signal Op_code    : std_logic_vector(31 downto 26);
    signal rs         : std_logic_vector(25 downto 21);
    signal rt         : std_logic_vector(20 downto 16);
    signal immediate  : std_logic_vector(15 downto 0);

    component IR_reg
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
    end component;

begin

    uut: IR_reg
        port map (
            clk        => clk,
            reset      => reset,
            enable     => enable,
            IR_in      => IR_in,
            Op_code    => Op_code,
            rs         => rs,
            rt         => rt,
            immediate  => immediate
        );

    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    stim_proc : process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        enable <= '1';
        IR_in <= x"8C130004"; -- ãËÇá Úáì instruction: LW $19, 4($0)
        wait for 20 ns;

        IR_in <= x"AC140008"; -- SW $20, 8($0)
        wait for 20 ns;

        enable <= '0';
        IR_in <= x"FFFFFFFF";
        wait for 20 ns;

        wait;
    end process;

end architecture;
