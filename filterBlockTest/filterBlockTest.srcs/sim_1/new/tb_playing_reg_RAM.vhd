LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_playing_reg IS
END tb_playing_reg;

ARCHITECTURE behavior OF tb_playing_reg IS
    -- Señales para el testbench
    SIGNAL clk_12Mhz : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL en : STD_LOGIC := '0';
    SIGNAL sample_req : STD_LOGIC := '0';
    SIGNAL to_jack : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Cambiar tamaño según sample_size
    SIGNAL addr : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL dout : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Cambiar tamaño según sample_size
    SIGNAL filter_select : STD_LOGIC;
    SIGNAL sample_to_filter : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Cambiar tamaño según sample_size
    SIGNAL sample_to_filter_en : STD_LOGIC;
    SIGNAL sample_from_filter : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Cambiar tamaño según sample_size
    SIGNAL sample_from_filter_en : STD_LOGIC;
    SIGNAL fin_idx : STD_LOGIC_VECTOR(18 DOWNTO 0) := "0000000000000010000";
    SIGNAL SW : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL BTNR, BTNL : STD_LOGIC := '0';

    -- Reloj y periodo
    CONSTANT clk_period : TIME := 83.333 ns;  -- Ajusta el periodo del reloj

    -- Señales internas para simular el retraso en dout
    SIGNAL addr_dout_delay : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL dout_delay : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Cambiar tamaño según sample_size
    SIGNAL dout_delay2 : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- Para simular 2 ciclos de retraso

BEGIN

    -- Instancia del DUT (Device Under Test)
    DUT: ENTITY work.playing_reg
        PORT MAP (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            en => en,
            sample_req => sample_req,
            to_jack => to_jack,
            addr => addr,
            dout => dout,
            filter_select => filter_select,
            sample_to_filter => sample_to_filter,
            sample_to_filter_en => sample_to_filter_en,
            sample_from_filter => sample_from_filter,
            sample_from_filter_en => sample_from_filter_en,
            fin_idx => fin_idx,
            SW => SW,
            BTNR => BTNR,
            BTNL => BTNL
        );

    -- Generación de reloj
    clk_process : PROCESS
    BEGIN
        clk_12Mhz <= '1';
        WAIT FOR clk_period / 2;
        clk_12Mhz <= '0';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Proceso de simulación de la memoria RAM con retraso de 2 ciclos de reloj
    RAM_DELAY_PROCESS : PROCESS(clk_12Mhz, addr)
    BEGIN
        IF rising_edge(clk_12Mhz) THEN
            addr_dout_delay <= addr;
            dout <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_dout_delay)) + 1, 8));  -- Simulación de valor en dout;  -- Primer ciclo de retraso
        END IF;
    END PROCESS;

    SAMPLE_REQ_PROCESS: PROCESS
    BEGIN
        sample_req <= '0';
        wait for 49 * clk_period;
        sample_req <= '1';
        wait for clk_period;
        sample_req <= '0';
    END PROCESS;

    -- Proceso de estímulos
    stim_proc: PROCESS
    BEGIN
        rst <= '1';  -- Activar reset
        WAIT FOR 2 * clk_period;
        rst <= '0';  -- Desactivar reset
        WAIT FOR clk_period;

        SW <= "00";  -- Configurar SW a "00"
        WAIT FOR clk_period;

        WAIT FOR 10 * clk_period;

        en <= '1';  -- Habilitar el módulo
        WAIT FOR 400*clk_period;
        btnl <= '1';
        wait for 3*clk_period;
        btnl <= '0';
        wait for 400*clk_period;
        
        SW <= "10";
        wait for 350*clk_period;
        btnr <= '1';
        wait for 3*clk_period;
        btnr <= '0';
        wait for 300*clk_period;
        SW <= "11";
        wait for 300*clk_period;
        SW <= "01";
        WAIT;
    END PROCESS;

END behavior;
