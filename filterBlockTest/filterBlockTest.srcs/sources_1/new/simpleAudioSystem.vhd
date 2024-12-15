----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2024 11:57:23
-- Design Name: 
-- Module Name: simpleAudioSystem - Behavioral
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

entity simpleAudioSystem is
  Port (
    clk_100Mhz : in STD_LOGIC;
    rst : in STD_LOGIC;
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
  );
end simpleAudioSystem;

architecture Behavioral of simpleAudioSystem is
component clk_12Mhz port (
    clk_12Mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_100Mhz : in STD_LOGIC);
end component;
signal clk_12Mhz_signal : STD_LOGIC;
signal sample_out_sample_in : STD_LOGIC_VECTOR ( sample_size - 1 downto 0);
signal sample_request : std_logic;
signal sample_out_ready : std_logic;
constant record_enable_CONST, play_enable_CONST : STD_LOGIC := '1';

begin
CLOCK_POTTER: clk_12Mhz PORT MAP (
    clk_12Mhz => clk_12Mhz_signal,
    reset => rst,
    clk_100Mhz => clk_100Mhz
);

AUDIO_INTERFACE_COMP : entity work.audioInterface(Behavioral) port map (
    clk_12Mhz => clk_12Mhz_signal,
    rst => rst,
    record_enable => record_enable_CONST,
    sample_out => sample_out_sample_in,
    sample_out_ready => sample_out_ready,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    play_enable => play_enable_CONST,
    sample_in => sample_out_sample_in,
    sample_request => sample_request,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm
);

end Behavioral;
