LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sp IS
    PORT (
        clk, rst : IN STD_LOGIC;
        -- spIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        spOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        spSel : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END sp;

ARCHITECTURE sp_arch OF sp IS
    SIGNAL spTemp : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (clk,spSel)
    BEGIN
        IF rst = '1' THEN
            spTemp <= (0 => '0', OTHERS => '1');
        
        ELSIF falling_edge(clk) AND spSel = "001" THEN
            spTemp <= STD_LOGIC_VECTOR(unsigned(spTemp) - 2);
        ELSIF clk'event AND clk='1' AND spSel = "010" THEN
            spTemp <= STD_LOGIC_VECTOR(unsigned(spTemp) + 2);
        END IF;
    END PROCESS;
    spOut <= spTemp;
END sp_arch;