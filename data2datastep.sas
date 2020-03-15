%macro data2datastep(dsn,file);

%local varlist ;

* write message to output not log because lag has source;
%let rc=%sysfunc(dosubl('
  data _null_;
       file print;
       if "&dsn" ="" then do;
           put "*** Please Provide a table ***";
           put "*** Please Provide a table ***";
           put "*** Please Provide a table ***";
       end;
   run;quit;
'));

%if "%scan(&dsn,2,%str(.))" = "" %then %do;
  %let lib=%upcase(work);
  %let dsn=%upcase(&dsn);
%end;
%else %do;
   %let lib=%upcase(%scan(&dsn,1,%str(.)));
   %let dsn=%upcase(%scan(&dsn,2,%str(.)));
%end;

%if "&dsn" ^= "" %then %do;

    proc sql noprint;
      select Name
          into :varlist separated by ' '
       from dictionary.columns
       where libname="&lib"
         and memname="&dsn"
    ;
      select case type
              when 'num' then
                 case
                    when missing(format) then cats(Name,':32.')
                    else cats(Name,':',format)
                 end
              else cats(Name,':$',length,'.')
           end
          into :inputlist separated by ' '
       from dictionary.columns
       where libname="&lib"
         and memname="&dsn"
    ;
    quit;

    %if %superq(file)= %then %do;
       filename __out dummy;
    %end;
    %else %do;
       filename __out "&file";
    %end;

    filename __dm clipbrd;

    data _null_;
       if _n_ =1 then do;
          file __out dsd;
          put "data &lib..&dsn;";
          put @3 "infile datalines4 dsd truncover;";
          put @3 "input %superq(inputlist);";
          put "datalines4;";
          file __dm dsd;
          put "data &lib..&dsn;";
          put @3 "infile datalines dsd truncover;";
          put @3 "input %superq(inputlist);";
          put "datalines4;";
          file log dsd;
          put "data &lib..&dsn;";
          put @3 "infile datalines dsd truncover;";
          put @3 "input %superq(inputlist);";
          put "datalines4;";
       end;
       set &lib..&dsn end=last;
       file __out dsd;
       put &varlist @;
       put &varlist @;
       file __dm dsd;
       put &varlist @;
       file log dsd;
       put &varlist @;
       if last then do;
          file __out dsd;
          put;
          put ';;;;';
          put 'run;quit';
          file __dm dsd;
          put;
          put ';;;;';
          put 'run;quit';
          file log dsd;
          put;
          put ';;;;';
          put 'run;quit';
       end;
       else do;
          file __out dsd;
          put;
          file __dm dsd;
          put;
          file log dsd;
          put;
      end;
    run;

%end;

%mend data2datastep;
