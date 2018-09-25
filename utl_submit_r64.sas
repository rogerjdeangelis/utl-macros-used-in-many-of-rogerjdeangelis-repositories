%macro utl_submit_r64(
      pgmx
     ,returnVar=N           /* set to Y if you want a return SAS macro variable from python */
     )/des="Semi colon separated set of R commands - drop down to R";
  * write the program to a temporary file;
  %utlfkil(d:/txt/r_pgm.txt);
  filename r_pgm "d:/txt/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "c:\Progra~1\R\R-3.3.2\bin\x64\R.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;

  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_r64;


