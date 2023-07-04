%macro utl_submit_r64x(
      pgmx
     ,return=N
     ,resolve=N
     )/des="Semi colon separated set of R commands - drop down to R";
  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  /* clear clipboard */
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(&pgmx);
     end;
    else do;
        pgm=&pgmx;
     end;
     if index(pgm,"`") then cmd=tranwrd(pgm,"`","27"x);
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "D:\r412\R\R-4.1.2\bin\R.exe --vanilla --quiet --no-save < &__loc";
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
  %if %upcase(%substr(&return.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;
  %end;
%mend utl_submit_r64x;
