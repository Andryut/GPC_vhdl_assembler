////////////////////////////////////////////////////////////////////////////////
//   ____  ____   
//  /   /\/   /  
// /___/  \  /   
// \   \   \/  
//  \   \        Copyright (c) 2003-2004 Xilinx, Inc.
//  /   /        All Right Reserved. 
// /---/   /\     
// \   \  /  \  
//  \___\/\___\
////////////////////////////////////////////////////////////////////////////////

#ifndef H_Work_gpc_hvd_a_behavioral_H
#define H_Work_gpc_hvd_a_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_gpc_hvd_a_behavioral: public HSim__s6 {
public:

    HSim__s4 PE[1];
    HSim__s1 SE[8];

  HSimEnumType State_t;
  HSimArrayType Rom_mem_typebase;
  HSimArrayType Rom_mem_type;
  char *t0;
  HSimArrayType Ram_mem_typebase;
  HSimArrayType Ram_mem_type;
    HSim__s1 SA[8];
    Work_gpc_hvd_a_behavioral(const char * name);
    ~Work_gpc_hvd_a_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_gpc_hvd_a_behavioral(const char *name);

#endif
