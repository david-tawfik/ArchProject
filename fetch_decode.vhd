
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fetch_decode IS
	PORT(	Clk,Rst : IN std_logic;
		instruction : IN std_logic_vector(15 DOWNTO 0);
		op_code : OUT std_logic_vector(5 DOWNTO 0);
        dst, src1, src2 : OUT std_logic_vector(2 DOWNTO 0)
    );
END fetch_decode;

ARCHITECTURE fetch_decode_arch OF fetch_decode IS
    signal temp_op_code : std_logic_vector(5 DOWNTO 0);
    signal temp_dst, temp_src1, temp_src2 : std_logic_vector(2 DOWNTO 0);

BEGIN
PROCESS(clk,rst)
BEGIN
    IF(rst = '1') THEN
        op_code <= "000000";
        dst <= "000";
        src1 <= "000";
        src2 <= "000";
    ELSIF clk'event and clk = '0' THEN --read in rising edge
        temp_op_code <= instruction(15 DOWNTO 10);
        temp_dst <= instruction(9 DOWNTO 7);
        temp_src1 <= instruction(6 DOWNTO 4);
        temp_src2 <= instruction(3 DOWNTO 1);
    ELSIF clk'event and clk = '0' THEN --write in falling edge
    
    END IF;
    op_code <= temp_op_code;
    dst <= temp_dst;
    src1 <= temp_src1;
    src2 <= temp_src2;

END PROCESS;
	

END fetch_decode_arch;
