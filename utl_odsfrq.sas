%macro utl_odsfrq(outdsn);

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

        proc printto;
        run;quit;

        filename _tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);

        filename _tmp2_ "%sysfunc(pathname(work))/_tmp2_.txt";

        proc datasets lib=work nolist;  *just in case;
         delete &outdsn;
        run;quit;

        data _null_;
          infile _tmp1_ length=l;
          input lyn $varying32756. l;
          if index(lyn,'Col Pct')>0 then substr(lyn,1,7)='LEVELN   ';
          lyn=compbl(lyn);
          if countc(lyn,'|')>1;
          putlog lyn;
          file _tmp2_;
          put lyn;
        run;quit;

        proc import
           datafile=_tmp2_
           dbms=dlm
           out=_temp_
           replace;
           delimiter='|';
           getnames=yes;
        run;quit;

        data &outdsn(rename=(_total=TOTAL));
          length rowNam $8 level $64;
          retain rowNam level ;
          set _temp_;
          select (mod(_n_-1,4));
            when (0) do; level=cats(leveln); rowNam="COUNT";end;
            when (1) rowNam="PERCENT";
            when (2) rowNam="ROW PCT";
            when (3) rowNam="COL PCT";
          end;
          drop leveln;
        run;quit;

        filename _tmp1_ clear;
        filename _tmp2_ clear;

        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);
        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);
        
        OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

   %end;

%mend utl_odsfrq;
