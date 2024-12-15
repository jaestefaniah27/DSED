library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_audioSystem is
end tb_audioSystem;

architecture test of tb_audioSystem is
    -- Señales para conectar al módulo bajo prueba
    signal clk_100Mhz   : std_logic := '0';
    signal rst          : std_logic := '0';
    signal BTNU         : std_logic := '0';
    signal BTND         : std_logic := '0';
    signal BTNL         : std_logic := '0';
    signal BTNC         : std_logic := '0';
    signal BTNR         : std_logic := '0';
    signal SW           : std_logic_vector(1 downto 0) := "00";
    signal micro_data   : std_logic := '0';
    signal micro_lr     : std_logic;
    signal jack_pwm     : std_logic;
    signal jack_sd      : std_logic;
    signal micro_clk    : std_logic;

    -- Período de reloj
    constant clk_period : time := 10 ns;

begin

    -- Instancia del módulo bajo prueba
    DUT: entity work.audioSystem
        port map(
            clk_100Mhz  => clk_100Mhz,
            rst         => rst,
            BTNU        => BTNU,
            BTND        => BTND,
            BTNL        => BTNL,
            BTNC        => BTNC,
            BTNR        => BTNR,
            SW          => SW,
            micro_lr    => micro_lr,
            micro_data  => micro_data,
            jack_pwm    => jack_pwm,
            jack_sd     => jack_sd,
            micro_clk   => micro_clk
        );

    -- Generación del reloj
    clk_process : process
    begin
        clk_100Mhz <= '1';
        wait for clk_period / 2;
        clk_100Mhz <= '0';
        wait for clk_period / 2;
    end process;
    pseudo_random_micro_data: process
        variable t : time := 0 ns;
    begin
        micro_data <= '0';
        wait for 1 ns;  -- Espera mínima
    
        -- Generación pseudoaleatoria
        t := t + 1 ns;
        micro_data <= std_logic(to_bit((t mod 1300 ns = 0 ns) xor (t mod 2100 ns = 0 ns) xor (t mod 3700 ns = 0 ns)));
    end process;

    -- Estímulos de prueba
    stim_process : process
    begin
        -- Reset inicial
        rst <= '1';
        wait for 5 * clk_period;
        rst <= '0';
        wait for 100 * clk_period
        -- Activar grabación (BTNL)
        BTNU <= '1';
        wait for 10000 * clk_period;
        BTNU <= '0';
        wait for 100 * clk_period;

        -- Cambiar switches para reproducción
        -- SW = "00": reproducción normal
        SW <= "00";
        BTNL <= '1';
        wait for 50 * clk_period;
        BTNL <= '0';
        wait for 12000 * clk_period; -- reproduccion completa
        BTNL <= '1';
        wait for 50* clk_period;
        BTNL <= '0'; --reproduccion de nuevo pero vamos a probar a pausar con BTNC
        wait for 3000 * clk_period;
        BTNC <= '1';
        wait for 50 * clk_period; -- pausa
        BTNC <= '0';
        wait for 3000 * clk_period;
        BTNC <= '1';
        wait for 50 * clk_period; -- continua reproduciendo
        BTNC <= '0';
        wait for 10000 * clk_period;
        -- SW = "10": reproducción en reversa
        SW <= "10";
        wait for 12000 * clk_period;
        
        BTNR <= '1';
        wait for 50 * clk_period;
        BTNR <= '0';
        wait for 12000 * clk_period;
        -- SW = "01": reproducción con filtro pasa bajos
        SW <= "01";
        wait for 12000 * clk_period;

        -- SW = "11": reproducción con filtro pasa altos
        BTNL <= '1';
        wait for 50 * clk_period;
        BTNL <= '0';
        SW <= "11";
        wait for 12000 * clk_period;

        -- Activar borrado de memoria (BTNC)
        BTND <= '1';
        wait for 20 * clk_period;
        BTND <= '0';

        -- Fin de la simulación
        wait;
    end process;

end architecture test;
