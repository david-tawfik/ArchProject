LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partb IS
	GENERIC (n : INTEGER := 16);
	PORT (
		A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		cout : OUT STD_LOGIC);
END partb;

ARCHITECTURE partb_arch OF partb IS
BEGIN
	cout <= '0';
	F <= (A OR B) WHEN sel = "0100"
		ELSE
		(A AND B) WHEN sel = "0101"
		ELSE
		(A NOR B) WHEN sel = "0110"
		ELSE
		(NOT A) WHEN sel = "0111"
		ELSE
		(OTHERS => '0');
END partb_arch;