%macro sysget(arg)/des="simplify macro calls to sysget";
  %let rc=%qsysfunc(sysget(&arg));
%mend sysget;
