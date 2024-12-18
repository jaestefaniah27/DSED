----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2024 00:30:12
-- Design Name: 
-- Module Name: tb_filterBlock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.packageDSED.all;


entity tb_firterBlock is
-- No ports para test benches
end tb_firterBlock;

architecture Behavioral of tb_firterBlock is

    -- Declaración del DUT (Device Under Test)
    component filterBlock
        Port (
            clk_12Mhz : in STD_LOGIC;
            rst       : in STD_LOGIC;
            sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
            sample_en : in STD_LOGIC;
            filterSelect : in STD_LOGIC;
            sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
            sample_out_ready : out STD_LOGIC
        );
    end component;

    -- Señales para conectar al DUT
    signal clk_12Mhz            : STD_LOGIC := '0';
    signal rst                  : STD_LOGIC := '0';
    signal sample_in            : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    signal sample_en            : STD_LOGIC := '0';
    signal filterSelect         : STD_LOGIC := '0';
    signal sample_out           : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    signal sample_out_ready     : STD_LOGIC;

    -- Constantes de simulación
    constant CLK_PERIOD : time := 83.33 ns; -- Frecuencia de 12 MHz

begin

    -- Instancia del DUT
    uut: filterBlock
        Port map (
            clk_12Mhz           => clk_12Mhz,
            rst                 => rst,
            sample_in           => sample_in,
            sample_en           => sample_en,
            filterSelect        => filterSelect,
            sample_out          => sample_out,
            sample_out_ready    => sample_out_ready
        );

    -- Generador de reloj
    clk_process: process
    begin
        clk_12Mhz <= '0';
        wait for CLK_PERIOD / 2;
        clk_12Mhz <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Proceso para aplicar estímulos
    stim_proc: process
    begin
        -- Reset inicial
        rst <= '1';

        -- Estímulos de entrada
        sample_in <= "00000000";
        wait for 2.5 * CLK_PERIOD ;
        rst <= '0';
        wait for 2 * CLK_PERIOD ;
        
        -- Comienzo de secuencia
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "01000000"; --0, 0.5
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "00010000"; -- 0, 0.125
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "00000000"; -- X= -1, 0.9921875, 0.0078125, -0.0078125
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;        
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;                
        sample_in <= "00000000";
        sample_en <= '1';
        wait for CLK_PERIOD;
        sample_en <= '0';
        wait for 20 * CLK_PERIOD;
        -- Finalización de la simulación
        wait;
    end process;

end Behavioral;
