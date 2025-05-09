library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity connection is
	port (
	clk : in std_logic;
	reset : in std_logic
	);
end connection;

architecture behavior of connection is
	component ControlUnit is 
  port(
  -- input port
  CLK : in std_logic;
  reset : in std_logic;
  Op : in std_logic_vector(5 downto 0);
  
  -- output port
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

-- internal signal
signal IROut ,pc_out ,memory_data ,reg_data1 ,reg_data2 ,alu_result ,A ,B ,mdr_out ,Mux1_Out , Mux_MDR_Out ,
SE_Out ,shift1_Out ,Alu_in1 ,Alu_in2 ,Alu_Result_Out ,JumpAddress ,Mux3_Out: std_logic_vector(31 downto 0);
	signal IRWrite , PCWriteCond , PCWrite 
	, IorD , MemtoReg , MemWrite , MemRead 
	, ALUSrcA , RegWrite , RegDst ,zero,ir_write,PcControlOut: std_logic;
	signal ALUSrcB , PCSource ,AlUOp: std_logic_vector(1 downto 0);
    signal ir_opcode     : std_logic_vector(5 downto 0);
    signal ir_rs , ir_rt ,Mux_Ins_Out : std_logic_vector(4 downto 0);
    signal ir_imm        : std_logic_vector(15 downto 0);
	constant Mux4_PC_incr : std_logic_vector(31 downto 0) := "00000000000000000000000000000100"; --4
	constant n1:integer:=32;
	constant n2:integer:=5;
	signal operation:std_logic_vector(3 downto 0);
	signal shift_connect:std_logic_vector(25 downto 0);
	
begin  
	PcControlOut <= (zero and PCWriteCond) or PCWrite; 
	JumpAddress(31 downto 28) <= pc_out(31 downto 28);
	shift_connect<=ir_rs & ir_rt &ir_imm;
	
CTRL : ControlUnit port map (CLK => CLK , reset => reset , Op =>ir_opcode 
							,IRWrite => IRWrite , PCWriteCond => PCWriteCond , PCWrite => PCWrite
							,IorD => IorD , MemtoReg => MemtoReg , MemWrite => MemWrite , MemRead => MemRead
							,ALUSrcA => ALUSrcA , RegWrite => RegWrite , RegDst => RegDst , ALUSrcB => ALUSrcB
							,PCSource => PCSource , ALUOp => ALUOp);
ALUCTRL : ALUControl port map( ALUOp => AlUOp,func => ir_imm(5 downto 0) , operation => operation);

 pc_u : pc_reg port map (
        clk      => clk,
        reset    => reset,
        pc_write => PcControlOut,
        pc_in    => Mux3_Out,
        pc_out   => pc_out
    );

    memory_u : Memory port map (
        clk        => clk,
        address    => Mux1_Out,
        data_in    => B,
        mem_write  => MemWrite,
        mem_read   => MemRead,
        data_out   => memory_data
    );

    ir_u : IR_reg port map (
        clk        => clk,
        reset      => reset,
        enable     => IRWrite,
        IR_in      => memory_data,
        Op_code    => ir_opcode,
        rs         => ir_rs,
        rt         => ir_rt,
        immediate  => ir_imm
    );

    regfile_u : Reg_File port map (
        clk         => clk,
        reset       => reset,
        reg_write   => RegWrite,
        read_reg1   => ir_rs,
        read_reg2   => ir_rt,
        write_reg   => Mux_Ins_Out,
        write_data  => Mux_MDR_Out,
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
        reg_in   => Alu_Result_Out,
        reg_out  => alu_result
    );
	
	Mux1: Mux2To1 
	generic map(n=>n1)
	port map(
	in0=>pc_out,
	in1=>alu_result,
	selector=>IorD,
	output=>Mux1_Out
	);
	
	Mux_Ins:Mux2To1 
	generic map(n=>n2)
	port map(
	in0=>ir_rt,
	in1=>ir_imm(15 downto 11),
	selector=>RegDst,
	output=>Mux_Ins_Out
	); 
	
	Mux_MDR:Mux2To1 
	generic map(n=>n1)
	port map(
	in0=>alu_result,
	in1=>mdr_out,
	selector=>MemtoReg,
	output=>Mux_MDR_Out
	); 
	
	Mux_A:Mux2To1 
	generic map(n=>n1)
	port map(
	in0=>pc_out,
	in1=>A,
	selector=>ALUSrcA,
	output=>Alu_in1
	);
	
	sign_Extend:SignExtend port map(  
	i=>ir_imm,
	o=>SE_Out
	);
	
	shiftLeft1_port:ShiftLeft1 port map(	
	i=>SE_Out,
	o=>shift1_Out
	); 
	
    Mux_B:Mux4To1_32 port map(
	in0=>B,
	in1=>Mux4_PC_incr,
	in2=>SE_Out,
	in3=>shift1_Out,
	selector=>ALUSrcB,
	output=>Alu_in2
	);
	
	shiftLeft2_port:ShiftLeft2 port map(	
	i=> shift_connect,
	o=>JumpAddress(27 downto 0)
	); 
	
	Alu_Port:ALU port map(
	operand1=>Alu_in1,
	operand2=>Alu_in2,
	Alu_Control=> operation,
	Alu_Result=>Alu_Result_Out,
	zero=>zero
	); 
	
	Mux3to1:Mux3To1_32 port map(
	in0=>Alu_Result_Out,
	in1=>alu_result,
    in2=>JumpAddress, 
	selector=> PCSource,
	output=>Mux3_Out
	);
	
end behavior;
	