%macro utl_numary(_inp,drop=,reshape=0)
   /des="load all character data into a in memory array or drop some vars and then load";
/*
 %let _inp=sd1.have;
 %let drop=i j;
*/
 %local rolcol;
 %symdel _array / nowarn;
 %dosubl(%nrstr(
 %put xxxxxxxx &=reshape xxxxxxxxxxxx;
 filename clp clipbrd lrecl=64000;
 data _null_;
 file clp;
 set &_inp(drop=_character_ &drop) nobs=rows;
 array ns _numeric_;
 call symputx('rowcol',catx(',',rows,dim(ns)));
 put (_numeric_) ($) @@;
 run;quit;
 %put &=rowcol;
 data _null_;
 length res $32756;
 infile clp;
 input;
 if "&reshape"="0" then do;
   res=cats("[&rowcol] (",translate(_infile_,',',' '),')');
   call symputx('_array',res);
 end;
 else do;
   res=cats("&reshape (",translate(_infile_,',',' '),')');
   call symputx('_array',res);
 end;
 run;quit;
 ))
 &_array
%mend utl_numary;
