/* === Author's macro (from iotan.sas) === */
%macro iotan(too,from=1,by=1,delim=);
  %local idx res;
  %do idx=&from %to &too %by &by;
   %if &idx ^= &too %then %do;
        %let res=&res &idx &delim;
   %end;
   %else %do;
       %let res=&res &idx;
   %end;
  %end;
   %if &delim = %then %do;
      %sysfunc(compbl(&res))
   %end;
   %else %do;
       %sysfunc(compress(&res))
   %end;
%mend iotan;

/* === Caller: build a few delimited number lists === */
%let r_default = %iotan(5);
%let r_evens   = %iotan(10, from=2, by=2);
%let r_csv     = %iotan(5, delim=%str(,));

data _null_;
  put "iotan_default=&r_default";
  put "iotan_evens=&r_evens";
  put "iotan_csv=&r_csv";
run;
