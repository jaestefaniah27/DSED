----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2024 13:14:41
-- Design Name: 
-- Module Name: inputMicrophone_tb - Behavioral
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
use work.packageDSED.all;
use IEEE.NUMERIC_STD.ALL;

entity outputMicrophone_tb is
end outputMicrophone_tb;

architecture Behavioral of outputMicrophone_tb is
    SIGNAL clk_12Mhz        : STD_LOGIC := '1' ;
    SIGNAL rst              : STD_LOGIC := '1' ;
    SIGNAL sample_request   : STD_LOGIC;
    SIGNAL sample_in        : STD_LOGIC_VECTOR(sample_size -1 downto 0) := (others=>'0');
    SIGNAL pwm_pulse        : STD_LOGIC;
    SIGNAL en_2_cycles      : STD_LOGIC;
    -- Periodo del reloj de 12 MHz (83.33 ns)
    CONSTANT clk_period : time := 83.33 ns;

    component outputMicrophone port(
        clk_12Mhz : in STD_LOGIC;
        rst : in STD_LOGIC;
        en_2_cycles : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_request : out STD_LOGIC;        
        pwm_pulse : out STD_LOGIC);
    end component;
    
    component gen_enables port (
           clk_12Mhz : in STD_LOGIC ;
           rst : in STD_LOGIC ;
           clk_3MHz : out STD_LOGIC ;
           en_2_cycles : out STD_LOGIC ;
           en_4_cycles : out STD_LOGIC);
        end component;
begin

LYC: outputMicrophone
    port map (
        clk_12Mhz => clk_12Mhz,
        rst => rst,
        en_2_cycles => en_2_cycles,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => pwm_pulse
    );
DUT: gen_enables
    PORT MAP (
        clk_12Mhz => clk_12Mhz,
        rst => rst,
        clk_3MHz => open,
        en_2_cycles => en_2_cycles,
        en_4_cycles => open
    );
    -- Generación del reloj de 12 MHz
    clk_process: process
    begin
        clk_12Mhz <= '1';
        wait for clk_period / 2;
        clk_12Mhz <= '0';
        wait for clk_period / 2;
    end process;

    -- Proceso para simular el reset y observar las salidas
    stim_proc: process
    begin	
        -- Inicialización del reset
        rst <= '1';
        wait for 500 ns;
        rst <= '0';

        -- Probar valores extremos e intermedios
        sample_in <= "00000000";
        wait for 600 * clk_period; -- Espera varios ciclos
        sample_in <= "11111111";
        wait for 600 * clk_period;
        sample_in <= "10011001"; -- Valor intermedio
        wait for 600 * clk_period;
                sample_in <= "00000000"; -- Mínimo valor
        wait for 600 * clk_period;
        sample_in <= "11111111"; -- Máximo valor
        wait for 600 * clk_period;
        sample_in <= "10011001"; -- Valor intermedio alto
        wait for 600 * clk_period;
        sample_in <= "01100110"; -- Valor intermedio bajo
        wait for 600 * clk_period;
        sample_in <= "10101010"; -- Patrón alternado alto-bajo
        wait for 600 * clk_period;
        sample_in <= "01010101"; -- Patrón alternado bajo-alto
        wait for 600 * clk_period;
        sample_in <= "11000011"; -- Mayoría de bits altos
        wait for 600 * clk_period;
        sample_in <= "00111100"; -- Mayoría de bits bajos
        wait for 600 * clk_period;
        sample_in <= "11110000"; -- Mitad alta, mitad baja
        wait for 600 * clk_period;
        sample_in <= "00001111"; -- Mitad baja, mitad alta
        wait for 600 * clk_period;
        sample_in <= "10000001"; -- Extremos altos, resto bajo
        wait for 600 * clk_period;
        sample_in <= "01111110"; -- Extremos bajos, resto alto
        wait for 600 * clk_period;
        sample_in <= "11010101"; -- Patrón aleatorio
        wait for 600 * clk_period;
        sample_in <= "00101010"; -- Patrón inverso aleatorio
        wait for 600 * clk_period;

        sample_in <= "00000000";
        wait for 600 * clk_period; -- Espera varios ciclos

        -- Terminar la simulación
        wait;
    end process;

end Behavioral;
