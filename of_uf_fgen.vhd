library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity of_uf_fgen is
	port(
		input_word11 : in  signed(10 downto 0);
		F_OverFlow   : out std_logic;
		F_UnderFlow  : out std_logic
	);
end entity;

architecture behavior of of_uf_fgen is

begin

	-- this will generate the flags of over and under flow for the CU
	-- the CU will then use them to determine the correct output

	F_OverFlow  <=  (not input_word11(10)) and (      input_word11(9) or input_word11(8) );
	F_UnderFlow <=  (input_word11(10))     and ( not (input_word11(9) and input_word11(8)));

end architecture;