library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_to_sseg_test is
  port(
    clk : in std_logic;
    sw : in std_logic_vector(7 downto 0);
    an : out std_logic_vector(3 downto 0);
    sseg : out std_logic_vector(7 downto 0)
  );
end hex_to_sseg_test;

architecture arch of hex_to_sseg_test is
  signal inc : std_logic_vector(7 downto 0);
  signal led0, led1, led2, led3 : std_logic_vector(7 downto 0);

begin
  inc <= std_logic_vector(unsigned(sw) + 1); -- increment input
  
  --instantiate 4 instances of hex decoders
  sseg_unit_0 : entity work.hex_to_sseg -- instance for 4 LSBs of input
    port map(hex => sw(3 downto 0), dp => '0', sseg => led0);
  
  sseg_unit_1 : entity work.hex_to_sseg -- instance for 4 MSBs of input
    port map(hex => sw(7 downto 4), dp => '0', sseg => led1);
    
  sseg_unit_2 : entity work.hex_to_sseg -- instance for 4 LSBs of incremented value
    port map(hex => inc(3 downto 0), dp => '1', sseg => led2);
    
  sseg_unit_3 : entity work.hex_to_sseg -- instance for 4 MSBs of incremented value
    port map(hex => inc(7 downto 4), dp => '1', sseg => led3);
    
  disp_unit : entity work.disp_mux -- instantiate 7-seg LED time-multiplexing module
    port map(
      clk => clk,
      reset => '0',
      in0 => led0,
      in1 => led1,
      in2 => led2,
      in3 => led3,
      an => an,
      sseg => seeg
    );
end arch;




