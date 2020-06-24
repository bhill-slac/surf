-------------------------------------------------------------------------------
-- Title      : PgpEth: https://confluence.slac.stanford.edu/x/pQmODw
-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Wrapper on RogueStreamSim to simulate a PGP-ETH
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiStreamPkg.all;
use surf.PgpEthPkg.all;

entity RoguePgpEthSim is
   generic (
      TPD_G         : time                        := 1 ns;
      PORT_NUM_G    : natural range 1024 to 49151 := 9000;
      NUM_VC_G      : integer range 1 to 16       := 4;
      EN_SIDEBAND_G : boolean                     := true);
   port (
      -- GT Ports
      pgpRefClk       : in  sl;
      -- PGP Clock and Reset
      pgpClk          : out sl;
      pgpRst          : out sl;
      -- Non VC Rx Signals
      pgpRxIn         : in  PgpEthRxInType;
      pgpRxOut        : out PgpEthRxOutType;
      -- Non VC Tx Signals
      pgpTxIn         : in  PgpEthTxInType;
      pgpTxOut        : out PgpEthTxOutType;
      -- Frame Transmit Interface
      pgpTxMasters    : in  AxiStreamMasterArray(NUM_VC_G-1 downto 0);
      pgpTxSlaves     : out AxiStreamSlaveArray(NUM_VC_G-1 downto 0);
      -- Frame Receive Interface
      pgpRxMasters    : out AxiStreamMasterArray(NUM_VC_G-1 downto 0);
      pgpRxSlaves     : in  AxiStreamSlaveArray(NUM_VC_G-1 downto 0);
      -- AXI-Lite Register Interface (axilClk domain)
      axilClk         : in  sl                     := '0';  -- Stable Clock
      axilRst         : in  sl                     := '0';
      axilReadMaster  : in  AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
      axilReadSlave   : out AxiLiteReadSlaveType   := AXI_LITE_READ_SLAVE_EMPTY_OK_C;
      axilWriteMaster : in  AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
      axilWriteSlave  : out AxiLiteWriteSlaveType  := AXI_LITE_WRITE_SLAVE_EMPTY_OK_C);
end entity RoguePgpEthSim;

architecture sim of RoguePgpEthSim is

   signal clk : sl := '0';
   signal rst : sl := '1';

   signal txOut : PgpEthTxOutType := PGP_ETH_TX_OUT_INIT_C;
   signal rxOut : PgpEthRxOutType := PGP_ETH_RX_OUT_INIT_C;

begin

   pgpClk <= clk;
   pgpRst <= rst;

   pgpTxOut <= txOut;
   pgpRxOut <= rxOut;

   clk <= pgpRefClk;

   PwrUpRst_Inst : entity surf.PwrUpRst
      generic map (
         TPD_G          => TPD_G,
         IN_POLARITY_G  => '1',
         OUT_POLARITY_G => '1',
         DURATION_G     => 50)
      port map (
         clk    => clk,
         rstOut => rst);

   GEN_VEC : for i in NUM_VC_G-1 downto 0 generate
      U_PGP_VC : entity surf.RogueTcpStreamWrap
         generic map (
            TPD_G         => TPD_G,
            PORT_NUM_G    => (PORT_NUM_G + i*2),
            SSI_EN_G      => true,
            CHAN_COUNT_G  => 1,
            AXIS_CONFIG_G => PGP_ETH_AXIS_CONFIG_C)
         port map (
            axisClk     => clk,
            axisRst     => rst,
            sAxisMaster => pgpTxMasters(i),
            sAxisSlave  => pgpTxSlaves(i),
            mAxisMaster => pgpRxMasters(i),
            mAxisSlave  => pgpRxSlaves(i));
   end generate GEN_VEC;

   GEN_SIDEBAND : if (EN_SIDEBAND_G) generate
      U_RogueSideBandWrap_1 : entity surf.RogueSideBandWrap
         generic map (
            TPD_G      => TPD_G,
            PORT_NUM_G => PORT_NUM_G + 32)
         port map (
            sysClk     => clk,
            sysRst     => rst,
            txOpCode   => pgpTxIn.opCode(7 downto 0),
            txOpCodeEn => pgpTxIn.opCodeEn,
            txRemData  => pgpTxIn.locData(15 downto 8),
            rxOpCode   => rxOut.opCode(7 downto 0),
            rxOpCodeEn => rxOut.opCodeEn,
            rxRemData  => rxOut.remLinkData(15 downto 8));
   end generate GEN_SIDEBAND;

   txOut.phyTxActive <= '1';
   txOut.linkReady   <= '1';

   rxOut.phyRxActive    <= '1';
   rxOut.linkReady      <= '1';
   rxOut.remRxLinkReady <= '1';

end sim;