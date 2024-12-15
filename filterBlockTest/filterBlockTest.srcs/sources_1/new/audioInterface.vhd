----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2024 23:41:15
-- Design Name: 
-- Module Name: audioInterface - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- ------------------------------------------
-- Top file audioInterface . vhd
-- ------------------------------------------
-- Libs
entity audioInterface Is
port (
    clk_12Mhz : in STD_LOGIC;
    rst : in STD_LOGIC;
    -- Recording ports
    --To/ From the controller
    record_enable : in STD_LOGIC;
    sample_out : out STD_LOGIC_VECTOR ( sample_size - 1 downto 0);
    sample_out_ready : out STD_LOGIC;
    --To/ From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    -- Playing ports
    --To/ From the controller
    play_enable : in STD_LOGIC;
    sample_in : in STD_LOGIC_VECTOR ( sample_size - 1 downto 0);
    sample_request : out STD_LOGIC;
    --To/ From the mini - jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
) ;
end audioInterface;

architecture Behavioral of audioInterface is
signal en_2_cycles, en_4_cycles, micro_clk_enable, jack_PWM_enable, en_2_cycles_play_enable, en_4_cycles_play_enable : std_logic;
constant micro_LR_CONST, jack_sd_CONST : STD_LOGIC := '1';
begin
en_4_cycles_play_enable <= en_4_cycles and record_enable;
en_2_cycles_play_enable <= en_2_cycles and play_enable;

INPUT : entity work.inputMicrophone(Behavioral) port map (
        clk_12Mhz => clk_12Mhz,
        rst => rst,
        en_4_cycles => en_4_cycles_play_enable,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready);

OUTPUT : entity work.outputMicrophone(Behavioral) port map (
         clk_12Mhz => clk_12Mhz,
         rst => rst,
         en_2_cycles => en_2_cycles_play_enable,
         sample_in => sample_in,
         sample_request => sample_request,
         pwm_pulse => jack_PWM_enable);     

ENABLES : entity work.gen_enables(Behavioral) port map (
          clk_12Mhz => clk_12Mhz,
          rst => rst,
          clk_3MHz => micro_clk_enable,
          en_2_cycles => en_2_cycles,
          en_4_cycles => en_4_cycles);

micro_clk <= micro_clk_enable and record_enable;
jack_pwm <= jack_PWM_enable and play_enable;

micro_LR <= micro_LR_CONST;
jack_sd <= jack_sd_CONST; 
end Behavioral;
