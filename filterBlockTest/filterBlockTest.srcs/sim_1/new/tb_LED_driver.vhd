library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_driver_tb is
    -- No puertos en el testbench
end LED_driver_tb;

architecture Behavioral of LED_driver_tb is

    -- Declaración del componente bajo prueba (UUT)
    component LED_driver
        Port (
            clk_12Mhz : in STD_LOGIC;
            rst : in STD_LOGIC;
            act_idx : in STD_LOGIC_VECTOR (3 downto 0);
            fin_idx : in STD_LOGIC_VECTOR (3 downto 0);
            LED : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Señales para conectar al UUT
    signal clk_12Mhz : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal act_idx_19, act_idx_next_19 : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    signal fin_idx_19, fin_idx_next_19 : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    signal act_idx, fin_idx : std_logic_vector(3 downto 0);
    signal LED : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Período del reloj
    constant clk_period : time := 83.333 ns; -- 12 MHz = 83.333 ns
    constant sample_period : time := 50 us;
begin
act_idx <= act_idx_19(18 downto 15);
fin_idx <= fin_idx_19(18 downto 15);
    -- Instancia del UUT
    uut: LED_driver
        Port map (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            act_idx => act_idx,
            fin_idx => fin_idx,
            LED => LED
        );

    -- Generación de reloj
    clk_process : process
    begin
        while true loop
            clk_12Mhz <= '1';
            wait for clk_period / 2;
            clk_12Mhz <= '0';
            wait for clk_period / 2;
        end loop;
    end process;
    act_idx_process : process
    begin        
        act_idx_next_19 <= std_logic_vector(unsigned(act_idx_19) + 32);
        wait for sample_period;
        act_idx_19 <= act_idx_next_19;        
        wait for clk_period;
    end process;

    fin_idx_process : process
    begin        
        fin_idx_next_19 <= std_logic_vector(unsigned(fin_idx_19) + 50);
        wait for sample_period;
        fin_idx_19 <= fin_idx_next_19;        
        wait for clk_period;
    end process;    
    -- Proceso de estímulos
    stimulus_process: process
    begin
        -- Caso 1: Reset del sistema
        rst <= '1';
        wait for 2 * clk_period;
        rst <= '0';
        wait for 2 * clk_period;

--        -- Caso 2: act_idx = 0, fin_idx = "0000000000000000001"
--        act_idx <= (others => '0'); -- Barra de progreso vacía
--        fin_idx <= "0001"; -- LED más significativo en bit 0
--        wait for 30 * clk_period;

--        -- Caso 3: act_idx = "0000000000000000111", fin_idx = "0000000000001000000"
--        act_idx <= "0011"; -- Barra de progreso hasta bit 7
--        fin_idx <= "0011"; -- LED más significativo en bit 10
--        wait for 30 * clk_period;

--        -- Caso 4: act_idx = "1000000000000000000", fin_idx = "1100000000000000000"
--        act_idx <= "1000"; -- Barra de progreso en bit 18
--        fin_idx <= "1100"; -- LED más significativo en bit 18
--        wait for 30 * clk_period;

--        -- Caso 5: act_idx = "0000000000000000000", fin_idx = "1111111111111111111"
--        act_idx <= (others => '0'); -- Barra de progreso vacía
--        fin_idx <= "1111"; -- LED más significativo en bit 18
--        wait for 30 * clk_period;

--        -- Terminar la simulación
        wait;
    end process;

end Behavioral;
