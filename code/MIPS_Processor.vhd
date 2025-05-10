-- Project: MIPS32 multi-cycle
-- Module:  MIPS_Processor
library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Processor is
	port (
		CLK : in std_logic;
		reset : in std_logic
		
	);
end MIPS_Processor;

architecture behavior of MIPS_Processor is
-- component of register
	
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
	
	component Mux2To1 is 
		generic(
	       n:integer:=32
	    );
		port(
			in0:in std_logic_vector(n-1 downto 0); 
			in1:in std_logic_vector(n-1 downto 0);
			selector: in std_logic;output:out std_logic_vector(n-1 downto 0)
		);
	end component;
	
	component SignExtend is
		port(
			i:in std_logic_vector(15 downto 0);
			o:out  std_logic_vector(31 downto 0)
		);
	end component; 
	
	component ShiftLeft1 is
		port(
			i:in std_logic_vector(31 downto 0);
			o:out  std_logic_vector(31 downto 0)
		);
	end component;
	
	component Mux4To1_32 is
		port(
			in0:in std_logic_vector(31 downto 0); 
			in1:in std_logic_vector(31 downto 0); 
		    in2:in std_logic_vector(31 downto 0); 
			in3:in std_logic_vector(31 downto 0);
			selector: in std_logic_vector(1 downto 0);
			output:out std_logic_vector(31 downto 0)
		);
	end component;
	
	component ShiftLeft2 is
		port(
			i:in std_logic_vector(25 downto 0);
			o:out  std_logic_vector(27 downto 0)
		);
	end component;
	
	component ALU is
    port(
        operand1    : in  std_logic_vector(31 downto 0);
        operand2    : in  std_logic_vector(31 downto 0);
        Alu_Control : in  std_logic_vector(3 downto 0);
        Alu_Result  : out std_logic_vector(31 downto 0);
        zero        : out std_logic
		); 
	end component;
	
	component Mux3To1_32 is
		port(
			in0:in std_logic_vector(31 downto 0); 
			in1:in std_logic_vector(31 downto 0); 
		    in2:in std_logic_vector(31 downto 0); 
			selector: in std_logic_vector(1 downto 0);
			output:out std_logic_vector(31 downto 0)
		);
	end component;
--

-- component of control unit
	component ControlTop is
		 port(
			CLK : in std_logic;
			reset : in std_logic;
			func : in std_logic_vector(5 downto 0);
			Op : in std_logic_vector(5 downto 0);
			
			operation : out std_logic_vector(3 downto 0);
			RegDst : out std_logic; -- two modes assert & deassert
			RegWrite : out std_logic;
			ALUSrcA : out std_logic;
			MemRead : out std_logic;
			MemWrite : out std_logic;
			MemtoReg :out std_logic;
			IorD : out std_logic;
			IRWrite :out std_logic;
			PCWrite : out std_logic;
			PCWriteCond : out std_logic;
			
			
			ALUSrcB : out std_logic_vector (1 downto 0);
			PCSource : out std_logic_vector (1 downto 0)
			);
	end component;
--

-- internal signal & constant
	signal IROut , PC_in , PC_out , MemAddress ,MemData 
		,rs_data , rt_data ,writeData_reg , Aout , Bout ,MDR_Out 
		,ALU_res ,ALU_out, Alu_in1 ,Alu_in2 ,SE_Out , shift1_Out ,JumpAddress : std_logic_vector(31 downto 0);
	signal IRWrite , PCWriteCond , PCWrite 
	, IorD , MemtoReg , MemWrite , MemRead 
	, ALUSrcA , RegWrite , RegDst ,PC_control ,zero_flag : std_logic;
	signal ALUSrcB , PCSource  : std_logic_vector(1 downto 0);
	signal operation : std_logic_vector(3 downto 0);
	signal  rd_reg : std_logic_vector(4 downto 0);
	
	constant n1 : integer := 32;
	constant n2 : integer := 5;
	constant Mux4_PC_incr : std_logic_vector(31 downto 0) := "00000000000000000000000000000100"; --4
	
--
begin
	JumpAddress(31 downto 28) <= PC_out(31 downto 28);
	PC_control <= (zero_flag and PCWriteCond) or PCWrite;
	
-- port map of register
pc_u : PC_reg port map (CLK => CLK,
                        reset => reset, PC_in => PC_in , PC_out => PC_out
                        ,PC_write => PC_control
						);
						
memory_u : Memory port map (
        clk        => clk,
        address    => MemAddress,
        data_in    => ALU_out,
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
        read_reg1   => IROut(25 downto 21),
        read_reg2   => IROut(20 downto 16),
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
MuxMem : Mux2To1 
	generic map(n => n1)
	port map(
		in0 => PC_out,
		in1 => ALU_out,
		selector => IorD,
		output => MemAddress
	);
MUXRegDst : Mux2To1 
	generic map(n => n2)
	port map(
		in0 => IROut(20 downto 16),
		in1 => IROut(15 downto 11),
		selector => RegDst,
		output => rd_reg
	);
Mux_MDR : Mux2To1 
	generic map(n => n1)
	port map(
		in0 => ALU_out,
		in1 => MDR_Out,
		selector => MemtoReg,
		output => writeData_reg
	);
	
Mux_A : Mux2To1 
	generic map(n => n1)
	port map(
	in0 => PC_out,
	in1 => AOut,
	selector => ALUSrcA,
	output => Alu_in1
	);
Mux_B : Mux4To1_32 port map(
					in0 => BOut,
					in1 => Mux4_PC_incr,
					in2 => SE_Out,
					in3 => shift1_Out,
					selector => ALUSrcB,
					output => Alu_in2
				    );
shiftLeft2_port : ShiftLeft2 port map(	
				i => IROut(25 downto 0),
				o => JumpAddress(27 downto 0)
				);
Alu_Port : ALU port map(
	operand1 => Alu_in1,
	operand2 => Alu_in2,
	Alu_Control => operation,
	Alu_Result => ALU_res,
	zero => zero_flag
	);
Mux3to1 : Mux3To1_32 port map(
				in0 => Alu_Out,
				in1 => ALU_res,
			    in2 => JumpAddress, 
				selector => PCSource,
				output => PC_in
				);
sign_Extend : SignExtend port map(  
	i=>IROut(15 downto 0),
	o=>SE_Out
	);
	
	shiftLeft_SE : ShiftLeft1 port map(	
	i=>SE_Out,
	o=>shift1_Out
	);				
	
--

-- port map of control unit
CTRL : ControlTop port map(CLK => CLK , reset => reset , Op => IROut(31 downto 26) , func => IROut(5 downto 0) 
							,IRWrite => IRWrite , PCWriteCond => PCWriteCond , PCWrite => PCWrite
							,IorD => IorD , MemtoReg => MemtoReg , MemWrite => MemWrite , MemRead => MemRead
							,ALUSrcA => ALUSrcA , RegWrite => RegWrite , RegDst => RegDst , ALUSrcB => ALUSrcB
							,PCSource => PCSource , operation => operation);
--

end behavior;
	