library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use ieee.std_logic_textio.all;
use STD.textio.all;


entity tb_lab6 is
end entity;

architecture Behavior of tb_lab6 is

	component ESD_LAB6 is
		port(
			data_in : in signed (7 downto 0);
			TipWarning : buffer std_logic;
			start : in std_logic;
			done : out std_logic;
			CLK : in std_logic;
			reset : in std_logic
		);
	end component;

	signal data_in :  signed (7 downto 0);
	signal TipWarning :  std_logic;
	signal start :  std_logic;
	signal done :  std_logic;
	signal CLK :  std_logic;
	signal reset :  std_logic;

	file ifile : text;

begin

	test: ESD_LAB6 port map(data_in, TipWarning, start, done, CLK, reset);

	process -- T=10ns
	begin
		clk <= '0';
		wait for 2.63157 ns;
		clk <= '1';
		wait for 2.63157 ns;
	end process;
	
	
	process
		variable iline: line;
		variable rd: signed (7 downto 0);
	begin
		start <= '0';
		reset <= '0';
		wait for 5 ns;
		reset <= '1';
		wait for 5 ns;
		start <= '1';

		--repeat 1024 times
		file_open(ifile, "bit_input.txt",  read_mode);
		while not endfile(ifile) loop
			wait until rising_edge(clk);
			readline(ifile, iline);
			read(iline, rd);
			data_in <= rd;
		end loop;
		file_close(ifile);
		wait for 30 us;
		--start <= '0';
		start <= '0';
		wait;     
	end process;


END Behavior;