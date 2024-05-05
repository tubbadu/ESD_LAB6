library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countern is
	generic (N: integer := 10);
	port (
		clk, restartCounter, reset, enable : in std_logic;
		count : buffer unsigned (N-1 downto 0);
		TC,ZC : out std_logic
	);
end entity;

architecture Behavior of countern is

	signal all_ones   : unsigned(N-1 downto 0) := (others => '1');
	signal all_zeroes : unsigned(N-1 downto 0) := (others => '0');
	begin
		TC <= '1' when (count = all_ones  ) else '0';
		ZC <= '1' when (count = all_zeroes) else '0';

		process(clk, reset)
		begin
			if (reset = '0') then
				count <= (others => '0');
			elsif (clk'event AND clk = '1') then
				if (enable = '1') then
					if (restartCounter = '1') then
						count <= (others => '0');
					else
						count <= count + 1;
					end if;
				end if;
			end if;
		end process;
end architecture;