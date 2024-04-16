LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY partc IS
    GENERIC (n : INTEGER := 16);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : IN STD_LOGIC;
        F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cout : OUT STD_LOGIC);
END partc;

ARCHITECTURE partc_arch OF partc IS
BEGIN
    cout <= A(n - 1) WHEN (sel = "1000" OR sel = "1001" OR sel = "1010")
        ELSE
        '0';

    F <= A(n - 2 DOWNTO 0) & '0' WHEN sel = "1000"
        ELSE
        A(n - 2 DOWNTO 0) & A(n - 1) WHEN sel = "1001"
        ELSE
        A(n - 2 DOWNTO 0) & cin WHEN sel = "1010"
        ELSE
        (OTHERS => '0');
END partc_arch;