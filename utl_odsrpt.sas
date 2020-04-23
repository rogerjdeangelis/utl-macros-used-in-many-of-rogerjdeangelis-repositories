%macro utl_odsrpt(outdsn);


   %if %qupcase(&outdsn)=SETUP %then %do;

        %put @@@@ &=sysindex.;

        %let _tmp1_=a&sysindex.;

        %put xxxx &=_tmp1_;

        filename &_tmp1_ clear;  * just in case;

        %utlfkil(%sysfunc(pathname(work))/&_tmp1_..txt);

        filename &_tmp1_ "%sysfunc(pathname(work))/&_tmp1_..txt";

        %let _ps_= %sysfunc(getoption(ps));
        %let _fc_= %sysfunc(getoption(formchar));

        OPTIONS ls=max ps=32756  FORMCHAR='|'  nodate nocenter;

        title; footnote;

        proc printto print=&_tmp1_;
        run;quit;

   %end;
   %else %do;

        /* %let outdsn=tst;  */
        %put @@@ &=sysindex.;

        %let _tmp2_=b&sysindex.;
        %let _tmp1_=a%eval(&sysindex - 2);

        %put xxxx  &=_tmp1_;
        %put xxxx  &=_tmp2_;

        proc printto;
        run;quit;

        filename &_tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/&_tmp2_.txt);

        proc datasets lib=work nolist;  *just in case;
         delete &outdsn;
        run;quit;

        filename &_tmp2_ "%sysfunc(pathname(work))/&_tmp2_.txt";

        data _null_;
          infile &_tmp1_ length=l;
          input lyn $varying32756. l;
          if countc(lyn,'|')>1;
          lyn=compress(lyn);
          putlog lyn;
          file &_tmp2_;
          put lyn;
        run;quit;

        proc import
           datafile=&_tmp2_
           dbms=dlm
           out=&outdsn(drop=VAR:)
           replace;
           delimiter='|';
           getnames=yes;
        run;quit;

        filename &_tmp1_ clear;
        filename &_tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/&_tmp1_.txt);
        %utlfkil(%sysfunc(pathname(work))/&_tmp2_.txt);

   %end;

%mend utl_odsrpt;

