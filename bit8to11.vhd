library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit8to11 is
	port(
		input_word8   : in  signed(7 downto 0);
		output_word11 : out signed(10 downto 0)
	);
end entity;

architecture behavior of bit8to11 is
begin
	-- this will translate the 8 bit integer to a 11 bit fixed point number with one decimal digit

	-- if the first bit is 0, the number is positive: should be added "00" at the beginning
	-- if the first bit is 1, the number is negative: should be added "11" at the beginning

	-- '0' should also be added at the end (both for positive and negative)
	output_word11 <= input_word8(7) & input_word8(7) & input_word8 & '0';
end architecture;