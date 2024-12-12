LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_RAM IS
END tb_RAM;

ARCHITECTURE behavior OF tb_RAM IS
    -- Señales para conectar al DUT (Device Under Test)
    SIGNAL clka    : STD_LOGIC := '0';
    SIGNAL ena     : STD_LOGIC := '1';
    SIGNAL wea     : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addra   : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dina    : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL douta   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    -- Periodo del reloj
    CONSTANT clk_period : TIME := 83.333 ns;
BEGIN

    -- Generación del reloj
    clk_process : PROCESS
    BEGIN
        clka <= '0';
        WAIT FOR clk_period / 2;
        clka <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Instancia del DUT
    DUT: ENTITY work.blk_mem_gen_0
        PORT MAP (
            clka  => clka,
            ena   => ena,
            wea   => wea,
            addra => addra,
            dina  => dina,
            douta => douta
        );

    -- Proceso de estímulos
    stim_proc: PROCESS
    BEGIN
        -- 1. Escritura en la dirección 0
        addra <= "0000000000000000000"; -- Dirección 0
        dina <= "10101010";            -- Dato a escribir
        wea <= "1";                    -- Habilitar escritura
        WAIT FOR 1.5*clk_period;

        -- 2. Deshabilitar escritura
        wea <= "0";
        WAIT FOR 5*clk_period;

        -- 3. Leer de la dirección 0
        addra <= "0000000000000000000"; -- Dirección 0
        WAIT FOR 5*clk_period;

        -- 4. Leer de una dirección no escrita
        addra <= "0000000000000000001"; -- Dirección 1
        WAIT FOR 5*clk_period;
        addra <= "0000000000000000000"; -- Dirección 1
        WAIT FOR 5*clk_period;
        dina <= "01010101";            -- Dato a escribir
        WAIT FOR 2*clk_period;
        wea <= "1";                    -- Habilitar escritura
        WAIT FOR clk_period;
        wea <= "0";                    -- Desabilitar escritura

        -- Terminar simulación
        WAIT;
    END PROCESS;
END behavior;
