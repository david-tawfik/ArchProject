-- 0011 decrement 000
-- 0101 and 100
-- NOP 010

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT (
        op_code : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        functionality : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        write_enable : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE controller_arch OF controller IS
BEGIN
    PROCESS (op_code)
    BEGIN
        CASE op_code IS
            WHEN "000" =>
                functionality <= "0011";
                write_enable <= '1';
            WHEN "010" =>
                functionality <= "1011";
                write_enable <= '0';
            WHEN "100" =>
                functionality <= "0101";
                write_enable <= '1';
            WHEN OTHERS =>
                write_enable<='0';
        END CASE;
    END PROCESS;
END controller_arch;
