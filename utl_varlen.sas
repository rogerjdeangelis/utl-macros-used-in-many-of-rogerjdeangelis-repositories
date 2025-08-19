%macro utl_varlen(dsn,var)/des="Variable length";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varlen(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varlen;
