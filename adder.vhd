LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY adder IS
    GENERIC (n : INTEGER := 12);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cin : IN STD_LOGIC;
        F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cout : OUT STD_LOGIC);
END adder;

ARCHITECTURE arch_my_adder OF adder IS
    COMPONENT my_nadder IS
        GENERIC (n : INTEGER := 4);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT select_adder IS
        GENERIC (n : INTEGER := 4);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;
    -- SIGNAL s0, s1, s2, s3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s0 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL cout0, cout1, cout2 : STD_LOGIC;
BEGIN
    f0 : my_nadder GENERIC MAP(n) PORT MAP(A, B, cin, s0, cout0);
    -- f1 : my_nadder GENERIC MAP(n/4) PORT MAP(A((n/2) - 1 DOWNTO n/4), B((n/2) - 1 DOWNTO n/4), cout0, s1, cout1);
    -- f2 : my_nadder GENERIC MAP(n/4) PORT MAP(A((3 * n/4) - 1 DOWNTO n/2), B((3 * n/4) - 1 DOWNTO n/2), cout1, s2, cout2);
    -- f3 : my_nadder GENERIC MAP(n/4) PORT MAP(A(n - 1 DOWNTO (3 * n/4)), B(n - 1 DOWNTO 3 * n/4), cout2, s3, cout);

    -- F <= s3 & s2 & s1 & s0;
    F<=s0;

END arch_my_adder;