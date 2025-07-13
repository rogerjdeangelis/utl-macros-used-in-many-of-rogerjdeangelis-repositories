%macro utl_sqcsvtyp(
     metacsv=c:/temp/sqmeta.csv
    ,out    =statsopt
    ,datacsv=c:/temp/sqstats.csv
    )/des  ="map sqlite types to sas types";
proc datasets lib=work;
 delete _mapem_ &out _meta_;
run;quit;
dm "dimport '&metacsv' _meta_  replace";
proc format;
 value $maptyp
  'REAL'    = '32.'
  'INTEGER' = '32.'
  'TEXT'    = '$255.'
   OTHER    = '32.'
;
run;quit;
data _mapem_;
  set _meta_(keep=name type);
  typ=put(type,$maptyp.);
  drop type;
run;quit;
%array(_typ,data=_mapem_,var=typ);
%array(_nam,data=_mapem_,var=name);
%put &=_typ1;
%put &=_nam1;
data &out;
  informat
    %do_over(_nam _typ,phrase=?_nam ?_typ);;
  infile "&datacsv" delimiter=',' firstobs=2;
  input
    %do_over(_nam,phrase=?);;
run;quit;
%arraydelete(_typ)
%arraydelete(_nam)
/*---- optimize variable lengths ----*/
%utl_optlenpos(&out,&out);
proc print data=&out;
title "output table is &out";
run;quit;
%mend utl_sqcsvtyp;
