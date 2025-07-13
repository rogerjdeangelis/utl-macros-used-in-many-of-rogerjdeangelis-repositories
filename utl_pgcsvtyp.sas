%macro utl_pgcsvtyp(
   meta    = work.meta
  ,datacsv = c:/temp/statscsv.csv
  ,out     = statstyp
   ) / des="import sqlite table to sas dataset";
   /*----
     %let meta    = work.meta;
     %let datacsv = c:/temp/statscsv.csv;
     %let out     = statstyp;
   ----*/
   proc format;
    value $maptyp
     'double precision'    = '32.'
     'character varying'    = '$255.';
   run;quit;
   data _mapem_;
     set &meta ;
     typ=put(data_type,$maptyp.);
     drop data_type;
   run;quit;
   %array(_typ,data=_mapem_,var=typ);
   %array(_nam,data=_mapem_,var=column_name);
   data &out;
     informat
       %do_over(_nam _typ,phrase=?_nam ?_typ);
     infile "&datacsv" delimiter=',' firstobs=2;
     input
       %do_over(_nam,phrase=?);;
   run;quit;
   %arraydelete(_typ)
   %arraydelete(_nam)
   /*---- optimize variable lengths ----*/
   %utl_optlenpos(&out,&out);
%mend utl_pgcsvtyp;
