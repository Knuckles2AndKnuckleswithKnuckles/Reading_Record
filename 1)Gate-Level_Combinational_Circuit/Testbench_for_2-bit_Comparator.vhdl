library ieee;
use ieee.std_logic_1164.all;

entity eq2_testbench is
end eq2_testbench;

architecture tb_arch of eq2_testbench is
  signal test_in0, test_in1: std_logic_vector(1 downto 0);
  signal test_out: std_logic;

begin
  -- instantiate the sircuit under test
  uut: entity work.eq2(struc_arch)
    port map( a => test_in0, b => test_in1, aeqb => test_out );
    
  -- test vector generator
  proces
  begin
    -- test vector 1
    test_in0 <= "00";
    test_in1 <= "00";
    wait for 200ns;
    
    -- test vector 2
    test_in0 <= "01";
    test_in1 <- "00";
    wait for 200ns;
    
    -- test vector 3
    
