LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partd IS
    GENERIC (n : INTEGER := 16);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : IN STD_LOGIC;
        F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cout : OUT STD_LOGIC);
END partd;

ARCHITECTURE partd_arch OF partd IS
BEGIN
    cout <= A(0) WHEN (sel = "1100" OR sel = "1101" OR sel = "1110")
        ELSE
        '0';

    F <= '0' & A(n - 1 DOWNTO 1) WHEN sel = "1100"
        ELSE
        A(0) & A(n - 1 DOWNTO 1) WHEN sel = "1101"
        ELSE
        cin & A(n - 1 DOWNTO 1) WHEN sel = "1110"
        ELSE
        A(n - 1) & A(n - 1 DOWNTO 1) WHEN sel = "1111"
        ELSE
        (OTHERS => '0');
END partd_arch;