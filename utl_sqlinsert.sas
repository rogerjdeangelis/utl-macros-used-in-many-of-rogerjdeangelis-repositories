%macro utl_sqlinsert(dsn)/des="send sql insert code to the log and clipbord paste buffer";

   options ls=256;

   filename tmp temp lrecl=4096;

   ods tagsets.sql file=tmp;

   proc print data=&dsn;
   run;quit;

   ods _all_ close; ** very important;

   filename clp clipbrd;
   data _null_;
    retain flg 0;
    length once $255 remain $255;
    infile tmp end=dne;
    file clp;
    input;
    select;
       when (_n_ < 3)  do;
           put _infile_;
           putlog _infile_;
       end;
       when (_infile_=:"Insert into" and flg=0)  do;
          flg=1;
          once=cats(scan(_infile_,1,')'),')');
          remain=cats(scan(_infile_,2,')'),')');
          put once;
          putlog once;
          put remain;
          putlog remain;
       end;
       when (_infile_=:"Insert into") do;
          remain=cats(scan(_infile_,2,')'),')');
          put remain;
          putlog remain;
       end;
       * leave otherwise off to force error;
    end;
    if dne then do;
         putlog ';quit;';
         put ';quit;';
    end;
   run;quit;

   filename tmp clear;

   ods listing;

   options ls=255;

%mend utl_sqlinsert;

