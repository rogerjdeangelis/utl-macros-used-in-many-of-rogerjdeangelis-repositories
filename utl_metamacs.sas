%macro utl_varnum(dsn,var)/des="Variable position mnumber in pdv";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varnum(&dsid,&var));
   %let rc = %sysfunc(close(&dsid));
%mend utl_varnum;
%macro utl_vartype(dsn,var)/des="Variable type returns N or C";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(vartype(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_vartype;
%macro utl_varlen(dsn,var)/des="Variable length";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varlen(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varlen;
%macro utl_varfmt(dsn,var)/des="Variable format";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varfmt(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varfmt;
%macro utl_varinfmt(dsn,var)/des="Variable informat";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varinfmt(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varinfmt;
%macro utl_varlabel(dsn,var)/des="Variable label";
  %local dsid posv rc;
   %let dsid = %sysfunc(open(&dsn,i));
   %let posv = %sysfunc(varnum(&dsid,&var));
   %sysfunc(varlabel(&dsid,&posv))
   %let rc = %sysfunc(close(&dsid));
%mend utl_varlabel;
%macro utl_varcount(dsn)/des="Number of variables";
  %local dsid posv rc;
    %let dsid = %sysfunc(open(&dsn,i));
    %sysfunc(attrn(&dsid,NVARS));
    %let rc = %sysfunc(close(&dsid));
%mend utl_varcount;
