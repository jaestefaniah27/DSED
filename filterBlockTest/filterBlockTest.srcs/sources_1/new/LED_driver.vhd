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
signal led_reg, led_next : std_logic_vector(15 downto 0);
signal counter, counter_next : unsigned(3 downto 0);
begin

process(clk_12Mhz, rst, counter)
begin
if rst = '1' then
    counter <= (others=>'0');
    led_reg <= (others=>'0');
elsif rising_edge(clk_12Mhz) then
    counter <= counter_next;
    if (counter = 0) then
        led_reg <= led_next;
    end if;
end if; 
end process;
     
--next_state_logic
NEXT_STATE_LOGIC: process(counter)
begin
if (counter = "1111") then
    counter_next <= "0000";
else
    counter_next <= counter + 1;
end if;
end process;
-- output_logic
LED <= led_reg;
process(counter, act_idx, fin_idx)
begin
if  counter < unsigned(act_idx) or counter = unsigned(fin_idx) then --
    led_next(to_integer(counter)) <= '1';    
else
    led_next(to_integer(counter)) <= '0';
end if;
end process;
end Behavioral;
