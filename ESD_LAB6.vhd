library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ESD_LAB6 is
	port(
		data_in    : in signed (7 downto 0);
		TipWarning : buffer std_logic;
		start      : in std_logic;
		done       : out std_logic;
		CLK        : in std_logic;
		reset      : in std_logic
	);

end entity;

architecture behavior of ESD_LAB6 is
	component datapath is
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
			F_ZC       : out std_logic;

			-- Data I/O
			data_in    : in signed (7 downto 0);
			data_out   : out signed (7 downto 0);
			TipWarning : out std_logic
			
		);
	end component;

	component ControlUnit is
		port(
			-- Clock
			clk : in std_logic;

			-- Controls
			reset     : in std_logic;

			reg_a_en  : out std_logic;
			mux1_s    : out std_logic_vector (1 downto 0);
			mux2_s    : out std_logic;
			mux3_s    : out std_logic_vector(1 downto 0);
			mem_a_cs, mem_a_re, mem_a_wr : out std_logic;
			mem_b_cs, mem_b_re, mem_b_wr : out std_logic;
			CU_Cin    : out std_logic;
			counter_enable, counter_restart : out std_logic;
			enable_tw : out std_logic;
			
			-- Flags
			F_OverFlow   : in std_logic;
			F_UnderFlow  : in std_logic;
			F_tipwarning : in std_logic;
			F_TC         : in std_logic;
			F_ZC         : in std_logic;

			start        : in std_logic;
			done         : out std_logic
			
		);
	end component;
	
	
	signal F_OverFlow, F_UnderFlow, F_TC, F_ZC : std_logic;
	signal reg_a_en  : std_logic;
	signal mux1_s    : std_logic_vector (1 downto 0);
	signal mux2_s    : std_logic;
	signal mux3_s    : std_logic_vector(1 downto 0);
	signal mem_a_cs, mem_a_re, mem_a_wr : std_logic;
	signal mem_b_cs, mem_b_re, mem_b_wr : std_logic;
	signal CU_Cin    : std_logic;
	signal counter_enable, counter_restart : std_logic;
	signal enable_tw : std_logic;

			
	begin
	
	DP: datapath port map(
			-- Clock
			clk => CLK,

			-- Controls
			reset 			 => reset,
			reg_a_en 		 => reg_a_en,
			mux1_s 			 => mux1_s,
			mux2_s 			 => mux2_s,
			mux3_s 			 => mux3_s,
			mem_a_cs		 	 => mem_a_cs,
			mem_a_re 		 => mem_a_re,
			mem_a_wr 		 => mem_a_wr,
			mem_b_cs 		 => mem_b_cs,
			mem_b_re 		 => mem_b_re,
			mem_b_wr 		 => mem_b_wr,
			CU_Cin 			 => CU_Cin,
			counter_enable  => counter_enable,
			counter_restart => counter_restart,
			enable_tw       => enable_tw,

			-- Flags
			F_OverFlow  => F_OverFlow,
			F_UnderFlow => F_UnderFlow,
			F_TC        => F_TC,
			F_ZC        => F_ZC,

			-- Data I/O
			data_in    => data_in,
			data_out   => open,
			TipWarning => TipWarning
			
		);
	
	
	CU: ControlUnit port map(
			-- Clock
			clk => CLK,

			-- Controls
			reset    		 => reset,
			reg_a_en 		 => reg_a_en,
			mux1_s   		 => mux1_s,
			mux2_s   		 => mux2_s, 
			mux3_s   		 => mux3_s,
			mem_a_cs        => mem_a_cs,
			mem_a_re        => mem_a_re, 
			mem_a_wr        => mem_a_wr,
			mem_b_cs        => mem_b_cs,
			mem_b_re        => mem_b_re, 
			mem_b_wr        => mem_b_wr,
			CU_Cin          => CU_Cin,
			counter_enable  => counter_enable,
			counter_restart => counter_restart,
			enable_tw       => enable_tw,
			
			-- Flags
			F_OverFlow   => F_OverFlow,
			F_UnderFlow  => F_UnderFlow,
			F_tipwarning => TipWarning,
			F_TC         => F_TC,
			F_ZC         => F_ZC,

			start => start,
			done  => done
	);

end architecture;

