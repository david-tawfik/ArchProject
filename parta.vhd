LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY parta IS
	GENERIC (n : INTEGER := 16);
	PORT (
		A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		cin : IN STD_LOGIC;
		sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		cout : OUT STD_LOGIC);
END parta;

ARCHITECTURE parta_arch OF parta IS

	COMPONENT adder IS
		GENERIC (n : INTEGER := 16);
		PORT (
			A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			cin : IN STD_LOGIC;
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			cout : OUT STD_LOGIC);
	END COMPONENT adder;
	SIGNAL x, y, z, temp, temp2 : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
	SIGNAL c : STD_LOGIC;
BEGIN

	y <= NOT B WHEN sel = "0001" OR (sel = "0010" AND cin = '0')
		ELSE
		B WHEN (sel = "0010" AND cin = '1') OR (sel = "0011" AND cin = '1')
		ELSE
		(OTHERS => '1') WHEN sel = "0011" AND cin = '0'
		ELSE
		(OTHERS => '0');

	x <= (OTHERS => '0') WHEN sel = "0011" AND cin = '1'
		ELSE
		A;

	z <= (OTHERS => '0') WHEN sel = "0000" AND cin = '0'
		ELSE
		(0 => '1', OTHERS => '0') WHEN (sel = "0000" AND cin = '1') OR (sel = "0001" AND cin = '0') OR (sel = "0010" AND cin = '1') OR (sel = "0011" AND cin = '1')
		ELSE
		(1 => '1', OTHERS => '0') WHEN sel = "0010" AND cin = '0'
		ELSE
		(OTHERS => '0');

	f0 : adder GENERIC MAP(n) PORT MAP(x, y, '0', temp, c);
	f1 : adder GENERIC MAP(n) PORT MAP(temp, z, '0', F, cout);


END parta_arch;