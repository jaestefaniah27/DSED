library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_driver is
    Port (
        clk_12Mhz : in STD_LOGIC;
        rst       : in STD_LOGIC;
        act_idx   : in STD_LOGIC_VECTOR (3 downto 0); -- �ndice actual de lectura
        fin_idx   : in STD_LOGIC_VECTOR (3 downto 0); -- Direcci�n de memoria
        LED       : out STD_LOGIC_VECTOR (15 downto 0); -- LEDs de salida
        playing, recording : in STD_LOGIC;
        LED16_B, LED16_G, LED16_R : out STD_LOGIC
    );
end LED_driver;

architecture Behavioral of LED_driver is

    -- Declaracion del contador PWM
    signal pwm_counter : unsigned(7 downto 0) := (others => '0');
    signal pwm_10_percent : STD_LOGIC := '0'; -- Se�al PWM para 10%

begin

    -- Proceso para generar el contador PWM
    process(clk_12Mhz, rst)
    begin
        if rising_edge(clk_12Mhz) then
            if rst = '1' then
                pwm_counter <= (others => '0'); -- Reiniciar el contador
            else
                pwm_counter <= pwm_counter + 1; -- Incrementar el contador
            end if;
        end if;
    end process;

    -- Proceso para generar una se�al PWM con ciclo de trabajo del 20%
    process(pwm_counter)
    begin
        if pwm_counter < 26 then -- 20% de 255 -> 51 (aproximadamente)
            pwm_10_percent <= '1';
        else
            pwm_10_percent <= '0';
        end if;
    end process;

    -- Proceso principal para controlar los LEDs
    process(clk_12Mhz, rst, playing, recording)
    begin
        if rst = '1' then
            LED16_B <= '0';
            LED16_G <= '0';
            LED16_R <= '0';
        elsif rising_edge(clk_12Mhz) then
            if recording = '1' then
                LED16_B <= pwm_10_percent; -- PWM aplicado al LED azul
                LED16_G <= '0';
                LED16_R <= '0';
            else    
                LED16_B <= '0';
                LED16_G <= playing and pwm_10_percent; -- PWM al LED verde                
                LED16_R <= not playing and pwm_10_percent; -- PWM al LED rojo
            end if;
        end if;
    end process;

    -- Proceso para el control de LEDs principales
    process(act_idx, fin_idx)
        variable act_temp, fin_temp : STD_LOGIC_VECTOR (15 downto 0);
    begin
        -- Generar LED = 2^x - 1
        act_temp := (others => '0');
        fin_temp := (others => '0');
        if (unsigned(act_idx) = 0) then 
            act_temp := (others => '0');
        else
            act_temp(to_integer(unsigned(act_idx) - 1) downto 0) := (others => '1');
        end if;
        fin_temp(to_integer(unsigned(fin_idx))) := '1';
        LED <= act_temp or fin_temp;
    end process;

end Behavioral;
