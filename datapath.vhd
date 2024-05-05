library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port(
		-- Clock
		clk : in std_logic;

		-- Controls
		reset     : in std_logic;
		reg_a_en  : in std_logic;
		mux1_s    : in std_logic_vector (1 downto 0);
		mux2_s    : in std_logic;
		mux3_s    : in std_logic_vector(1 downto 0);
		mem_a_cs, mem_a_re, mem_a_wr : in std_logic;
		mem_b_cs, mem_b_re, mem_b_wr : in std_logic;
		CU_Cin    : in std_logic;
		counter_enable, counter_restart: in std_logic;
		enable_tw : in std_logic;

		-- Flags
		F_OverFlow  : out std_logic;
		F_UnderFlow : out std_logic;
		F_TC: out std_logic;

		-- Data I/O
		data_in    : in signed (7 downto 0);
		data_out   : out signed (7 downto 0);
		TipWarning : out std_logic;
		F_ZC       : out std_logic
	);
end entity;

architecture behavior of datapath is
	component adder is
		port(	
			Cin : in std_logic;
			x   : in signed(10 downto 0);
			a   : in signed(10 downto 0);
			m   : out signed(10 downto 0)
		);
	end component;

	component bit8to11 is
		port(
			input_word8   : in  signed(7 downto 0);
			output_word11 : out signed(10 downto 0)
		);
	end component;

	component bit11to8 is
		port(
			input_word11 : in  signed(10 downto 0);
			output_word8 : out signed(7 downto 0)
		);
	end component;

	component of_uf_fgen is
		port(
			input_word11 : in  signed(10 downto 0);
			F_OverFlow   : out std_logic;
			F_UnderFlow  : out std_logic
		);
	end component;

	component countern IS
		generic (N: integer := 10);
		port (
			clk, restartCounter, reset, enable : in std_logic;
			count : out unsigned (N-1 downto 0);
			TC, ZC    : out std_logic
		);
	end component;

	component divideByMinus4 is
		port(
			n           : in signed(10 downto 0);
			onefourth_n : out signed(10 downto 0)
		);
	end component;

	component multiplyBy2 is
		port(
			n		   : in  signed(10 downto 0);
			double_n : out signed(10 downto 0)
		);
	end component;

	component mux2to1 is
		generic(
			i_sup : integer := 8;
			i_low : integer := 0
		);
		port(	
			x : in signed(i_sup downto i_low);
			y : in signed(i_sup downto i_low);
			s : in std_logic;
			m : out signed(i_sup downto i_low)
		);
	end component;

	component mux4to1 is
		generic(
			i_sup : integer := 8;
			i_low : integer := 0
		);
		port(	
			u : in signed (i_sup downto i_low);
			v : in signed(i_sup downto i_low);
			w : in signed(i_sup downto i_low);
			x : in signed(i_sup downto i_low);
			s : in std_logic_vector(1 downto i_low);
			m : out signed(i_sup downto i_low)
		);
	end component;

	component reg_11b IS
		port (
			R : in signed(10 downto 0);
			Clock, Resetn : in std_logic;
			Q : out signed(10 downto 0)
		);
	end component;

	component memory is
		generic(
			N        : integer := 8; -- number of bits of each cell
			CELLS    : integer := 8; -- number of cells
			filename : string:="mem"
		);
		port(	
			d_in  : in signed (N-1 downto 0);
			d_out : out signed (N-1 downto 0);
			addr  : in unsigned(CELLS-1 downto 0);
			clk, CS, WR, RD : std_logic
		);
	end component;
	
	component tipwarning_detector is
		port( 
			D_out      : in signed(7 downto 0);
			TIPWARNING : out std_logic;
			enable_tw  : in std_logic
		);
	end component;

	
	constant VCS_noerror : signed(10 downto 0) := "00000000000";	-- 0
	constant VCS_error   : signed(10 downto 0) := "11101000110";	-- -93 in complemento a 2
	constant sat_up      : signed (7 DOWNTO 0) := "01111111";		-- 0x7F
	constant sat_down    : signed (7 DOWNTO 0) := "10000000";		-- 0x80

	signal E_11bit, E_divided_by_4, E_doubled : signed(10 downto 0);
	signal mux1_m, mux2_m : signed(10 downto 0);
	signal VC_acc  : signed(10 downto 0);
	signal VC_8bit : signed(7 downto 0);
	signal result  : signed (7 downto 0);
	signal addr    : unsigned (9 downto 0);
	signal VC      : signed(10 downto 0);
	signal E       : signed(7 downto 0);
	
begin
	addr_count: countern generic map(N => 10)
		port map(
			clk            => clk,
			restartCounter => counter_restart,
			reset          => reset,
			enable         => counter_enable,
			count          => addr,
			TC             => F_TC,
			ZC             => F_ZC
		);
		
	converter_8to11bit: bit8to11 port map(
		input_word8   => E,
		output_word11 => E_11bit
	);
	
	tipwarning_comp: tipwarning_detector port map(
		D_out      => E,
		TIPWARNING => TipWarning,
		enable_tw  => enable_tw
	);

	divider: divideByMinus4 port map(
		n           => E_11bit,
		onefourth_n => E_divided_by_4
	);

	multiplier: multiplyBy2 port map(
		n        => E_11bit,
		double_n => E_doubled
	);

	mux1: mux4to1 generic map(
			i_sup => 10,
			i_low => 0
		) port map(
			u => E_doubled,
			v => E_divided_by_4,
			w => VCS_error,
			x => VCS_noerror,
			s => mux1_s,
			m => mux1_m
		);
	
	mux2: mux2to1 generic map(
			i_sup => 10,
			i_low => 0
		) port map(
				x => VC_acc,
				y => E_doubled,
				s => mux2_s,
				m => mux2_m
		);

	Add: adder port map(
			Cin => CU_Cin,
			x => mux1_m,
			a => mux2_m,
			m => VC
		);

	reg_A: reg_11b port map(
			-- qualcosa => regA_EN
			R      => VC,
			Clock  => clk,
			resetn => reset,
			Q      => VC_acc
		);

	converter_11to8bit: bit11to8 port map(
			input_word11 => VC_acc,
			output_word8 => VC_8bit	
		);

	of_uf_flags_generator: of_uf_fgen port map(
			input_word11 => VC,
			F_OverFlow   => F_OverFlow,
			F_UnderFlow  => F_UnderFlow
		);

	mux3: mux4to1  generic map(
			i_sup => 7,
			i_low => 0
		) port map(
			u => VC_8bit,
			v => sat_up,
			w => sat_down,
			x => "00000000", -- should not be used
			s => mux3_s,
			m => result
		);
	
	mem_A: memory 
		generic map(
			N        => 8,
			CELLS    => 10,
			filename => "bit_simulation_memA"
		) port map (
			d_in  => data_in,
			d_out => E,
			addr  => addr,
			clk   => clk,
			CS    => mem_a_cs,
			wr    => mem_a_wr,
			rd    => mem_a_re
		);

	mem_B: memory
		generic map(
			N        => 8,
			CELLS    => 10,
			filename =>"bit_simulation_memB"
		) 
		port map (
			d_in  => result,
			d_out => data_out,
			addr  => addr,
			clk   => clk,
			CS    => mem_b_cs,
			wr    => mem_b_wr,
			rd    => mem_b_re
		);

end behavior;