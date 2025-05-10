
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_only is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        pc_write    : in std_logic;
        ir_write    : in std_logic;
        reg_write   : in std_logic;
        mem_write   : in std_logic;
        mem_read    : in std_logic
    );
end entity;

architecture rtl of datapath_only is

    component pc_reg is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            pc_write : in std_logic;
            pc_in    : in std_logic_vector(31 downto 0);
            pc_out   : out std_logic_vector(31 downto 0)
        );
    end component;

    component IR_reg is
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

    component Reg_File is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            reg_write   : in std_logic;
            read_reg1   : in std_logic_vector(4 downto 0);
            read_reg2   : in std_logic_vector(4 downto 0);
            write_reg   : in std_logic_vector(4 downto 0);
            write_data  : in std_logic_vector(31 downto 0);
            read_data1  : out std_logic_vector(31 downto 0);
            read_data2  : out std_logic_vector(31 downto 0)
        );
    end component;

    component A_B_reg is
        port (
            clk   : in std_logic;
            AIn   : in std_logic_vector(31 downto 0);
            BIn   : in std_logic_vector(31 downto 0);
            AOut  : out std_logic_vector(31 downto 0);
            BOut  : out std_logic_vector(31 downto 0)
        );
    end component;

    component MDR_reg is
        port (
            clk      : in std_logic;
            reg_in   : in std_logic_vector(31 downto 0);
            reg_out  : out std_logic_vector(31 downto 0)
        );
    end component;

    component ALUOut_reg is
        port (
            clk      : in std_logic;
            reg_in   : in std_logic_vector(31 downto 0);
            reg_out  : out std_logic_vector(31 downto 0)
        );
    end component;

    component Memory is
        port (
            clk        : in std_logic;
            address    : in std_logic_vector(31 downto 0);
            data_in    : in std_logic_vector(31 downto 0);
            mem_write  : in std_logic;
            mem_read   : in std_logic;
            data_out   : out std_logic_vector(31 downto 0)
        );
    end component;

    signal pc_out        : std_logic_vector(31 downto 0);
    signal memory_data   : std_logic_vector(31 downto 0);
    signal ir_opcode     : std_logic_vector(5 downto 0);
    signal ir_rs         : std_logic_vector(4 downto 0);
    signal ir_rt         : std_logic_vector(4 downto 0);
    signal ir_imm        : std_logic_vector(15 downto 0);
    signal reg_data1     : std_logic_vector(31 downto 0);
    signal reg_data2     : std_logic_vector(31 downto 0);
    signal reg_write_data: std_logic_vector(31 downto 0);
    signal alu_result    : std_logic_vector(31 downto 0);
    signal A             : std_logic_vector(31 downto 0);
    signal B             : std_logic_vector(31 downto 0);
    signal mdr_out       : std_logic_vector(31 downto 0);

begin

    pc_u : pc_reg port map (
        clk      => clk,
        reset    => reset,
        pc_write => pc_write,
        pc_in    => alu_result,
        pc_out   => pc_out
    );

    memory_u : Memory port map (
        clk        => clk,
        address    => pc_out,
        data_in    => reg_data2,
        mem_write  => mem_write,
        mem_read   => mem_read,
        data_out   => memory_data
    );

    ir_u : IR_reg port map (
        clk        => clk,
        reset      => reset,
        enable     => ir_write,
        IR_in      => memory_data,
        Op_code    => ir_opcode,
        rs         => ir_rs,
        rt         => ir_rt,
        immediate  => ir_imm
    );

    regfile_u : Reg_File port map (
        clk         => clk,
        reset       => reset,
        reg_write   => reg_write,
        read_reg1   => ir_rs,
        read_reg2   => ir_rt,
        write_reg   => ir_rt,
        write_data  => reg_write_data,
        read_data1  => reg_data1,
        read_data2  => reg_data2
    );

    ab_u : A_B_reg port map (
        clk   => clk,
        AIn   => reg_data1,
        BIn   => reg_data2,
        AOut  => A,
        BOut  => B
    );

    mdr_u : MDR_reg port map (
        clk      => clk,
        reg_in   => memory_data,
        reg_out  => mdr_out
    );

    aluout_u : ALUOut_reg port map (
        clk      => clk,
        reg_in   => alu_result,
        reg_out  => alu_result
    );

end architecture;
