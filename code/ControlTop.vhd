-- Project: MIPS32 multi-cycle
-- Module:  Control Top

library ieee;
use ieee.std_logic_1164.all;


entity ControlTop is
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
end ControlTop;

architecture struct of ControlTop is
signal ALUOp_internal : std_logic_vector (1 downto 0);

begin
	U1 : entity	ControlUnit
		port map( CLK => CLK ,
		reset => reset ,
		Op => Op ,
		RegDst => RegDst,
		RegWrite => RegWrite,
		ALUSrcA => ALUSrcA,
		MemRead => MemRead,
		MemWrite => MemWrite,
		MemtoReg => MemtoReg,
		IorD => IorD,
		IRWrite => IRWrite,
		PCWrite => PCWrite,
		PCWriteCond => PCWriteCond,
		ALUOp => ALUOp_internal,
		ALUSrcB => ALUSrcB,
		PCSource => PCSource
		);
	
	U2: entity ALUControl
		port map(
		ALUOp => ALUOp_internal,
		func => func,
		Op => Op,
		operation => operation
		);
end struct;