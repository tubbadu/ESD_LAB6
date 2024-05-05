library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
	port(	
		Cinb  : in  std_logic;
		xb    : in  std_logic;
		ab    : in  std_logic;
		mb    : out std_logic;
		coutb : out std_logic
	);
end entity;

architecture behavior of full_adder is
	signal p : std_logic;
	signal g : std_logic;
begin
	mb <= (xb xor ab) xor cinb;
	coutb <= (xb and ab) or ((xb xor ab) and cinb);
end behavior;

--------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder2b is
	port(	
		Cin2b  : in  std_logic;
		x2b    : in  std_logic_vector(1 downto 0);
		a2b    : in  std_logic_vector(1 downto 0);
		m2b    : out std_logic_vector(1 downto 0);
		cout2b : out std_logic
	);
end entity;

architecture behavior of adder2b is
	component full_adder is
		port(	
			Cinb  : in  std_logic;
			xb    : in  std_logic;
			ab    : in  std_logic;
			mb    : out std_logic;
			coutb : out std_logic
		);
	end component;

	signal carry_int : std_logic;

begin
	a0 : full_adder port map(cin2b,x2b(0),a2b(0),m2b(0),carry_int);
	a1 : full_adder port map(carry_int,x2b(1),a2b(1),m2b(1),cout2b);

end behavior;

--------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4b is
	port(	
		Cin4b : in  std_logic;
		x4b   : in  std_logic_vector(3 downto 0);
		a4b   : in  std_logic_vector(3 downto 0);
		m4b   : out std_logic_vector(3 downto 0);
		cout4b: out std_logic
	);
end entity;

architecture behavior of adder4b is
	component adder2b is
		port(	
			Cin2b : in  std_logic;
			x2b   : in  std_logic_vector(1 downto 0);
			a2b   : in  std_logic_vector(1 downto 0);
			m2b   : out std_logic_vector(1 downto 0);
			cout2b : out std_logic
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


	signal carry_int : std_logic;
	signal carry_out_0 : std_logic;
	signal carry_out_1 : std_logic;
	signal sum_int_c0: std_logic_vector(3 downto 2);
	signal sum_int_c1: std_logic_vector(3 downto 2);

begin
	a0 : adder2b port map(cin4b,x4b(1 downto 0),a4b(1 downto 0),m4b(1 downto 0),carry_int);

	mux_ris : mux2to1 generic map(
			i_sup => 3,
			i_low => 2
		) port map(
			x => signed(sum_int_c0),
			y => signed(sum_int_c1),
			s => carry_int,
			std_logic_vector(m) => m4b(3 downto 2)
		);

	mux_cout : mux2to1 generic map(
			i_sup => 0,
			i_low => 0
		) port map(
			x(0) => carry_out_0,
			y(0) => carry_out_1,
			s => carry_int,
			m(0) => cout4b
		);

	a1c0 : adder2b port map('0',x4b(3 downto 2),a4b(3 downto 2),sum_int_c0,carry_out_0);
	a1c1 : adder2b port map('1',x4b(3 downto 2),a4b(3 downto 2),sum_int_c1,carry_out_1);
	
end behavior;

--------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder8b is
	port(	
		Cin8b  : in  std_logic;
		x8b    : in  std_logic_vector(7 downto 0);
		a8b    : in  std_logic_vector(7 downto 0);
		m8b    : out std_logic_vector(7 downto 0);
		cout8b : out std_logic
	);
end entity;

architecture behavior of adder8b is
	component adder4b is
		port(	
			Cin4b : in  std_logic;
			x4b   : in  std_logic_vector(3 downto 0);
			a4b   : in  std_logic_vector(3 downto 0);
			m4b   : out std_logic_vector(3 downto 0);
			cout4b: out std_logic
		); 
	end component;

	component mux2to1 is
		generic(
			i_sup : integer := 8;
			i_low : integer := 0
		);
		port (	
			x : in signed(i_sup downto i_low);
			y : in signed(i_sup downto i_low);
			s : in std_logic;
			m : out signed(i_sup downto i_low)
		);
	end component;


	signal carry_int   : std_logic;
	signal carry_out_0 : std_logic;
	signal carry_out_1 : std_logic;
	signal sum_int_c0  : std_logic_vector(7 downto 4);
	signal sum_int_c1  : std_logic_vector(7 downto 4);

	begin
		a03    : adder4b port map(cin8b, x8b(3 downto 0), a8b(3 downto 0),m4b => m8b(3 downto 0),cout4b => carry_int);
		a47_c0 : adder4b port map('0', x8b(7 downto 4), a8b(7 downto 4),m4b => sum_int_c0,cout4b => carry_out_0);
		a47_c1 : adder4b port map('1', x8b(7 downto 4), a8b(7 downto 4),m4b => sum_int_c1,cout4b => carry_out_1);

		mux_ris : mux2to1 generic map(
				i_sup => 7,
				i_low => 4
			) port map(
				x => signed(sum_int_c0),
				y => signed(sum_int_c1),
				s => carry_int,
				std_logic_vector(m) => m8b(7 downto 4)
			);

		mux_cout : mux2to1 generic map(
				i_sup => 0,
				i_low => 0
			) port map(
				x(0) => carry_out_0,
				y(0) => carry_out_1,
				s => carry_int,
				m(0) => cout8b
			);

end behavior;

--------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder16b is
	port(	
		Cin16b  : in  std_logic;
		x16b    : in  std_logic_vector(15 downto 0);
		a16b    : in  std_logic_vector(15 downto 0);
		m16b    : out std_logic_vector(15 downto 0);
		cout16b : out std_logic
	);
end entity;

architecture behavior of adder16b is
	component adder8b is
	port(	
		Cin8b  : in  std_logic;
		x8b    : in  std_logic_vector(7 downto 0);
		a8b    : in  std_logic_vector(7 downto 0);
		m8b    : out std_logic_vector(7 downto 0);
		cout8b : out std_logic
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


	signal carry_int   : std_logic;
	signal carry_out_0 : std_logic;
	signal carry_out_1 : std_logic;
	signal sum_int_c0  : std_logic_vector(15 downto 8);
	signal sum_int_c1  : std_logic_vector(15 downto 8);

	begin
		a07    : adder8b port map(cin16b, x16b(7 downto 0), a16b(7 downto 0),m8b => m16b(7 downto 0),cout8b => carry_int);
		a47_c0 : adder8b port map('0', x16b(15 downto 8), a16b(15 downto 8),m8b => sum_int_c0,cout8b => carry_out_0);
		a47_c1 : adder8b port map('1', x16b(15 downto 8), a16b(15 downto 8),m8b => sum_int_c1,cout8b => carry_out_1);

		mux_ris : mux2to1 generic map(
				i_sup => 15,
				i_low => 8
			) port map(
				x => signed(sum_int_c0),
				y => signed(sum_int_c1),
				s => carry_int,
				std_logic_vector(m) => m16b(15 downto 8)
			);

		mux_cout:  mux2to1 generic map(
				i_sup => 0,
				i_low => 0
			) port map(
				x(0) => carry_out_0,
				y(0) => carry_out_1,
				s => carry_int,
				m(0) => cout16b
			);

end behavior;