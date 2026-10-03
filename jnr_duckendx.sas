%macro jnr_duckendx(
   duckdb=d:/parquet/mydb.duckdb
   ,prq=d:/parquet
   ,return=
   )/des="DUCKDB  execute sql script";
run;
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
    data _null_;
     set "&prq.\clipboard.parquet"; /*--- created from the sql script ---*/
     input;
     putlog "*******  " macvar "  ********";
     call symputx("&return",macvar,"G");
    run;quit;
  %end;

%mend jnr_duckendx;
