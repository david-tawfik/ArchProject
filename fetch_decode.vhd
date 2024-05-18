
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fetch_decode IS
    PORT (
        Clk, Rst, noWrite, JmpRst : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pcPlusOneIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        InputPort_to_FD : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        InputPort_from_FD_to_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        op_code : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        dst, src1, src2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        pcPlusOneOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END fetch_decode;

ARCHITECTURE fetch_decode_arch OF fetch_decode IS
    SIGNAL temp_op_code : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL temp_dst, temp_src1, temp_src2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_InputPort : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_pcPlusOne : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (falling_edge(clk) AND rst = '1') THEN
            temp_op_code <= "000000";
            temp_dst <= "000";
            temp_src1 <= "000";
            temp_src2 <= "000";
            temp_pcPlusOne <= (OTHERS => '0');
        ELSIF (falling_edge(clk) AND JmpRst = '1') THEN
            temp_op_code <= "000000";
            temp_dst <= "000";
            temp_src1 <= "000";
            temp_src2 <= "000";
            temp_pcPlusOne <= (OTHERS => '0');
        ELSIF falling_edge(clk) AND noWrite = '0' THEN
            temp_op_code <= instruction(15 DOWNTO 10);
            temp_dst <= instruction(9 DOWNTO 7);
            temp_src1 <= instruction(6 DOWNTO 4);
            temp_src2 <= instruction(3 DOWNTO 1);
            temp_InputPort <= InputPort_to_FD;
            temp_pcPlusOne <= pcPlusOneIn;
            --ELSIF clk'event and clk = '0' THEN --write in falling edge
        END IF;
        op_code <= temp_op_code;
        dst <= temp_dst;
        src1 <= temp_src1;
        src2 <= temp_src2;
        InputPort_from_FD_to_DE <= temp_InputPort;
        pcPlusOneOut <= temp_pcPlusOne;
    END PROCESS;

END fetch_decode_arch;