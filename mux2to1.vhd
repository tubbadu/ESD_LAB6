library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 is
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
end entity;

architecture behavior of mux2to1 is
begin
	m <= x when (s = '0') else y;
end behavior;