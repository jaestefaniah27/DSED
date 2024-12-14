----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024
-- Design Name: contador_3bits
-- Module Name: contador_3bits_tb - Testbench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   Testbench para el m�dulo contador_3bits. Se generar�n se�ales de clk, rst y sen
--   para verificar el comportamiento de la l�gica. Este testbench probar�:
--     1. Reset as�ncrono.
--     2. Habilitaci�n del contador con sen.
--     3. Conteo normal y se�al sample_out_ready cuando se alcanza el valor especificado.
--     4. Correcta salida de mux_sel.
--
-- Dependencies:
--   contador_3bits.vhd
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_3bits_tb is
end contador_3bits_tb;

architecture tb of contador_3bits_tb is

    -- Se�ales para conectar con el DUT
    signal clk_tb             : std_logic := '0';
    signal rst_tb             : std_logic := '0';
    signal sen_tb             : std_logic := '0';
    signal mux_sel_tb         : std_logic_vector(2 downto 0);
    signal sample_out_ready_tb: std_logic;

    -- Constantes para el reloj
    constant CLK_PERIOD : time := 20 ns;

    -- Instanciaci�n del DUT
    component contador_3bits is
        Port (
            clk              : in  STD_LOGIC;
            rst              : in  STD_LOGIC;
            sen              : in  STD_LOGIC;
            mux_sel          : out STD_LOGIC_VECTOR(2 downto 0);
            sample_out_ready : out std_logic
        );
    end component;

begin

    DUT: contador_3bits
        port map (
            clk              => clk_tb,
            rst              => rst_tb,
            sen              => sen_tb,
            mux_sel          => mux_sel_tb,
            sample_out_ready => sample_out_ready_tb
        );

    -- Generaci�n del reloj
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Proceso de estimulaci�n
    stim_process: process
    begin
        -- Estado inicial
        rst_tb <= '0';
        sen_tb <= '0';
        wait for 100 ns;

        -- 1. Probar reset as�ncrono
        rst_tb <= '1';
        wait for 50 ns;
        rst_tb <= '0';
        -- En este punto el contador deber�a estar en "000" y sin habilitar

        -- 2. No se habilita el contador: sen = '0'
        -- El contador no debe cambiar mux_sel. Espero unos ciclos.
        wait for 5*CLK_PERIOD;

        -- 3. Habilitar el contador con sen = '1'. Esto debe iniciar el conteo en el siguiente flanco de reloj.
        sen_tb <= '1';
        wait for CLK_PERIOD;
        -- Despu�s de este ciclo, count_enable_reg se pone a '1', pero el conteo comienza en el siguiente ciclo
        sen_tb <= '0';
        wait for 10*CLK_PERIOD;

        -- En este punto el contador debe haber contado y al llegar a "110" (6) y luego intentar "111" (7)
        -- deber�a activar sample_out_ready en el momento oportuno.
        -- Verificar que mux_sel ha contado correctamente desde "000" a "110".
        -- Tras pasar "110" a "111", sample_out_ready deber�a ponerse en '1' por un ciclo.

        -- 4. Verificar reset de nuevo en medio del conteo
        rst_tb <= '1';
        wait for 50 ns;
        rst_tb <= '0';
        -- El contador vuelve a "000". Esperar algunos ciclos sin habilitarlo.
        wait for 5*CLK_PERIOD;

        -- 5. Habilitar de nuevo el conteo y dejarlo contar hasta alcanzar de nuevo la condici�n de salida.
        sen_tb <= '1';
        wait for CLK_PERIOD;
        sen_tb <= '0';
        wait for 10*CLK_PERIOD;

        -- Finaliza la simulaci�n
        wait;
    end process;

end tb;
