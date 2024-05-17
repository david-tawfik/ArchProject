LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pcAdder IS
    PORT (
        in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        stall : IN STD_LOGIC;
        out1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END pcAdder;

ARCHITECTURE arch1 OF pcAdder IS
BEGIN
    out1 <= STD_LOGIC_VECTOR(unsigned(in1) + 1) WHEN (stall = '0') ELSE in1;
END arch1;
