library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4to1 is
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
end entity;

architecture behavior of mux4to1 is
	signal uv : signed(i_sup downto i_low);
	signal wx : signed(i_sup downto i_low);
begin	
	m <= uv when (s(1) = '0') else wx;

	uv <= u when (s(0) = '0') else v;
	
	wx <= w when (s(0) = '0') else x;
end behavior;