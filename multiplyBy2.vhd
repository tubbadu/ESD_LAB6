library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplyBy2 is
	port(
		n        : in signed(10 downto 0);
		double_n : out signed(10 downto 0)
	);
end entity;

architecture behavior of multiplyBy2 is
begin
	-- the first bit after the sign is removed
	-- all other bits are shifted left by one position
	-- at last position a 0 is added
	
	double_n <= n(10) & n(8 downto 0) & '0';
end architecture;