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
        sp_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Jmp : OUT STD_LOGIC;
        Jz : OUT STD_LOGIC;
        aluSrc : OUT STD_LOGIC;
        pf_enable : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        src1_needed, src2_needed : OUT STD_LOGIC
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
                ELSIF (opCode(3 DOWNTO 0) = "1011") THEN
                    aluOp <= "0000"; -- Special case for opcode "1000"
                    sp_sel <= "001";
                ELSIF (opCode(3 DOWNTO 0) = "1100") THEN
                    aluOp <= "0000"; -- Special case for opcode "1000"
                    sp_sel <= "010";
                ELSE
                    aluOp <= opCode(3 DOWNTO 0);
                    sp_sel <= "000";
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
                IF (opCode(3 DOWNTO 0) = "1100") THEN
                    memRead <= '1';
                ELSE
                    memRead <= '0';
                END IF;
                IF (opCode(3 DOWNTO 0) = "1011") THEN
                    memWrite <= '1';
                ELSE
                    memWrite <= '0';
                END IF;

                IF (opCode(3 DOWNTO 0) = "1010") THEN
                    aluOp <= "0111";
                END IF;

                IF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "1100") THEN
                    src1_needed <= '0';
                    src2_needed <= '0';
                ELSIF (opCode(3 DOWNTO 0) = "0001" OR opCode(3 DOWNTO 0) = "0010" OR opCode(3 DOWNTO 0) = "0011" OR opCode(3 DOWNTO 0) = "0100" OR opCode(3 DOWNTO 0) = "1011") THEN
                    src1_needed <= '1';
                    src2_needed <= '0';
                ELSE
                    src1_needed <= '1';
                    src2_needed <= '1';

                END IF;
                memInReg <= "00";
                aluSrc <= '0';
                outputPort_enable <= '0';
                writeBack2 <= '0';
                in_op <= '0';

                Jmp <= '0';
                Jz <= '0';

                pf_enable <= "00";

            WHEN "01" => -- Immediate value (only LDM for this phase)
                IF (opCode(3 DOWNTO 0) = "0010" OR opCode(3 DOWNTO 0) = "0101" OR opCode(3 DOWNTO 0) = "0110") THEN
                    WB_data_src <= "01";
                ELSE
                    WB_data_src <= "00";
                END IF;

                IF (opCode(3 DOWNTO 0) = "0100") THEN
                    memWrite <= '1';
                    writeBack1 <= '0';
                ELSE
                    memWrite <= '0';
                    writeBack1 <= '1';
                END IF;

                IF (opCode(3 DOWNTO 0) = "0011") THEN
                    memRead <= '1';
                    WB_data_src <= "00";
                ELSE
                    memRead <= '0';
                    WB_data_src <= "01";
                END IF;

                IF (opCode(3 DOWNTO 0) = "0010") THEN -- LDM
                    aluOp <= "1111";
                ELSIF (opCode(3 DOWNTO 0) = "0110") THEN --SUBI
                    aluOp <= "0110";
                ELSE
                    aluOp <= "0101";
                END IF;
                IF (opCode(3 DOWNTO 0) = "0010") THEN
                    src1_needed <= '0';
                    src2_needed <= '0';
                ELSIF (opCode(3 DOWNTO 0) = "0011" OR opCode(3 DOWNTO 0) = "0101" OR opCode(3 DOWNTO 0) = "0110") THEN
                    src1_needed <= '1';
                    src2_needed <= '0';
                ELSE
                    src1_needed <= '1';
                    src2_needed <= '1';
                END IF;

                writeBack2 <= '0';
                -- IF (opCode(3 DOWNTO 0) = "0101") THEN
                --     aluOp <= "0101";
                -- ELSIF (opCode(3 DOWNTO 0) = "0110") THEN
                --     aluOp <= "0110";
                -- ELSE
                --     aluOp <= "1111";
                -- END IF;
                -- writeBack1 <= '1';
                -- writeBack2 <= '0';
                sp_sel <= "000";
                memInReg <= "00";
                aluSrc <= '1';
                zero_we <= '0';
                negative_we <= '0';
                overflow_we <= '0';
                carry_we <= '0';
                outputPort_enable <= '0';
                in_op <= '0';
                Jmp <= '0';
                Jz <= '0';
            WHEN "10" => -- Example case

                IF (opCode(3 DOWNTO 0) = "0011") THEN
                    src1_needed <= '0';
                    src2_needed <= '0';
                ELSIF (opCode(3 DOWNTO 0) = "0000" OR opCode(3 DOWNTO 0) = "0001" OR opCode(3 DOWNTO 0) = "0010") THEN
                    src1_needed <= '1';
                    src2_needed <= '0';
                ELSE
                    src1_needed <= '1';
                    src2_needed <= '1';
                END IF;
                WB_data_src <= "00";
                writeBack1 <= '0';
                writeBack2 <= '0';
                aluOp <= "0000"; -- Default ALU operation code
                IF (opCode(3 DOWNTO 0) = "0011") THEN
                    memRead <= '1';
                ELSE
                    memRead <= '0';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0010") THEN
                    memWrite <= '1';
                ELSE
                    memWrite <= '0';
                END IF;
                memInReg <= "00";
                aluSrc <= '0';
                zero_we <= '0';
                negative_we <= '0';
                overflow_we <= '0';
                carry_we <= '0';
                outputPort_enable <= '0';
                in_op <= '0';
                IF (opCode(3 DOWNTO 0) = "0010") THEN
                    sp_sel <= "100";
                ELSIF (opCode(3 DOWNTO 0) = "0011") THEN
                    sp_sel <= "011";
                ELSE
                    sp_sel <= "000";
                END IF;
                IF (opCode(3 DOWNTO 0) = "0000") THEN -- Jz
                    Jz <= '1';
                ELSE
                    Jz <= '0';
                END IF;
                IF (opCode(3 DOWNTO 0) = "0001") THEN -- Jmp
                    Jmp <= '1';
                ELSE
                    Jmp <= '0';
                END IF;
                pf_enable <= "00";

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
                IF (opCode(3 DOWNTO 0) = "0100") THEN
                    pf_enable <= "01";
                ELSIF (opCode(3 DOWNTO 0) = "0101") THEN
                    pf_enable <= "10";
                ELSE
                    pf_enable <= "00";
                END IF;
                IF (opCode(3 DOWNTO 0) = "0001") THEN
                    src1_needed <= '0';
                    src2_needed <= '0';
                ELSIF (opCode(3 DOWNTO 0) = "0011") THEN
                    src1_needed <= '1';
                    src2_needed <= '1';
                ELSE
                    src1_needed <= '1';
                    src2_needed <= '0';
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
                sp_sel <= "000";
                Jmp <= '0';
                Jz <= '0';
        END CASE;
    END PROCESS;
END controller_arch;