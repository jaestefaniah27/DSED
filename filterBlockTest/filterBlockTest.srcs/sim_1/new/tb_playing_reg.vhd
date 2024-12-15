----------------------------------------------------------------------------------
-- Testbench para el módulo playing_reg
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Paquete con definiciones del tamaño de muestra y otros parámetros
use work.packageDSED.all;

entity tb_playing_reg is
end tb_playing_reg;

architecture test of tb_playing_reg is
    -- Señales internas para conectar con el módulo bajo prueba (DUT)
    signal clk_12Mhz          : std_logic := '0';
    signal rst                : std_logic := '0';
    signal sample_from_micro, sample_from_micro_next  : std_logic_vector(sample_size - 1 downto 0) := (others => '0');
    signal sample_from_micro_ready : std_logic := '0';
    signal rec_en             : std_logic;
    signal play_en            : std_logic;
    signal sample_req         : std_logic := '0';
    signal to_jack            : std_logic_vector(sample_size - 1 downto 0);
    signal addr               : std_logic_vector(18 downto 0);
    signal din, dout          : std_logic_vector(sample_size - 1 downto 0) := (others => '0');
    signal we, filter_select  : std_logic;
    signal sample_to_filter   : std_logic_vector(sample_size - 1 downto 0);
    signal sample_to_filter_en : std_logic;
    signal sample_from_filter : std_logic_vector(sample_size - 1 downto 0) := (others => '0');
    signal sample_from_filter_en : std_logic := '0';
    signal SW                 : std_logic_vector(1 downto 0) := "00";
    signal BTNU, BTND, BTNC, BTNR, BTNL : std_logic := '0';
    signal addr_dout_delay : std_logic_vector(18 downto 0);
    -- Período de reloj simulado
    constant clk_period : time := 83.333 ns; -- Aproximado para 12 MHz
begin

    -- Instancia del DUT
    DUT: entity work.playing_reg
        port map(
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            sample_from_micro => sample_from_micro,
            sample_from_micro_ready => sample_from_micro_ready,
            rec_en => rec_en,
            play_en => play_en,
            sample_req => sample_req,
            to_jack => to_jack,
            addr => addr,
            din => din,
            dout => dout,
            we => we,
            filter_select => filter_select,
            sample_to_filter => sample_to_filter,
            sample_to_filter_en => sample_to_filter_en,
            sample_from_filter => sample_from_filter,
            sample_from_filter_en => sample_from_filter_en,
            SW => SW,
            BTNU => BTNU,
            BTND => BTND,
            BTNC => BTNC,
            BTNR => BTNR,
            BTNL => BTNL
        );

    -- Generación del reloj
    clk_process : process
    begin
        clk_12Mhz <= '0';
        wait for clk_period/2;
        clk_12Mhz <= '1';
        wait for clk_period/2;
    end process;

    RAM_DELAY_PROCESS : PROCESS(clk_12Mhz, addr)
    BEGIN
        IF rising_edge(clk_12Mhz) THEN
            addr_dout_delay <= addr;
            dout <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_dout_delay)) + 1, 8));  -- Simulación de valor en dout;  -- Primer ciclo de retraso
        END IF;
    END PROCESS;   
--    SAMPLE_REQ_AND_PLAY_EN_PROCESS: PROCESS
--    BEGIN
--            sample_from_micro_ready <= '0';
--            sample_req <= '0';
--            wait for 299*clk_period;
--            sample_from_micro_ready <= '1' and rec_en;
--            sample_req <= '1' and play_en;
--            wait for clk_period;
--            sample_from_micro_ready <= '0';
--            sample_req <= '0';                        
--    END PROCESS; 
    -- Estímulos de prueba
    stim_process : process
    begin
        ------------------------------------------------------------
        -- Reseteo inicial
        ------------------------------------------------------------
        rst <= '1';
        wait for 5 * clk_period;
        rst <= '0';
        wait for 5 * clk_period;

        ------------------------------------------------------------
        -- Caso de grabación (BTNU = '1')
        -- Se activa BTNU y se esperan algunas muestras
        ------------------------------------------------------------
        BTNU <= '1';
        -- Supongamos que llegan muestras desde el micro
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000001";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000010";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000011";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000100";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000101";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000110";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00000111";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period;
            sample_from_micro_ready <= '0';
            sample_from_micro <= "00001000";
            wait for 299*clk_period;
            sample_from_micro_ready <= '1';
            wait for clk_period; 
            sample_from_micro_ready <= '0';                                                                               
        wait for 250*clk_period;
        -- Apagar modo grabación
        BTNU <= '0';
        wait for 5 * clk_period;

        ------------------------------------------------------------
        -- Caso reproducción (activar PLAYING con BTNR por ejemplo)
        ------------------------------------------------------------
        -- Simulación de presionar BTNR para iniciar reproducción
        BTNL <= '1';
        wait for clk_period;
        BTNL <= '0';
        sample_from_micro_ready <= '0';
                    sample_from_filter <= "00000001";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000010";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000011";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000100";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000101";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000110";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00000111";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period;
                    sample_req <= '0';
                    sample_from_filter <= "00001000";
                    wait for 299*clk_period;
                    sample_req <= '1';
                    wait for clk_period; 
                    sample_req <= '0';                                                                               
                wait for 250*clk_period;
        wait for 600*clk_period;
        -- Cambiar SW para ver cambios en la salida
        SW <= "10";
        sample_from_filter <= "00000001";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000010";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000011";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000100";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000101";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000110";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00000111";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period;
                            sample_req <= '0';
                            sample_from_filter <= "00001000";
                            wait for 299*clk_period;
                            sample_req <= '1';
                            wait for clk_period; 
                            sample_req <= '0';                                                                               
                        wait for 250*clk_period;
        wait for 1500 * clk_period;
        SW <= "11";
        wait for 1500 * clk_period;
        -- Regresar SW
        SW <= "00";
        wait for 30 * clk_period;

        ------------------------------------------------------------
        -- Caso pausar reproducción (BTNC = '1' para alternar)
        ------------------------------------------------------------
        BTNC <= '1';
        wait for clk_period;
        BTNC <= '0';
        wait for 600 * clk_period;
        
        

        ------------------------------------------------------------
        -- Caso borrar audio (BTND = '0')
        ------------------------------------------------------------
        -- Suponemos que el botón BTND está normalmente en '1' y
        -- pasa a '0' para "delete".
        BTND <= '0';
        wait for clk_period;
        BTND <= '1';
        wait for clk_period;
        BTND <= '0';
        wait for 10 * clk_period;

        ------------------------------------------------------------
        -- Fin de la simulación
        ------------------------------------------------------------
        wait;
    end process;

end architecture;
