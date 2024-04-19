LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        aluOp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        writeBack1, memRead, memWrite : OUT STD_LOGIC;
        memInReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        aluSrc : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE controller_arch OF controller IS
BEGIN
    PROCESS (opCode)
    BEGIN
        CASE opCode(5 DOWNTO 4) IS
            WHEN "00" => -- NOP
                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "0111") THEN
                    writeBack1 <= '0';
                ELSE
                    writeBack1 <= '1';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0111") THEN
                    aluOp <= "0110"; -- Special case for opcode "0111"
                ELSE
                    aluOp <= opCode(3 DOWNTO 0);
                END IF;
                memRead <= '0';
                memWrite <= '0';
                memInReg <= "00";
                aluSrc <= '0';
            WHEN "01" => -- Example case
                writeBack1 <= '1';
                aluOp <= "1111"; -- Example ALU operation code
                memRead <= '0';
                memWrite <= '0';
                memInReg <= "00";
                aluSrc <= '1';
            WHEN "10" => -- Example case
                writeBack1 <= '1';
                aluOp <= "0000"; -- Default ALU operation code
                memRead <= '0';
                memWrite <= '1';
                memInReg <= "00";
                aluSrc <= '0';
            WHEN OTHERS =>
                writeBack1 <= '1';
                aluOp <= "0000"; -- Default ALU operation code
                memRead <= '0';
                memWrite <= '1';
                memInReg <= "00";
                aluSrc <= '0';
        END CASE;
    END PROCESS;
END controller_arch;