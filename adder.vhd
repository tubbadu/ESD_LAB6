library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	port(	
		Cin : in  std_logic;
		x   : in  signed(10 downto 0);
		a   : in  signed(10 downto 0);
		m   : out signed(10 downto 0)
	);
end entity;

--il codice commentato è relativo alle prove dei diversi adder per il timing
--il risultato migliore è stato scelto per il progetto e lasciato implementato
--le entita delle prove sono raccolte nel file architectural_adders.vhd

architecture behavior of adder is
	-- component full_adder is
	-- 	port(	
	-- 		Cinb : in  std_logic;
	-- 		xb   : in  std_logic;
	-- 		ab   : in  std_logic;
	-- 		mb   : out std_logic;
	-- 		coutb: out std_logic
	-- 	);
	-- end component;

	-- component adder16b port(	
	-- 	Cin16b : in  std_logic;
	-- 	x16b   : in  std_logic_vector(15 downto 0);
	-- 	a16b   : in  std_logic_vector(15 downto 0);
	-- 	m16b   : out std_logic_vector(15 downto 0);
	-- 	cout16b: out std_logic
	-- );
	-- end component;
	--signal carry : std_logic_vector(9 downto 0);

	begin
		--a0: adder16b port map(cin, std_logic_vector("00000" & x), std_logic_vector("00000" & a),signed(m16b(10 downto 0)) => m,cout16b => open);
		
		-- a0 : full_adder port map(Cin     ,x(0),a(0),m(0),carry(0));
		-- rcAdd : for i in 0 to 8 generate
		-- 	a1 : full_adder port map(carry(i),x(i+1),a(i+1),m(i+1),carry(i+1));
		-- end generate ;
		-- a10: full_adder port map(carry(9),x(10),a(10),m(10),open);

		m <= x + a + ("0000000000" & Cin);
end behavior;

