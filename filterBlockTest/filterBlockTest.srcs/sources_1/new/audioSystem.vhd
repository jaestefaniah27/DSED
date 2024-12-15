----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2024 17:11:31
-- Design Name: 
-- Module Name: audioSystem - Behavioral
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

entity audioSystem is
    Port ( clk_100Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (1 downto 0);
           micro_lr : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           micro_clk : out STD_LOGIC);
end audioSystem;

architecture Behavioral of audioSystem is
component audioInterface Is
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
    jack_pwm : out STD_LOGIC);
end component;

component clk_12Mhz port (
    clk_12Mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    clk_100Mhz : in STD_LOGIC);
end component;

component filterBlock is Port(
        clk_12Mhz : in STD_LOGIC;
        rst       : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_en : in STD_LOGIC;
        filterSelect : in STD_LOGIC;
        sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_out_ready : out STD_LOGIC);
end component;

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0));
end component;

component controller is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           sample_from_micro : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_micro_ready : in STD_LOGIC;
           rec_en : out STD_LOGIC;
           play_en : out STD_LOGIC;
           sample_req : in STD_LOGIC;
           to_jack : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           din, dout : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           we : out STD_LOGIC_VECTOR(0 downto 0);
           filter_select : out STD_LOGIC;
           sample_to_filter : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_to_filter_en : out STD_LOGIC;
           sample_from_filter : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_filter_en : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR(1 downto 0);
           BTNU, BTND, BTNC, BTNR, BTNL : in STD_LOGIC);
end component;

signal sample_from_micro, to_jack, sample_to_filter, sample_from_filter, din, dout : std_logic_vector(sample_size - 1 downto 0);
signal sample_from_micro_ready, rec_en, play_en, sample_req, filter_select, sample_to_filter_en, sample_from_filter_en, clk_12Mhz_signal : std_logic;
signal addr : std_logic_vector(18 downto 0);
signal we : std_logic_vector(0 downto 0);
begin

    u_clk_12Mhz : clk_12Mhz
        port map (
            clk_12Mhz  => clk_12Mhz_signal,
            reset      => rst,
            clk_100Mhz => clk_100Mhz
        );

    u_audioInterface : audioInterface
        port map (
            clk_12Mhz        => clk_12Mhz_signal,
            rst              => rst,
            record_enable    => rec_en,
            sample_out       => sample_from_micro,
            sample_out_ready => sample_from_micro_ready,
            micro_clk        => micro_clk,    
            micro_data       => micro_data,    
            micro_LR         => micro_LR,    
            play_enable      => play_en,
            sample_in        => to_jack,
            sample_request   => sample_req,
            jack_sd          => jack_sd,    
            jack_pwm         => jack_pwm     
        );

    u_filterBlock : filterBlock
        port map (
            clk_12Mhz         => clk_12Mhz_signal,
            rst               => rst,
            sample_in         => sample_to_filter,
            sample_en         => sample_to_filter_en,
            filterSelect      => filter_select,
            sample_out        => sample_from_filter,
            sample_out_ready  => sample_from_filter_en
        );

    u_blk_mem_gen_0 : blk_mem_gen_0
        port map (
            clka   => clk_12Mhz_signal,
            rsta   => rst,
            wea    => we,
            addra  => addr,
            dina   => din,
            douta  => dout
        );

    u_controller : controller
        port map(
            clk_12Mhz               => clk_12Mhz_signal,
            rst                     => rst,
            sample_from_micro       => sample_from_micro,
            sample_from_micro_ready => sample_from_micro_ready,
            rec_en                  => rec_en,
            play_en                 => play_en,
            sample_req              => sample_req,
            to_jack                 => to_jack,
            addr                    => addr,
            din                     => din,
            dout                    => dout,
            we                      => we,
            filter_select           => filter_select,
            sample_to_filter        => sample_to_filter,
            sample_to_filter_en     => sample_to_filter_en,
            sample_from_filter      => sample_from_filter,
            sample_from_filter_en   => sample_from_filter_en,
            SW                      => SW,  
            BTNU                    => BTNU,   
            BTND                    => BTND,  
            BTNC                    => BTNC,  
            BTNR                    => BTNR,  
            BTNL                    => BTNL   
        );

end Behavioral;
