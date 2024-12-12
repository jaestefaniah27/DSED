LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY gen_enables_tb IS
END gen_enables_tb;

ARCHITECTURE behavior OF gen_enables_tb IS 

    -- Señales para conectar al DUT (Device Under Test)
    SIGNAL clk_12Mhz   : STD_LOGIC := '0';
    SIGNAL rst         : STD_LOGIC := '1';
    SIGNAL clk_3MHz    : STD_LOGIC;
    SIGNAL en_2_cycles : STD_LOGIC;
    SIGNAL en_4_cycles : STD_LOGIC;

    -- Periodo del reloj de 12 MHz (83.33 ns)
    CONSTANT clk_period : time := 83.33 ns;

BEGIN

    -- Instancia del DUT
    DUT: ENTITY work.gen_enables
        PORT MAP (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            clk_3MHz => clk_3MHz,
            en_2_cycles => en_2_cycles,
            en_4_cycles => en_4_cycles
        );

    -- Generación del reloj de 12 MHz
    clk_process :process
    begin
        clk_12Mhz <= '0';
        wait for clk_period / 2;
        clk_12Mhz <= '1';
        wait for clk_period / 2;
    end process;

    -- Proceso para simular el reset y observar las salidas
    stim_proc: process
    begin	
        -- Inicialización del reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- Esperar un tiempo para observar los resultados
        wait for 500 ns;

        -- Terminar la simulación
        wait;
    end process;

END;
