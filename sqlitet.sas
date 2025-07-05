%macro sqlitet(
   dbpath   = d:/sqlite/have.db
  ,inp      = students
  ,out      = want
) / des="import sqlite table to sas dataset";
%utlfkil(%sysfunc(pathname(work))/data.csv);
%utlfkil(%sysfunc(pathname(work))/meta.csv);
/*---- powershell ----*/
%utl_submit_ps64("
sqlite3 -csv '&dbpath'
  'select * from &inp'
   > '%sysfunc(pathname(work))/data.csv';
sqlite3 -header -csv '&dbpath'
  'PRAGMA table_info (&inp)'
   > '%sysfunc(pathname(work))/meta.csv';
");
proc import out=_meta_
 datafile="%sysfunc(pathname(work))/meta.csv"
 dbms=csv
 replace;
 getnames=YES;
 guessingrows=MAX;
run;quit;
proc format;
 value $maptyp
  'REAL'    = '32.'
  'INTEGER' = '32.'
  'TEXT'    = '$255.';
run;quit;
data _mapem_;
  set _meta_(keep=name type);
  typ=put(type,$maptyp.);
  drop type;
run;quit;
%array(_typ,data=_mapem_,var=typ);
%array(_nam,data=_mapem_,var=name);
data &out;
  informat
    %do_over(_nam _typ,phrase=?_nam ?_typ);;
  infile "%sysfunc(pathname(work))/data.csv" delimiter=',' missover;
  input
    %do_over(_nam,phrase=?);;
run;quit;
%arraydelete(_typ)
%arraydelete(_nam)
/*---- optimize variable lengths ----*/
%utl_optlenpos(&out,&out);
%mend sqlitet;
