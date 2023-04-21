********** EXCLUDE: is the -exclude variable (ID variable) - must be a column name
**********          (or more column names/primary keys, or empty);
********** DBOUT: output dataset;
********** VALFORMAT: Character format of variable with values (default character $200.)
**********            numeric formats not possible w/o NOTE: character values converted
**********            not possibe for (numeric) dates (dates as character only);
********** WITHFORMATS: Output of the associated SAS Formats (e.g. char, num, time, date, datetime) in
**********              Variable _ColForm and _ColTyp;
**********              (additional feature);
**********              Please Note: SAS function fmtinfo() requires SAS 9.4 above!
********** Example: %gather(VS_WIDE, VSTESTCD, VSORRES, SUBJID VISITNUM, VS_LONG, ValFormat=$10.);
%macro utl_gather(DbIn, Key, Value, Exclude, DbOut, ValFormat=, WithFormats=N);
/********** Local Variables */
%local I ColCount;

/********** Default character format */
%if &ValFormat= %then %let ValFormat=$200.;

/********** Upcase WithFormats */
%let WithFormats=%upcase(&WithFormats);

/********** Dataset without EXCLUDE Variable(s) */
data db00_EXCLUDE (drop=&EXCLUDE);
    set &DBIN;
run;quit;

/********** Select all column names */
proc sql noprint;
    select name into : COLNAMES separated by ' '
    from dictionary.columns
    where libname='WORK' and upcase(MEMNAME)="DB00_EXCLUDE";
quit;

%let ColCount=&SQLOBS;

%put "Column names:" &COLNAMES;
%put "Number of Column Names:" &ColCount;

/********** Final (long) dataset */
data &DBOUT;
    set &DBIN;
    format &KEY;
    format &VALUE &ValFormat;
    %do i=1 %to &ColCount;
        &KEY=scan("&COLNAMES", &I);
        &VALUE=strip(vvalue(%scan(&COLNAMES, &I)));
        /********** Output of SAS Formats */
         %if &WithFormats=Y %then %do;
             _ColFormat=strip(vformat(%scan(&COLNAMES, &I)));
             /*_ColFor2=strip(vformatn(%scan(&COLNAMES, &I)));
             _ColTyp=fmtinfo(_ColFor2, 'cat');  SAS 9.4 above */
             _ColTyp=vtypex("%scan(&COLNAMES, &I)");
             if _ColTyp="UNKNOWN" then _ColTyp="USER DEFINED";
             drop _ColFor2;
             %end;
        output;
    %end;
    drop &COLNAMES;
run;quit;
%mend utl_gather;


