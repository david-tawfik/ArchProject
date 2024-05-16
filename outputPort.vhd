LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY outputPort IS
    PORT (
        enable : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END outputPort;

ARCHITECTURE arch1 OF outputPort IS
BEGIN
    PROCESS (enable, data_in)
    BEGIN
        IF enable = '1' THEN
            data_out <= data_in;
        END IF;
    END PROCESS;
END arch1;