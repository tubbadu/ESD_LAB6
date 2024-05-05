library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divideByMinus4 is 
	port(
		n           : in signed(10 downto 0);
		onefourth_n : out signed(10 downto 0)
	);
end entity;

architecture behavior of divideByMinus4 is
begin
	-- "00" or "11" are added at the beginning according to the sign bit
	-- all other bits are shifted right by two position
	-- the last 2 bits are removed
	-- negate everything to obtain 1 complement 
	-- then 1 will be added directly in the adder to get 2 complement
	
	onefourth_n <= not(n(10) & n(10) & n(10 downto 2));
end architecture;