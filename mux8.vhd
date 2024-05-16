LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux8x1 IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16
    );
    PORT (
        in0, in1, in2, in3, in4, in5, in6, in7 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        out1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
    );
END mux8x1;

ARCHITECTURE arch1 OF mux8x1 IS
BEGIN
    out1 <= in0 WHEN sel = "000" ELSE
        in1 WHEN sel = "001" ELSE
        in2 WHEN sel = "010" ELSE
        in3 WHEN sel = "011" ELSE
        in4 WHEN sel = "100" ELSE
        in5 WHEN sel = "101" ELSE
        in6 WHEN sel = "110" ELSE
        in7 WHEN sel = "111";
END arch1;