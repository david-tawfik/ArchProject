LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zeroFlag, overflowFlag, negativeFlag, carryFlag : OUT STD_LOGIC
    );
END ENTITY alu;

ARCHITECTURE alu_arch OF alu IS
    COMPONENT my_nadder
        PORT (
            A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src1, src2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL carryIn, carryOut : STD_LOGIC;
    SIGNAL zero, overflow, negative, carry : STD_LOGIC;

BEGIN
    src1 <= NOT A WHEN sel = "0001" ELSE
        (OTHERS => '0') WHEN sel = "0010" ELSE
        A AND B WHEN sel = "0111" ELSE
        A OR B WHEN sel = "1000" ELSE
        A XOR B WHEN sel = "1001" ELSE
        B WHEN sel = "1111" ELSE
        A;

    src2 <= NOT A WHEN sel = "0010" ELSE
        (OTHERS => '1') WHEN sel = "0100" ELSE
        B WHEN sel = "0101" ELSE
        NOT B WHEN sel = "0110" ELSE
        (OTHERS => '0');

    carryIn <= '1' WHEN sel = "0010" OR sel = "0011" OR sel = "0110" ELSE
        '0';

    nadder1 : my_nadder PORT MAP(src1, src2, carryIn, result, carryOut);

    zeroFlag <= '1' WHEN result = "00000000000000000000000000000000" ELSE
        '0';
    overflow <= overflow when sel = "10" ELSE 
        '1' WHEN (src1(31) = '1' AND src2(31) = '1' AND NOT result(31) = '1') OR (NOT src1(31) = '1' AND NOT src2(31) = '1' AND result(31) = '1') ELSE
        '0';
    negativeFlag <= result(31);
    carry <= carry when sel = "10" ELSE
    carryOut;
    F <= result;
    overflowFlag <= overflow;
    carryFlag <= carry;

END alu_arch;