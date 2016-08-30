-------------------------------------------------------------------------------
-- Title      : Front End Interface Package
-------------------------------------------------------------------------------
-- File       : FrontEndPkg.vhd
-- Author     : Benjamin Reese  <bareese@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2012-05-03
-- Last update: 2012-09-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Port types for Generic Front End interface
-------------------------------------------------------------------------------
-- Copyright (c) 2012 SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.StdRtlPkg.all;

package FrontEndPkg is

  -- Register Interface
  type FrontEndRegCntlInType is record
    regAck    : sl;
    regFail   : sl;
    regDataIn : slv(31 downto 0);
  end record FrontEndRegCntlInType;

  type FrontEndRegCntlOutType is record
    regInp     : sl;                    -- Operation in progress
    regReq     : sl;                    -- Request reg transaction
    regOp      : sl;                    -- Read (0) or write (1)
    regAddr    : slv(23 downto 0);      -- Address
    regDataOut : slv(31 downto 0);      -- Write Data
  end record FrontEndRegCntlOutType;

  -- Command Interface
  type FrontEndCmdCntlOutType is record
    cmdEn     : sl;                     -- Command available
    cmdOpCode : slv(7 downto 0);        -- Command Op Code
    cmdCtxOut : slv(23 downto 0);       -- Command Context
  end record FrontEndCmdCntlOutType;

  -- Upstream Data Buffer Interface
  type FrontEndUsDataOutType is record
    frameTxAfull : sl;
  end record FrontEndUsDataOutType;

  type FrontEndUsDataInType is record
    frameTxEnable : sl;
    frameTxSOF    : sl;
    frameTxEOF    : sl;
    frameTxEOFE   : sl;
    frameTxData   : slv(63 downto 0);
  end record FrontEndUsDataInType;

end package FrontEndPkg;