-------------------------------------------------------------------------------
-- File       : DspXor.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2017-09-19
-- Last update: 2017-09-19
-------------------------------------------------------------------------------
-- Description: Generalized DSP inferred XOR, which can be used to help with 
--              performance when implementing FEC and CRC algorithms
-- Equation: p = XOR(a[i])
-------------------------------------------------------------------------------
-- This file is part of 'SLAC Firmware Standard Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'SLAC Firmware Standard Library', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;

entity DspXor is
   generic (
      TPD_G     : time                   := 1 ns;
      USE_DSP_G : string                 := "logic";
      WIDTH_G   : positive range 2 to 96 := 96);
   port (
      clk  : in  sl;
      -- Inbound Interface
      ain  : in  slv(WIDTH_G-1 downto 0);
      -- Outbound Interface
      pOut : out sl);
end DspXor;

architecture rtl of DspXor is

   type RegType is record
      p : sl;
   end record RegType;
   constant REG_INIT_C : RegType := (
      p => '0');

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   attribute use_dsp48      : string;
   attribute use_dsp48 of r : signal is USE_DSP_G;

   attribute dont_touch        : string;
   attribute dont_touch of rtl : architecture is "true";  -- prevent optimization from DSP to RTL

begin

   comb : process (ain, r) is
      variable v : RegType;
      variable a : signed(WIDTH_G-1 downto 0);
   begin
      -- Latch the current value
      v := r;

      -- typecast from slv to signed
      a := signed(ain);

      -- Process the data
      v.p := xor(a);

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs              
      pOut <= r.p;

   end process comb;

   seq : process (clk) is
   begin
      if rising_edge(clk) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end rtl;