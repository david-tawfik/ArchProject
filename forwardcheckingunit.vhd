LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY forwardcheckingunit IS
    PORT (
        src1_address_EX, src2_address_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Dst1_address_MEM, Dst2_address_MEM, Dst1_address_WB, Dst2_address_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_out_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_out_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        InputPort_from_EM_to_MWB, InputPort_from_MWB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB1_MEM, WB2_MEM, WB1_WB, WB2_WB : IN STD_LOGIC;
        in_op_from_EM, in_op_from_MWB : IN STD_LOGIC;
        src2_data_mem, src2_data_wb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        forwarded_value1, forwarded_value2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memory_out_write_back : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memory_read_write_back : IN STD_LOGIC;
        forward_sel1 : OUT STD_LOGIC;
        forward_sel2 : OUT STD_LOGIC

    );
END forwardcheckingunit;

ARCHITECTURE fcu_arch OF forwardcheckingunit IS
BEGIN
    PROCESS (src1_address_EX, src2_address_EX, Dst1_address_MEM, Dst2_address_MEM, Dst1_address_WB, Dst2_address_WB, WB1_MEM, WB2_MEM, WB1_WB, WB2_WB, in_op_from_EM, in_op_from_MWB, alu_out_MEM, alu_out_WB, InputPort_from_EM_to_MWB, InputPort_from_MWB)
        -- Variables to track if forwarding from MEM stage
        VARIABLE isMEM1 : BOOLEAN := FALSE;
        VARIABLE isMEM2 : BOOLEAN := FALSE;
        VARIABLE isSwap1 : BOOLEAN := FALSE;
        VARIABLE isSwap2 : BOOLEAN := FALSE;
        VARIABLE isLoad1 : BOOLEAN := FALSE;
        VARIABLE isLoad2 : BOOLEAN := FALSE;

    BEGIN
        -- Default values
        isMEM1 := FALSE;
        isMEM2 := FALSE;
        isSwap1 := FALSE;
        isSwap2 := FALSE;
        isLoad1 := FALSE;
        isLoad2 := FALSE;
        forward_sel1 <= '0';
        forward_sel2 <= '0';
        forwarded_value1 <= (OTHERS => '0');
        forwarded_value2 <= (OTHERS => '0');
        IF (src1_address_EX = Dst1_address_WB AND WB1_WB = '1' AND memory_read_write_back = '1') THEN
            forward_sel1 <= '1';
            isLoad1 := TRUE;
        ELSIF (src1_address_EX = Dst1_address_WB AND WB1_WB = '1') THEN
            forward_sel1 <= '1';

        ELSIF (src1_address_EX = Dst2_address_WB AND WB2_WB = '1') THEN
            forward_sel1 <= '1';
            isSwap1 := TRUE;
        END IF;

        -- Forwarding logic for src1_address_EX
        IF (src1_address_EX = Dst1_address_MEM AND WB1_MEM = '1') THEN
            forward_sel1 <= '1';
            isMEM1 := TRUE;
        ELSIF (src1_address_EX = Dst2_address_MEM AND WB2_MEM = '1') THEN
            forward_sel1 <= '1';
            isMEM1 := TRUE;
            isSwap1 := TRUE;
        END IF;

        -- Forwarding logic for src2_address_EX
        IF (src2_address_EX = Dst1_address_WB AND WB1_WB = '1' AND memory_read_write_back = '1') THEN
            forward_sel2 <= '1';
            isLoad2 := TRUE;
        ELSIF (src2_address_EX = Dst1_address_WB AND WB1_WB = '1') THEN
            forward_sel2 <= '1';
        ELSIF (src2_address_EX = Dst2_address_WB AND WB2_WB = '1') THEN
            forward_sel2 <= '1';
            isSwap2 := TRUE;
        END IF;

        IF (src2_address_EX = Dst1_address_MEM AND WB1_MEM = '1') THEN
            forward_sel2 <= '1';
            isMEM2 := TRUE;
        ELSIF (src2_address_EX = Dst2_address_MEM AND WB2_MEM = '1') THEN
            forward_sel2 <= '1';
            isMEM2 := TRUE;
            isSwap2 := TRUE;
        END IF;

        -- Assign forwarded values based on forwarding control signals
        IF (isMEM1 = TRUE) THEN
            IF (in_op_from_EM = '0' AND isSwap1 = FALSE) THEN
                forwarded_value1 <= alu_out_MEM;
            ELSIF (in_op_from_EM = '0' AND isSwap1 = TRUE) THEN
                forwarded_value1 <= src2_data_mem;
            ELSE
                forwarded_value1 <= InputPort_from_EM_to_MWB;
            END IF;
        ELSE
            IF (in_op_from_MWB = '0' AND isSwap1 = FALSE) THEN
                forwarded_value1 <= alu_out_WB;
            ELSIF (in_op_from_MWB = '0' AND isSwap1 = TRUE) THEN
                forwarded_value1 <= src2_data_wb;
            ELSE
                forwarded_value1 <= InputPort_from_MWB;
            END IF;
            IF (isLoad1 = TRUE) THEN
                forwarded_value1 <= memory_out_write_back;
            END IF;
        END IF;
        IF (isMEM2 = TRUE) THEN
            IF (in_op_from_EM = '0' AND isSwap2 = FALSE) THEN
                forwarded_value2 <= alu_out_MEM;
            ELSIF (in_op_from_EM = '0' AND isSwap2 = TRUE) THEN
                forwarded_value2 <= src2_data_mem;
            ELSE
                forwarded_value2 <= InputPort_from_EM_to_MWB;
            END IF;
        ELSE
            IF (in_op_from_MWB = '0' AND isSwap2 = FALSE) THEN
                forwarded_value2 <= alu_out_WB;
            ELSIF (in_op_from_MWB = '0' AND isSwap2 = TRUE) THEN
                forwarded_value2 <= src2_data_wb;
            ELSE
                forwarded_value2 <= InputPort_from_MWB;
            END IF;
            if (isLoad2 = TRUE) then
                forwarded_value2 <= memory_out_write_back;
            end if ;
        END IF;
    END PROCESS;

END fcu_arch;