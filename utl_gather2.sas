********************************************************************;
********** SAS Macro %gather2(): transpose datset from fat to skinny OR from a wide to a long dataset;
********** DBIN: input dataset;
********** KEY: name of key variable in output (should not be a column name!);
********** VALUE: name of variable with values in output (should not be a column name!);
**********        NOTE: character variables: leading blanks will not be removed!
**********        NOTE: Missing "." will be removed (set to blank);
********** EXCLUDE: is the -exclude variable (ID variable) - must be a column name
**********          (or more column names/primary keys, or empty);
********** DBOUT: output dataset;                    
********** VALFORMAT: Character format of variable with values (default character $200.)
**********            not possibe for (numeric) dates (dates as character only);
**********            Numeric Format, e.g. 8. only possible if all values in dataset are numeric;
********** WITHFORMATS: Output of the associated SAS Formats (e.g. char, num, time, date, datetime) in 
**********              Variable _ColFormat, ColFor2, _ColTyp _ColTypVar (N, C); 
**********              (additional feature);
********** WITHLABELS: Output of the Variable Labels
**********             Variable _ColLab (additional feature);
********** SASFORMATS: Output of (real) SAS Formats, Identification of missing Values;
**********             Variables: _UserDef, _IsRealNum (i.e. BEST. or w.d Format), _SASFormat, _IsMissing,  
**********             Limitation: does not identify "special" missing values (e.g. .Z) as missing;
**********             Identification of BEST. or w.d. Format (_IsRealNum = 1);
********** NOTE: All Variable Values will be left alligned: &VALUE=strip(vvalue(%scan(&COLNAMES, &I)));
********** Please Note: SAS function fmtinfo() requires SAS 9.4 above!
********** Example: %gather2(VS_WIDE, VSTESTCD, VSORRES, SUBJID VISITNUM, VS_LONG, ValFormat=$10., WithLabels=Y);
********** Example: %gather2(VS_WIDE, VSTESTCD, VSORRES, SUBJID VISITNUM, VS_LONG, ValFormat=$10., 
                            WithFormats=Y, WithLabels=Y, SASFormats=Y);

%macro utl_gather2(DbIn, Key, Value, Exclude, DbOut, ValFormat=, WithFormats=N, WithLabels=N, SASFormats=N);
/********** Local Variables */ 
%local I ColCount FormChar;
 
/********** Check, if dataset exists */
%let dsid=%sysfunc(open(&DBIN,i));
%if &dsid=0 %then %do;
    %put ERROR: Macro: &SYSMACRONAME - The Dataset &DBIN does not exist! - ABORT;
    %let rc=%sysfunc(close(&dsid));
    %return;
    %end;
%let rc=%sysfunc(close(&dsid));

/********** Default character format */ 
%if &ValFormat= %then %let ValFormat=$200.;
 
/********** Upcase WithFormats */ 
%let WithFormats=%upcase(&WithFormats);

/********** Identify num or char Format (1st Character of ValFormat) */
%let FormChar=%substr(&ValFormat, 1, 1);

/********** Upcase WithLabels */ 
%let WithLabels=%upcase(&WithLabels);

/********** Upcase SASFormat */ 
%let SASFormats=%upcase(&SASFormats);

/********** When SASFormats=Y then also WithFormats must be Y */
%if &SASFormats=Y %then %do;
    %let WithFormats=Y;
    %end;

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
%put "Identified 1st char of ValFormat:" &FormChar;
 
