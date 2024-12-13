----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 12:56:57
-- Design Name: 
-- Module Name: controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           sample_from_micro : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_micro_ready : in STD_LOGIC;
           rec_en : out STD_LOGIC;
           play_en : out STD_LOGIC;
           to_jack : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_req : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           din : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           dout : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           wea : out STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_to_filter : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_to_filter_en : out STD_LOGIC;
           sample_from_filter : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_filter_ready : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (1 downto 0));
end controller;

architecture Behavioral of controller is
type state_type is (IDLE, RECORDING, SAVING, PLAY);
signal state, next_state : state_type;
signal act_idx, fin_idx, act_idx_next, fin_idx_next  : std_logic_vector(18 downto 0);
signal direction, direction_next : signed(18 downto 0);
signal saving_counter, saving_counter_next : unsigned(1 downto 0);
begin
addr <= act_idx;
rec_en <= '0';
play_en <= '0';
--registers
process(clk_12Mhz, rst)
begin
if (rst = '1') then
    act_idx <= (others=>'0');
    fin_idx <= (others=>'0');
    direction <= (others=>'0');
    state <= IDLE;
    saving_counter <= (others=>'0');
elsif rising_edge(clk_12Mhz) then
    act_idx <= act_idx_next;
    fin_idx <= fin_idx_next;
    direction <= direction_next;
    state <= next_state;
    saving_counter <= saving_counter_next;    
end if;
end process;

--btn process
PROCESS_NEXT_STATE: process(state, BTNU, BTND, BTNR, BTNC, BTNL, sample_from_micro_ready, saving_counter)
begin
case (state) is
    when IDLE =>
        if (BTNU = '1') then
            next_state <= RECORDING;
        elsif (BTNL = '1') then
            next_state <= PLAY;
            direction_next <= to_signed(1, 19);
            act_idx_next <= (others=>'0');
        elsif (BTNR = '1') then
            next_state <= PLAY;
            direction_next <= to_signed(-1, 19);
            act_idx_next <= (others=>'0');
        else 
            next_state <= IDLE;            
        end if;
    when RECORDING =>
    if(BTNU = '1') then
        if (sample_from_micro_ready = '1') then
            next_state <= SAVING;
        else 
            next_state <= RECORDING;
            saving_counter_next <= (others=>'0');
        end if;
    else next_state <= IDLE;
    end if;
    when SAVING =>
    if (saving_counter < 3) then
        next_state <= SAVING;
    elsif (BTNU = '1') then
        next_state <= RECORDING;
    else next_state <= IDLE;
    end if;
    when PLAY =>
    if (BTNL = '1') then
        direction_next <= to_signed(1, 19);
        act_idx_next <= (others=>'0');
    elsif (BTNR = '1') then
        direction_next <= to_signed(-1, 19);
    elsif (BTNC = '1') then
        next_state <= IDLE;
    else next_state <= PLAY;
    end if;
end case;
end process;

PROCESS_SAVING: process(state, saving_counter)
begin
if state = SAVING then
    din <= sample_from_micro;
    if saving_counter = 0 then
        -- CONTINUAR AQUI
    end if;
end if;
end process;

end Behavioral;
