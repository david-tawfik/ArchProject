LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controllertoalu IS
    PORT(
        opCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zeroFlag, carryFlag, negativeFlag, overflowFlag : OUT STD_LOGIC
    );
END controllertoalu;

ARCHITECTURE behavior OF controllertoalu IS

    SIGNAL result_int : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero_int, carry_int, negative_int, overflow_int : STD_LOGIC;
    Component alu is
        PORT(
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            zeroFlag, overflowFlag, negativeFlag, carryFlag : OUT STD_LOGIC
        );
    END Component;
    Component controller is
        PORT(
            opCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            aluOp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            writeBack1, memRead, memWrite : OUT STD_LOGIC;
            memInReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            aluSrc : OUT STD_LOGIC
        );
    END Component;
    Signal aluOp : STD_LOGIC_VECTOR(3 DOWNTO 0);
    Signal writeBack1, memRead, memWrite : STD_LOGIC;
    Signal memInReg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Signal aluSrc : STD_LOGIC;
BEGIN
    controller1 : controller PORT MAP(opCode,aluOp,writeBack1,memRead,memWrite,memInReg,aluSrc);
    alu1 : alu PORT MAP(A, B, aluOp, result_int, zero_int, overflow_int, negative_int, carry_int);
    F <= result_int;
    zeroFlag <= zero_int;
    carryFlag <= carry_int;
    negativeFlag <= negative_int;
    overflowFlag <= overflow_int;
END behavior;

