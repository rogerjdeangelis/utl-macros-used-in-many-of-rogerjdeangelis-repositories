%macro utl_vartype(dsn,var)/des="Variable type returns N or C";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(vartype(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_vartype;
