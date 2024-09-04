%macro utl_numary(_inp,drop=trt);
/*
 %let _inp=sd1.have;
 %let drop=i j;
*/
 %symdel _array / nowarn;
 %dosubl(%nrstr(
 filename clp clipbrd lrecl=64000;
 data _null_;
 file clp;
 set &_inp(drop=&drop) nobs=rows;
 array ns _numeric_;
 call symputx('rowcol',catx(',',rows,dim(ns)));
 put (_numeric_) ($) @@;
 run;quit;
 %put &=rowcol;
 data _null_;
 length res $32756;
 infile clp;
 input;
 res=cats("[&rowcol] (",translate(_infile_,',',' '),')');
 call symputx('_array',res);
 run;quit;
 ))
 &_array
%mend utl_numary;
