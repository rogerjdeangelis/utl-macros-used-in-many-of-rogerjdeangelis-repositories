%macro utl_varlabel(dsn,var)/des="Variable label";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varlabel(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varlabel;