/********** Final (long) dataset */ 
data &DBOUT;
    set &DBIN;
    format &KEY $32.;
    format &VALUE &ValFormat;
    format _ValueTempChar $40.;
    %do i=1 %to &ColCount;
        &KEY=scan("&COLNAMES", &I);
        /********** Check for variables that are not allowed */ 
        if upcase(&KEY) in('_COLFORMAT', '_COLTYP', '_COLTYPVAR', '_USERDEF', '_ISREALNUM', '_SASFORMAT', '_ISMISSING') then do;
           put "ERROR: Macro gather2: Variables _ColFormat _ColTyp _ColTypVar _UserDef _IsRealNum _SASFormat _IsMissing not allowed in DbIn.";
           abort;
           end;
        /********** Do in case of assigned ValFormat Character */ 
        %if &FormChar=$ %then %do;
            /********** Assign numeric Variables Left (strip), character Variables as is (i.e. keep leading blanks) */
            if vtype(%scan(&COLNAMES, &I)) eq "N" then do;
               &VALUE=strip(vvalue(%scan(&COLNAMES, &I)));
               if &VALUE="." then call missing(&VALUE); *** . set to missing ***;
               end;
            else do;
               &VALUE=vvalue(%scan(&COLNAMES, &I));
               end;
            _ValueTempChar="";
            %end;
        /********** Do in case of assigned ValFormat NON Character */ 
        %else %do;
            if vtype(%scan(&COLNAMES, &I))="C" then do;
               put "WARNING: Macro gather2: ValFormat is assigned as numeric format &ValFormat, but database &DBIN contains also charater variables (coerced to .)";
               end;
            _ValueTempChar=strip(vvalue(%scan(&COLNAMES, &I)));
            &VALUE=input(_ValueTempChar, 16.);
        %end;
        /********** Output of SAS Variable Lables (trunc to 200 char.) */
        %if &WithLabels=Y %then %do;
            format _ColLab $200.;
            _ColLab=strip(vlabel(%scan(&COLNAMES, &I)));
            %end;
        /********** Output of SAS Formats */ 
         %if &WithFormats=Y %then %do;
             format _ColFormat _ColFor2 $32. _ColTyp $32. _ColTypVar $1.;
             _ColFormat=strip(vformat(%scan(&COLNAMES, &I))); 
             _ColFor2=strip(vformatn(%scan(&COLNAMES, &I))); 
             _ColTyp=fmtinfo(_ColFor2, 'cat'); /* SAS 9.4 above */
             if _ColTyp="UNKNOWN" then _ColTyp="USER DEFINED";
             _ColTypVar=vtype(%scan(&COLNAMES, &I));
             %end;
        output;
    %end;
    drop &COLNAMES _ValueTempChar;
run;quit;

/********** Final (long) dataset with (real) SAS Formats, Missing Value and Identification of real num vars */ 
%if &SASFormats=Y %then %do;
    data &DBOUT;
        set &DBOUT;
        format _UserDef $8. _IsRealNum 8. _SASFormat $32. _IsMissing $1.;
        /********** Derive Num Format */
        if _ColTypVar="N" and _ColTyp ne "binary" and 
            substr(_ColFormat, 1, 2) ne "FR" and 
            substr(_ColFormat, 1, 1)="F" then _SASFormat=left(translate(_ColFormat, "", "F"));
        /********** Derive other Formats */
        if _SASFormat="" and _ColTyp in ("char", "date", "datetime", "time", "num", "curr", "binary") then _SASFormat=_ColFormat;
        if _SASFormat="" and _ColTyp="USER DEFINED" then _SASFormat=trim(_ColFor2) || ".";
        if _ColTyp="USER DEFINED" and _ColTypVar="C" then _UserDef="USER CHR";
        if _ColTyp="USER DEFINED" and _ColTypVar="N" then _UserDef="USER NUM";
        if missing(&VALUE) then _IsMissing="Y";
        /********** Derive Real Numeric Variable (1 = BEST or w.d format, 0 = other numeric formats) */
        if _ColTyp="num" then _IsRealNum=0;
        if _UserDef="" and (substr(_SASFormat, 1, 4)="BEST" or compress(_SASFormat, ".", 'd')="") then _IsRealNum=1;
        if _SASFormat="" then put "WARNING: Missing SAS Format for " &VALUE " EXTENTION OF SAS MACRO GATHER2 CODE WARRANTED";
        /********** Check for E in number, i.e. numeric format with scientific notation of variable value */
        %if &FormChar=$ %then %do;
            if _IsRealNum=1 and index(&VALUE, 'E') gt 0 then _IsRealNum=3;
            %end;
        drop _ColFor2;
    run;quit;
%end;
%mend utl_gather2;