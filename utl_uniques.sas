%macro utl_uniques(inp,out)
  /des="collapse to unique values";
 /*----
   %let inp=prdsale;
   %let out=want;
 ----*/
 %local recno;
 %put %sysfunc(ifc(%sysevalf(%superq(inp )=,boolean)
      ,**** Please provide inp dataset ****,));
 %put %sysfunc(ifc(%sysevalf(%superq(out )=,boolean)
      ,**** Please provide out dataset ****,));
  %let res= %eval
  (
      %sysfunc(ifc(%sysevalf(%superq(inp )=,boolean),1,0))
    + %sysfunc(ifc(%sysevalf(%superq(out )=,boolean),1,0))
  );
   %if &res = 0 %then %do;
      data _null_;
        /*---  levels for each column ----*/
        %dosubl('
          ods exclude all;
          ods output nlevels=nlevels;
          proc freq data=&inp nlevels;
          run;quit;
          ods exclude none;
          ods listing;
          proc sort data=nlevels;
            by descending nlevels;
          run;quit;
          ')
        set nlevels;
        call symputx("tablevar",tablevar);
        call symputx("recno",_n_);
        rc=dosubl('
          proc sql;
            create
              table &out  as
            select
              distinct &tablevar
           from
              &inp
           ;quit;
          %if &recno > 1 %then %do;
            data &out;
               merge
                 prewant(in=unq) &out ;
               if unq;
            run;quit;
          %end;
          data prewant;
            set &out;
          run;quit;
          ');
      run;quit;
   %end;
%mend utl_uniques;
