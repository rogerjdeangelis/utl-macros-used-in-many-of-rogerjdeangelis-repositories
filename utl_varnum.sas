%macro utl_varnum(dsn,var)/des="Variable position mnumber in pdv";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varnum(&dsid,&var));
   %let rc = %sysfunc(close(&dsid));
%mend utl_varnum;
