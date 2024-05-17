LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        aluOp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        writeBack1, writeBack2, memRead, memWrite, zero_we, overflow_we, negative_we, carry_we, outputPort_enable, in_op : OUT STD_LOGIC;
        WB_data_src : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        memInReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        aluSrc : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE controller_arch OF controller IS
BEGIN
    PROCESS (opCode)
    BEGIN
        CASE opCode(5 DOWNTO 4) IS
            WHEN "00" =>
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
                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "1011" OR opCode(3 DOWNTO 0) = "1100") THEN
                    zero_we <= '0';
                    negative_we <= '0';
                ELSE
                    zero_we <= '1';
                    negative_we <= '1';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "1011" OR opCode(3 DOWNTO 0) = "1100" OR opCode(3 DOWNTO 0) = "1000" OR opCode(3 DOWNTO 0) = "1001" OR opCode(3 DOWNTO 0) = "1010" OR opCode(3 DOWNTO 0) = "0001") THEN
                    carry_we <= '0';
                    overflow_we <= '0';
                ELSE
                    carry_we <= '1';
                    overflow_we <= '1';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "0111" OR opCode(3 DOWNTO 0) = "1011" OR opCode(3 DOWNTO 0) = "1100") THEN
                    WB_data_src <= "00";
                ELSE
                    WB_data_src <= "01";
                END IF;
                memRead <= '0';
                memWrite <= '0';
                memInReg <= "00";
                aluSrc <= '0';
                outputPort_enable <= '0';
                writeBack2 <= '0';
                in_op <= '0';
            WHEN "01" => -- Immediate value (only LDM for this phase)
                IF (opCode(3 DOWNTO 0) = "0010" OR opCode(3 DOWNTO 0) = "0101" OR opCode(3 DOWNTO 0) = "0110") THEN
                    WB_data_src <= "01";
                ELSE
                    WB_data_src <= "00";
                END IF;
                IF (opCode(3 DOWNTO 0) = "0101") THEN
                    aluOp <= "0101";
                ELSIF (opCode(3 DOWNTO 0) = "0110") THEN
                    aluOp <= "0110";
                ELSE
                    aluOp <= "1111";
                END IF;
                writeBack1 <= '1';
                writeBack2 <= '0';

                memRead <= '0';
                memWrite <= '0';
                memInReg <= "00";
                aluSrc <= '1';
                zero_we <= '0';
                negative_we <= '0';
                overflow_we <= '0';
                carry_we <= '0';
                outputPort_enable <= '0';
                in_op <= '0';
            WHEN "10" => -- Example case
                WB_data_src <= "00";
                writeBack1 <= '1';
                writeBack2 <= '0';
                aluOp <= "0000"; -- Default ALU operation code
                memRead <= '0';
                memWrite <= '1';
                memInReg <= "00";
                aluSrc <= '0';
                zero_we <= '0';
                negative_we <= '0';
                overflow_we <= '0';
                carry_we <= '0';
                outputPort_enable <= '0';
                in_op <= '0';
            WHEN OTHERS => -- "11"  (only mov for this phase)
                IF (opCode(3 DOWNTO 0) = "0000") THEN
                    outputPort_enable <= '1';
                ELSE
                    outputPort_enable <= '0';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0001") THEN
                    WB_data_src <= "10";
                    in_op <= '1';
                ELSE
                    WB_data_src <= "01";
                    in_op <= '0';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "0100" OR opCode(3 DOWNTO 0) = "0101") THEN
                    writeBack1 <= '0';
                ELSE
                    writeBack1 <= '1';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0011") THEN
                    writeBack2 <= '1';
                ELSE
                    writeBack2 <= '0';
                END IF;
                aluOp <= "0000";
                memRead <= '0';
                memWrite <= '0';
                memInReg <= "00";
                aluSrc <= '0';
                zero_we <= '0';
                negative_we <= '0';
                overflow_we <= '0';
                carry_we <= '0';
        END CASE;
    END PROCESS;
END controller_arch;