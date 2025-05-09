library ieee;
use ieee.std_logic_1164.all;

entity connection is
	port (
	CLK : in std_logic;
	reset : in std_logic
	);
end connection;

architecture behavior of connection is
-- component of register
	-- here
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
	
	
--

-- component of dataflow
	-- here
--

-- component of control unit
	-- here
	component ControlUnit is
	port(
	    CLK : in std_logic;
		reset : in std_logic;
		Op : in std_logic_vector(5 downto 0);
		
		-- output port
		RegDst : out std_logic; 
		RegWrite : out std_logic;
		ALUSrcA : out std_logic;
		MemRead : out std_logic;
		MemWrite : out std_logic;
		MemtoReg :out std_logic;
		IorD : out std_logic;
		IRWrite :out std_logic;
		PCWrite : out std_logic;
		PCWriteCond : out std_logic;
		
		ALUOp : out std_logic_vector(1 downto 0);
		ALUSrcB : out std_logic_vector (1 downto 0);
		PCSource : out std_logic_vector (1 downto 0)
	);
end component;

component ALUControl is
	port(
		-- input
		ALUOp : in std_logic_vector(1 downto 0);
		func : in std_logic_vector(5 downto 0);
		--Op : in std_logic_vector(5 downto 0);
		-- output
		operation : out std_logic_vector(3 downto 0)
	);
end component;
--

-- internal signal
-- here
signal IROut , PC_in , PC_out , MemAddress , WriteData ,MemData 
		,rs_data , rt_data ,writeData_reg , Aout , Bout ,MDR_Out 
		,ALU_res ,ALU_out : std_logic_vector(31 downto 0);
signal IRWrite , PCWriteCond , PCWrite 
		, IorD , MemtoReg , MemWrite , MemRead 
		, ALUSrcA , RegWrite , RegDst ,PC_control : std_logic;
signal ALUSrcB , PCSource ,ALUOp : std_logic_vector(1 downto 0);
signal operation : std_logic_vector(3 downto 0);
signal rs_reg , rt_reg , rd_reg : std_logic_vector(4 downto 0);
	
--
begin
-- port map of register
-- here
pc_u : PC_reg port map (CLK => CLK,
                        reset => reset, PC_in => PC_in , PC_out => PC_out
                        ,PC_write => PC_control
						);
						
memory_u : Memory port map (
        clk        => clk,
        address    => MemAddress,
        data_in    => WriteData,
        mem_write  => MemWrite,
        mem_read   => MemRead,
        data_out   => MemData
    );

ir_u : IR_reg port map (
        clk        => CLK,
        reset      => reset,
        enable     => IRWrite,
        IR_in      => MemData,
        Op_code    => IROut(31 downto 26),
        rs         => IROut(25 downto 21),
        rt         => IROut(20 downto 16),
        immediate  => IROut(15 downto 0)
    );	

regfile_u : Reg_File port map (
        clk         => CLK,
        reset       => reset,
        reg_write   => RegWrite,
        read_reg1   => rs_reg,
        read_reg2   => rt_reg,
        write_reg   => rd_reg,
        write_data  => writeData_reg,
        read_data1  => rs_data,
        read_data2  => rt_data
    );

ab_u : A_B_reg port map (
        clk   => CLK,
        AIn   => rs_data,
        BIn   => rt_data,
        AOut  => Aout,
        BOut  => Bout
    );

mdr_u : MDR_reg port map (
        clk      => CLK,
        reg_in   => MemData,
        reg_out  => MDR_Out
    );

aluout_u : ALUOut_reg port map (
        clk      => CLK,
        reg_in   => ALU_res,
        reg_out  => ALU_out
    );	
--

-- port map of dataflow
	-- here
--

-- port map of control unit
-- here
CTRL : ControlUnit port map (CLK => CLK , reset => reset , Op => IROut(31 downto 26) 
							,IRWrite => IRWrite , PCWriteCond => PCWriteCond , PCWrite => PCWrite
							,IorD => IorD , MemtoReg => MemtoReg , MemWrite => MemWrite , MemRead => MemRead
							,ALUSrcA => ALUSrcA , RegWrite => RegWrite , RegDst => RegDst , ALUSrcB => ALUSrcB
							,PCSource => PCSource , ALUOp => ALUOp);

ALUCTRL : ALUControl port map( ALUOp => AlUOp,func => IROut(5 downto 0) , operation => operation);						
--	
end behavior;
	