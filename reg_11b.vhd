library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_11b IS
	port (
		R : in signed(10 downto 0);
		Clock, Resetn : in std_logic;
		Q : out signed(10 downto 0));
end entity;

architecture Behavior of reg_11b is
begin
	process (Clock, Resetn)
	begin
		if (Resetn = '0') then
			Q <= (others => '0');
		elsif (Clock' event AND Clock = '1') then
			Q <= R;
		end if;
	end process;
end architecture;
