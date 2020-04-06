%macro utl_odstab(outdsn);

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

        /* %let outdsn=tst;  */

        proc printto;
        run;quit;

        filename _tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);

        filename _tmp2_ "%sysfunc(pathname(work))/_tmp2_.txt";

        proc datasets lib=work nolist;  *just in case;
         delete &outdsn;
        run;quit;

        data _null_;
          retain pos n 0 newhed;
          length newhed $255 wrd $32;
          infile _tmp1_ length=l;
          input lyn $varying32756. l;
          if lyn ne "" then n=n+1;
          if countc(lyn,'|')>1;
          if n=1 then do;
             do i=1 to countc(lyn,'|')-1;
                newhed=catx('|',newhed,cats('j',put(i,2.),scan(lyn,i,'|')));
             end;
             lyn="|"!!newhed;
          end;
          lyn=compbl(lyn);
          putlog lyn;
          file _tmp2_;
          put lyn;
        run;quit;

        proc import
           datafile=_tmp2_
           dbms=dlm
           out=&outdsn
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
