%macro utl_odstab(outdsn,datarow=1);

   %if %qupcase(&outdsn)=SETUP %then %do;

        filename _tmp1_ clear;  * just in case;

        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);

        filename _tmp1_ "%sysfunc(pathname(work))/_tmp1_.txt";

        %let _ps_= %sysfunc(getoption(ps));
        %let _fc_= %sysfunc(getoption(formchar));

        OPTIONS ls=max ps=32756  FORMCHAR='|'  nodate nocenter;

        title; footnote;

        proc printto print=_tmp1_;
        run;quit;

   %end;
   %else %do;

        /* %let outdsn=tst; %let datarow=3; */

        proc printto;
        run;quit;

        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);

        *filename _tmp2_  "%sysfunc(pathname(work))/_tmp2_.txt";

        proc datasets lib=work nolist;  *just in case;
         delete &outdsn;
        run;quit;

        proc printto print="%sysfunc(pathname(work))/_tmp2_.txt";
        run;quit;

        data _null_;
          retain n 0;
          infile _tmp1_ length=l;
          input lyn $varying32756. l;
          if _n_=1 then do;
              file print titles;
              putlog lyn;
              *put lyn;
          end;
          else do;
             if countc(lyn,'|')>2;
             n=n+1;
             if n ge %eval(&datarow + 1) then do;
                file print;
                putlog lyn;
                put lyn;
             end;
          end;
        run;quit;

        proc printto;
        run;quit;

        proc import
           datafile="%sysfunc(pathname(work))/_tmp2_.txt"
           dbms=dlm
           out=&outdsn(drop=var:)
           replace;
           delimiter='|';
           getnames=yes;
        run;quit;

        filename _tmp1_ clear;
        filename _tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);
        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);

   %end;

%mend utl_odstab;



