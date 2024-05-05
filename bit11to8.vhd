library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit11to8 is
	port(
		input_word11 : in  signed(10 downto 0);
		output_word8 : out signed(7 downto 0)
	);
end entity;

architecture behavior of bit11to8 is

begin
	-- this will resize the vector, throwing away the first 2 significant digit and the last significant digit
	-- the CU will then decide if this will be the correct result, or if it has to be saturated
	
	output_word8 <= input_word11(10) & input_word11(7 downto 1);
end architecture;