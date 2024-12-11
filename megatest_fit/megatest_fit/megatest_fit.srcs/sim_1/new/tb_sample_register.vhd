----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2024
-- Design Name: sampleRegister Testbench
-- Module Name: sampleRegister_tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   Testbench para el shift register sampleRegister. Probará la funcionalidad
--   introduciendo diversas muestras y observando cómo se desplazan a través
--   de las salidas s0, s1, s2, s3 y s4 a medida que se habilita sample_en.
--
--   Secuencia de prueba:
--     1. Aplicar reset y verificar salidas a 0.
--     2. Quitar reset y aplicar muestras con sample_en = '1' periódicamente.
--     3. Observar el desplazamiento por las salidas s0..s4 y la señal sen.
--
-- Dependencies:
--   sampleRegister.vhd
--   packageDSED.vhd (de donde se asume está definida sample_size)
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Se asume que sample_size se encuentra en este paquete
-- Ajustar el nombre del paquete según corresponda
use work.packageDSED.all;  

entity sampleRegister_tb is
end sampleRegister_tb;

architecture tb of sampleRegister_tb is

    -- Señales para conectar con el DUT
    signal clk_12Mhz_tb : std_logic := '0';
    signal rst_tb       : std_logic := '0';
    signal sample_in_tb : std_logic_vector(sample_size - 1 downto 0) := (others => '0');
    signal sample_en_tb : std_logic := '0';

    signal s0_tb, s1_tb, s2_tb, s3_tb, s4_tb : std_logic_vector(sample_size - 1 downto 0);
    signal sen_tb : std_logic;

    constant CLK_PERIOD : time := 20 ns;

    -- Instancia del DUT
    component sampleRegister is
        Port (
            clk_12Mhz : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            sample_in : in  STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_en : in  STD_LOGIC;
            s0        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            s1        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            s2        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            s3        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            s4        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sen       : out STD_LOGIC
        );
    end component;

begin

    DUT: sampleRegister
        port map(
            clk_12Mhz => clk_12Mhz_tb,
            rst       => rst_tb,
            sample_in => sample_in_tb,
            sample_en => sample_en_tb,
            s0        => s0_tb,
            s1        => s1_tb,
            s2        => s2_tb,
            s3        => s3_tb,
            s4        => s4_tb,
            sen       => sen_tb
        );

    -- Generación de reloj
    clk_process: process
    begin
        while true loop
            clk_12Mhz_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_12Mhz_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;


    stim_process: process
    begin
        -- Estado inicial
        rst_tb <= '1';
        sample_en_tb <= '0';
        sample_in_tb <= (others => '0');
        wait for 100 ns;

        -- Quitar reset
        rst_tb <= '0';
        wait for 2*CLK_PERIOD;

        -- Inyectar la primera muestra
        sample_in_tb <= (others => '0');  -- Primera muestra, 0
        sample_en_tb <= '1';
        wait for CLK_PERIOD;
        sample_en_tb <= '0';

        -- Esperar algunos ciclos
        wait for 3*CLK_PERIOD;

        -- Inyectar segunda muestra
        sample_in_tb <= (others => '1');  -- Siguiente muestra
        sample_en_tb <= '1';
        wait for CLK_PERIOD;
        sample_en_tb <= '0';

        wait for 3*CLK_PERIOD;

        -- Tercera muestra
        sample_in_tb <= (others => '1');
        sample_in_tb(sample_size - 1 downto 1) <= (others => '0'); -- Ej: "0000...0001"
        sample_en_tb <= '1';
        wait for CLK_PERIOD;
        sample_en_tb <= '0';

        wait for 3*CLK_PERIOD;

        -- Cuarta muestra
        sample_in_tb <= (others => '1');
        sample_in_tb(sample_size - 1) <= '1'; -- Ej: "1000...0001"
        sample_en_tb <= '1';
        wait for CLK_PERIOD;
        sample_en_tb <= '0';

        wait for 5*CLK_PERIOD;

        -- Quinta muestra
        sample_in_tb <= std_logic_vector(to_unsigned(128, sample_size)); -- Un valor distinto
        sample_en_tb <= '1';
        wait for CLK_PERIOD;
        sample_en_tb <= '0';

        wait for 5*CLK_PERIOD;

        -- Verificar que las muestras se han ido desplazando correctamente a través de s0..s4
        -- En este punto, las primeras muestras deberían haberse propagado hasta las salidas más alejadas.

        -- Finalizar simulación
        wait;
    end process;

end tb;
