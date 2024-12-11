----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2024
-- Design Name: 
-- Module Name: tb_fir5stage
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Test bench para fir5stage
-- 
-- Dependencies: fir5stage.vhd
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


entity tb_fir5stage is
-- No ports para test benches
end tb_fir5stage;

architecture Behavioral of tb_fir5stage is

    -- Declaración del DUT (Device Under Test)
    component fir5stage
        Port (
            clk_12Mhz         : in STD_LOGIC;
            rst               : in STD_LOGIC;
            s0, s1, s2, s3, s4 : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sen               : in STD_LOGIC;
            c0, c1, c2, c3, c4 : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_out        : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_out_ready  : out STD_LOGIC
        );
    end component;

    -- Señales para conectar al DUT
    signal clk_12Mhz         : STD_LOGIC := '0';
    signal rst               : STD_LOGIC := '0';
    signal s0, s1, s2, s3, s4 : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    signal sen               : STD_LOGIC := '0';
    signal c0, c1, c2, c3, c4 : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    signal sample_out        : STD_LOGIC_VECTOR(sample_size - 1 downto 0);
    signal sample_out_ready  : STD_LOGIC;

    -- Constantes de simulación
    constant CLK_PERIOD : time := 83.33 ns; -- Frecuencia de 12 MHz

begin

    -- Instancia del DUT
    uut: fir5stage
        Port map (
            clk_12Mhz         => clk_12Mhz,
            rst               => rst,
            s0                => s0,
            s1                => s1,
            s2                => s2,
            s3                => s3,
            s4                => s4,
            sen               => sen,
            c0                => c0,
            c1                => c1,
            c2                => c2,
            c3                => c3,
            c4                => c4,
            sample_out        => sample_out,
            sample_out_ready  => sample_out_ready
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
        c0 <= "00000101";
        c1 <= "00011111";
        c2 <= "00111001";
        c3 <= "00011111";
        c4 <= "00000101";
        
        s0 <= "00000000";
        s1 <= "00000000";
        s2 <= "00000000";
        s3 <= "00000000";
        s4 <= "01000000";
        wait for 2.5 * CLK_PERIOD ;
        rst <= '0';
        wait for 2 * CLK_PERIOD ;
        s0 <= "00000000";

        sen <= '1';
        wait for CLK_PERIOD;

        sen <= '0';
        wait for 15 * CLK_PERIOD;

        -- Finalización de la simulación
        wait;
    end process;

end Behavioral;
