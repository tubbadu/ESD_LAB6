library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use ieee.std_logic_textio.all;
use STD.textio.all;

entity memory is
	generic(
		N        : integer := 8;     -- number of bits of each cell
		CELLS    : integer := 8; -- number of cells
		filename : string:="mem"
	);
	port(	
		d_in  : in signed (N-1 downto 0);
		d_out : out signed (N-1 downto 0);
		addr  : in unsigned(CELLS-1 downto 0);
		clk, CS, WR, RD: in std_logic
	);
end entity;


architecture behavior of memory is
	type mem_type is array (0 to 2**(CELLS)-1) of signed (N-1 downto 0);
	signal mem: mem_type;

	 file ofile : text;


begin
	process(clk)
		 variable oline: line;
	begin
		 file_open(ofile, filename & ".txt",  append_mode);
		
		if(clk'event and clk = '1') then
			d_out <= (others => 'Z');
			if(CS = '1') then
				if(WR = '0') then
					mem(to_integer(addr)) <= d_in;
					 report "writing: " & to_string(d_in) & memory'PATH_NAME;
					 write(oline, d_in);
					 writeline(ofile, oline);
				end if;

				if(RD = '1') then
					d_out <= mem(to_integer(addr));
				end if;
			end if;
		end if;
		 file_close(ofile);
	end process;

end behavior;

-- all commented files are just for the testbench