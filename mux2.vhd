LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2x1 IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16
    );
    PORT (
        in0, in1 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        sel : IN STD_LOGIC;
        out1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
    );
END mux2x1;

ARCHITECTURE arch1 OF mux2x1 IS
BEGIN
    out1 <= in0 WHEN sel = '0'
        ELSE
        in1 WHEN sel = '1';
END arch1;