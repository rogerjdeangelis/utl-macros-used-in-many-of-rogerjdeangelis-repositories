%macro utl_varfmt(dsn,var)/des="Variable format";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varfmt(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varfmt;
