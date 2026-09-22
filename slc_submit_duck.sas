%macro slc_submit_duck(
       pgm
      ,duckdb=c:/temp/dbase.duckdb
      ,return=  /* name for the macro variable from duckdb */
      )/des="Semi colon separated set of Powershell commands - drop down to Powershell. Bactic converted to double quote";

   %utlfkil(c:/temp/pgm.sql);
   %utlfkil(c:/temp/duck1.log);

   * write the program to a temporary file;
   filename py_pgm "c:/temp/pgm.sql" lrecl=32756 recfm=v;
   data _null_;
     length pgm  $32755 ;
     file py_pgm ;
     pgm=compbl(&pgm);
     if index(pgm,"`") then
        cmd=translate(pgm,"22"x,"`");
     put pgm;
     putlog pgm;
   run;quit;

   filename rut pipe "duckdb &duckdb -f c:/temp/pgm.sql ";

   data _null_;
     file print;
     infile rut;
     input;
     put _infile_;
     putlog _infile_;
   run;

   filename rut clear;
   filename py_pgm clear;
   * use the clipboard to create macro variable;
   %if "&return" ^= "" %then %do;
     filename clp clipbrd ;
     data _null_;
      length txt $200;
      infile clp;
      input;
      putlog "*******  " _infile_;
      call symputx("&return",_infile_,"G");
     run;quit;
   %end;
%mend slc_submit_duck;
