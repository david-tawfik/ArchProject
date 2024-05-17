LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY load_use_control IS
    PORT (
        reset, write_back_de, mem_read_de, src1_needed, src2_needed : IN STD_LOGIC;
        Rdst_de, Rsrc1_fd, Rsrc2_fd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        load_use_enable : OUT STD_LOGIC
    );
END ENTITY load_use_control;

ARCHITECTURE load_use_control_arch OF load_use_control IS
BEGIN
    load_use_enable <= '0';

    process(reset, write_back_de, mem_read_de, src1_needed, src2_needed, Rdst_de, Rsrc1_fd, Rsrc2_fd)
    begin
        if reset = '1' then
            load_use_enable <= '0';
        elsif (write_back_de = '1' AND mem_read_de = '1' AND ((Rdst_de = Rsrc1_fd AND src1_needed = '1') OR (Rdst_de = Rsrc2_fd AND src2_needed = '1'))) then
            load_use_enable <= '1';
        else
            load_use_enable <= '0';
        end if;
    end process;
END load_use_control_arch;