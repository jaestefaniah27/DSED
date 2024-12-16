library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LED_driver is
    Port (
        clk_12Mhz : in STD_LOGIC;
        rst : in STD_LOGIC;
        act_idx : in STD_LOGIC_VECTOR (3 downto 0); -- Índice actual de lectura
        fin_idx : in STD_LOGIC_VECTOR (3 downto 0); -- Dirección de memoria
        LED : out STD_LOGIC_VECTOR (15 downto 0)     -- LEDs de salida
    );
end LED_driver;

architecture Behavioral of LED_driver is
begin
    process(act_idx, fin_idx)
        variable act_temp, fin_temp : STD_LOGIC_VECTOR (15 downto 0);
    begin
        -- Generar LED = 2^x - 1
        act_temp := (others => '0');
        fin_temp := (others => '0');
        if (unsigned(act_idx ) = 0) then act_temp := (others=>'0'); else
            act_temp(to_integer(unsigned(act_idx) - 1) downto 0) := (others => '1');
        end if;
            fin_temp(to_integer(unsigned(fin_idx))) := '1';
        LED <= act_temp or fin_temp;
    end process;
end Behavioral;
