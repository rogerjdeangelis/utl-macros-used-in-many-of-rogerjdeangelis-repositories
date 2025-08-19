%macro utl_varcount(dsn)/des="Number of variables";
  %local dsid posv rc;
    %let dsid = %sysfunc(open(&dsn,i));
    %sysfunc(attrn(&dsid,NVARS))
    %let rc = %sysfunc(close(&dsid));
%mend utl_varcount;
