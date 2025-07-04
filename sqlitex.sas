%macro sqlitex(
   dbpath   = d:/sqlite/have.db
  ,inp      = students
  ,out      = want
) / des="import sqlite table sas dataset";
proc datasets lib=work
  nolist nodetails;
 delete want;
run;quit;
%utlfkil(%sysfunc(pathname(work))/want.csv);
/*---- powershell ----*/
%utl_submit_ps64("
sqlite3 -csv -header '&dbpath'
  'select * from &inp;'
   > '%sysfunc(pathname(work))/want.csv';
");
proc import out=want
    datafile="d:/csv/want.csv"
    dbms=csv
    replace;
    getnames=YES;
    guessingrows=MAX;
run;quit;
%mend sqlitex;
