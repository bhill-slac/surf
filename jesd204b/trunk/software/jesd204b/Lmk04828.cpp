//-----------------------------------------------------------------------------
// File          : Lmk04828.cpp
// Author        : Uros legat <ulegat@slac.stanford.edu>
//                            <uros.legat@cosylab.com>
// Created       : 27/04/2015
// Project       : 
//-----------------------------------------------------------------------------
// Description :
//    Device container for Lmk04828
//-----------------------------------------------------------------------------
// Copyright (c) 2015 by SLAC. All rights reserved.
// Proprietary and confidential to SLAC.
//-----------------------------------------------------------------------------
// Modification history :
// 27/04/2015: created
//-----------------------------------------------------------------------------
#include <Lmk04828.h>
#include <Register.h>
#include <RegisterLink.h>
#include <Variable.h>
#include <Command.h>
#include <sstream>
#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

// Constructor
Lmk04828::Lmk04828 ( uint32_t linkConfig, uint32_t baseAddress, uint32_t index, Device *parent, uint32_t addrSize ) : 
                        Device(linkConfig,baseAddress,"Lmk04828",index,parent) {
   uint32_t i;
   RegisterLink *rl;
   stringstream tmp; 
   
   Command      *c;
   
  // Description
   desc_ = "LMK data acquisition control";
   
   for (i=START_ADDR;i<=END_ADDR;i++) {
      tmp.str("");
      tmp << "LmkReg" << hex << setw(4) << setfill('0') << hex << i;
      addRegisterLink(rl = new RegisterLink(tmp.str(), (baseAddress_+ (i*addrSize)), Variable::Configuration));
      rl->getVariable()->setPerInstance(true);                                                                              
   }  

   // Variables
   getVariable("Enabled")->setHidden(true);
   
   //Commands
   // addCommand(c = new Command("TurnSysrefOff"));
   // c->setDescription("Powerdown the sysref lines.");
   
   // addCommand(c = new Command("TurnSysrefOn"));
   // c->setDescription("Powerup the sysref lines.");
}

// Deconstructor
Lmk04828::~Lmk04828 ( ) { }

// Process Commands
// void Lmk04828::command(string name, string arg) {
   // if (name == "TurnSysrefOff") syarefOff();
   // else if (name == "TurnSysrefOn") syarefOn();
   // else Device::command(name,arg);
// }

//! Powerdown the sysref lines.
// void Lmk04828::syarefOff () {

   // Register *r;
   
   // REGISTER_LOCK
   
   // r = getRegister("LmkReg0139");
   // r->set(0x0,0,0x3);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0106");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);

   // r = getRegister("LmkReg010e");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0116");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg011e");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0126");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg012e");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0136");
   // r->set(0x1,0,0x1);
   // writeRegister(r, true);
   
   // REGISTER_UNLOCK

// }

// //! Powerup the sysref lines.
// void Lmk04828::syarefOn () {

   // Register *r;
   
   // REGISTER_LOCK
   
   // r = getRegister("LmkReg0139");
   // r->set(0x3,0,0x3);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0106");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);

   // r = getRegister("LmkReg010e");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0116");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg011e");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0126");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg012e");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // r = getRegister("LmkReg0136");
   // r->set(0x0,0,0x1);
   // writeRegister(r, true);
   
   // REGISTER_UNLOCK
// }


