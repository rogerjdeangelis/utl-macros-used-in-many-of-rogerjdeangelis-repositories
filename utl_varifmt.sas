%macro utl_varinfmt(dsn,var)/des="Variable informat";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varinfmt(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varinfmt;
