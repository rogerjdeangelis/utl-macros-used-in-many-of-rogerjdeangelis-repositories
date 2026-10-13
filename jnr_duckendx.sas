%macro jnr_duckendx(
   duckdb=
   ,prq=d:/parquet
   ,return=
   )/des="DUCKDB  execute sql script";
run;

/*--- to pass text into a windows clipboard us the following
.mode list
.headers off
.once |clip.exe
SELECT 'Hello from duckDb';
---*/

  %local pth;
  %let pth=%sysfunc(pathname(work));

  options noxwait noxsync;
  filename rut pipe "duckdb &duckdb -f &pth/duck_resolve.sql";
  run;quit;
  data _null_;
    infile rut;
    input;
    putlog _infile_;
  run;

  filename rut clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    %*let return=from;
    filename clp clipbrd;
    data _null_;
     infile clp;
     input;
     putlog "*******  " _infile_ "  ********";
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend jnr_duckendx;
