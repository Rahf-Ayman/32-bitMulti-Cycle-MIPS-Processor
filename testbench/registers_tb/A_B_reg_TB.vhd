library ieee;
use ieee.std_logic_1164.all;

entity A_B_reg_tb is
end A_B_reg_tb;

architecture behavior of A_B_reg_tb is
    signal clk   : std_logic := '0';
    signal AIn   : std_logic_vector(31 downto 0) := (others => '0');
    signal BIn   : std_logic_vector(31 downto 0) := (others => '0');
    signal AOut  : std_logic_vector(31 downto 0);
    signal BOut  : std_logic_vector(31 downto 0);

    component A_B_reg
        port (
            clk   : in std_logic;
            AIn   : in std_logic_vector(31 downto 0);
            BIn   : in std_logic_vector(31 downto 0);
            AOut  : out std_logic_vector(31 downto 0);
            BOut  : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: A_B_reg
        port map (
            clk   => clk,
            AIn   => AIn,
            BIn   => BIn,
            AOut  => AOut,
            BOut  => BOut
        );

    clk_process: process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        wait for 10 ns;
        AIn <= x"11111111";
        BIn <= x"22222222";
        wait for 10 ns;
        AIn <= x"33333333";
        BIn <= x"44444444";
        wait for 10 ns;
        wait;
    end process;

end behavior;
