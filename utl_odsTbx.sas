%macro utl_odsTbx(outdsn,intermediate=_temp);
   %utl_close;
   proc datasets lib=work nolist;  *just in case;
    delete &outdsn;
   run;quit;
   %if %qupcase(&outdsn)=SETUP %then %do;
        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);
        OPTIONS ls=max ps=32756  FORMCHAR='|'  nodate nocenter;
        proc printto print="%sysfunc(pathname(work))/_tmp1_.txt" new;
        run;quit;
   %end;
   %else %do;
        proc printto;
        run;quit;
        PROC SQL noprint;
          select
             text
            ,countc(Text,'|')
          into
             :_ttl TRIMMED
            ,:_col
          from
              Dictionary.Titles
          where
              Type="T" & Number=1;
          quit;
        %put &_ttl;
        %put &_col;
        /*---- just for checking ----*/
        data _null_;
          infile "%sysfunc(pathname(work))/_tmp1_.txt";
          input;
          putlog _infile_;
        run;quit;
        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);
        data _null_;
          infile "%sysfunc(pathname(work))/_tmp1_.txt" length=l;
          file "%sysfunc(pathname(work))/_tmp2_.txt" ;
          input lyn $varying32756. l;
          if _n_=1 then do;
             put lyn;
             putlog lyn;
          end;
          else do;
            if countc(lyn,'|')=&_col then do;
               put lyn;
               putlog lyn;
            end;
          end;
        run;quit;
        proc import
           datafile="%sysfunc(pathname(work))/_tmp2_.txt"
           dbms=dlm
           out=&intermediate(drop=var:)
           replace;
           delimiter='|';
           getnames=yes;
        run;quit;
        /*---- clean up intermediate dataset ----*/
        data &outdsn;
           set &intermediate;
           array chr _character_;
           if substr(chr[1],1,5)='     ' or substr(chr[1],1,5)='-----' then delete;
         run;quit;
        * turn off for production;
        %utlfkil(%sysfunc(pathname(work))/_tmp1_.txt);
        %utlfkil(%sysfunc(pathname(work))/_tmp2_.txt);
        proc datasets lib = work nodetails nolist;
          modify &outdsn ;
            attrib _all_ label = "" ;
            format _all_;
            informat _all_;
          run ;
        quit ;
   %end;
   options formchar='|----|+|---+=|-/\<>*';
   %utl_close;
%mend utl_odstbx;
