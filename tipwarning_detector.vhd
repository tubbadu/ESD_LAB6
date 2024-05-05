library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tipwarning_detector is
	port(
		D_out      : in signed(7 downto 0);
		TIPWARNING : out std_logic;
		enable_tw  : in std_logic
		);
end entity;

architecture behavior of tipwarning_detector is
	signal tipw : std_logic;
begin
	tipw <= '1' when ( D_out > 100) else '0';
	TIPWARNING <= tipw AND enable_tw;
end architecture;


