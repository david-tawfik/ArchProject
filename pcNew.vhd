LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pcNew IS
    PORT (
        clk : IN STD_LOGIC;
        pcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END pcNew;

ARCHITECTURE pc_arch OF pcNew IS
    SIGNAL c : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            count <= pcIn;
        END IF;
    END PROCESS;
END pc_arch;