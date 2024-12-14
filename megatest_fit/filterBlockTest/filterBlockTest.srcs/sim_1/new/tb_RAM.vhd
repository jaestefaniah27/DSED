LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_RAM IS
END tb_RAM;

ARCHITECTURE behavior OF tb_RAM IS
    -- Se�ales para conectar al DUT (Device Under Test)
    SIGNAL clka    : STD_LOGIC := '0';
    SIGNAL rsta    : STD_LOGIC := '0';
    SIGNAL wea     : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addra   : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dina    : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL douta   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    -- Periodo del reloj
    CONSTANT clk_period : TIME := 83.333 ns;
BEGIN

    -- Generaci�n del reloj
    clk_process : PROCESS
    BEGIN
        clka <= '1';
        WAIT FOR clk_period / 2;
        clka <= '0';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Instancia del DUT
    DUT: ENTITY work.blk_mem_gen_0
        PORT MAP (
            clka  => clka,
            rsta  => rsta,
            wea   => wea,
            addra => addra,
            dina  => dina,
            douta => douta
        );

    -- Proceso de est�mulos
    stim_proc: PROCESS
    BEGIN
        -- 1. Escritura en las 4 direcciones
        -- Escribir en la direcci�n 0
        addra <= "0000000000000000000"; -- Direcci�n 0
        dina <= "10101010";             -- Dato a escribir
        wea <= "1";                     -- Habilitar escritura
        WAIT FOR clk_period;            -- 1 ciclo de reloj para escritura
        wea <= "0";                     -- Deshabilitar escritura
        WAIT FOR 1 * clk_period;        -- Esperar 2 ciclos para que se guarde el dato

        -- Escribir en la direcci�n 1
        addra <= "0000000000000000001"; -- Direcci�n 1
        dina <= "01010101";             -- Dato a escribir
        wea <= "1";                     -- Habilitar escritura
        WAIT FOR clk_period;            -- 1 ciclo de reloj para escritura
        wea <= "0";                     -- Deshabilitar escritura
        WAIT FOR 1 * clk_period;        -- Esperar 2 ciclos para que se guarde el dato

        -- Escribir en la direcci�n 2
        addra <= "0000000000000000010"; -- Direcci�n 2
        dina <= "11110000";             -- Dato a escribir
        wea <= "1";                     -- Habilitar escritura
        WAIT FOR clk_period;            -- 1 ciclo de reloj para escritura
        wea <= "0";                     -- Deshabilitar escritura
        WAIT FOR 1 * clk_period;        -- Esperar 2 ciclos para que se guarde el dato

        -- Escribir en la direcci�n 3
        addra <= "0000000000000000011"; -- Direcci�n 3
        dina <= "11111111";             -- Dato a escribir
        wea <= "1";                     -- Habilitar escritura
        WAIT FOR clk_period;            -- 1 ciclo de reloj para escritura
        wea <= "0";                     -- Deshabilitar escritura
        WAIT FOR 1 * clk_period;        -- Esperar 2 ciclos para que se guarde el dato
        dina <= "00000000";             -- Dato a escribir

        -- 2. Lectura de las 4 direcciones
        -- Leer de la direcci�n 0
        addra <= "0000000000000000000"; -- Direcci�n 0
        WAIT FOR 2 * clk_period;        -- Esperar 2 ciclos de reloj para lectura

        -- Leer de la direcci�n 1
        addra <= "0000000000000000001"; -- Direcci�n 1
        WAIT FOR 2 * clk_period;        -- Esperar 2 ciclos de reloj para lectura

        -- Leer de la direcci�n 2
        addra <= "0000000000000000010"; -- Direcci�n 2
        WAIT FOR 2 * clk_period;        -- Esperar 2 ciclos de reloj para lectura

        -- Leer de la direcci�n 3
        addra <= "0000000000000000011"; -- Direcci�n 3
        WAIT FOR 2 * clk_period;        -- Esperar 2 ciclos de reloj para lectura

        
        -- Terminar simulaci�n
        WAIT;
    END PROCESS;
END behavior;
