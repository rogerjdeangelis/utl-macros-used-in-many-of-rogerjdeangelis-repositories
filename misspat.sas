%macro qcmprltb(text);
%*********************************************************************;
%*                                                                   *;
%*  MACRO: QCMPRLTB                                                  *;
%*                                                                   *;
%*  USAGE: 1) %qcmprltb(argument)                                    *;
%*                                                                   *;
%*  DESCRIPTION:                                                     *;
%*    form with multiple blanks compressed to single blanks but with *;
%*    with leading and trailing blanks retained, unlike %qcmpres.    *;
%*                                                                   *;
%*    Eg. %let macvar=%qcmprltb(&argtext)                            *;
%*                                                                   *;
%*  NOTES:                                                           *;
%*    The %QLEFT macro in the autocall library is used in this macro.*;
%*                                                                   *;
%*********************************************************************;
%local i;
%let i=%index(&text,%str(  ));
%do %while(&i^=0);
  %let text=%qsubstr(&text,1,&i)%qleft(%qsubstr(&text,&i+1));
  %let i=%index(&text,%str(  ));
%end;
&text
%mend;

%macro qblankta(text);
%*********************************************************************;
%*                                                                   *;
%*  MACRO: QBLANKTA                                                  *;
%*                                                                   *;
%*  USAGE: 1) %qblankta(argument)                                    *;
%*                                                                   *;
%*  DESCRIPTION:                                                     *;
%*    REPLACE BLANKS BY ASTERISKS:  MODELED AFTER QCMPRES FOUND IN   *;
%*    !SASROOT\core\sasmacro.                                        *;
%*                                                                   *;
%*    Eg. %let macvar=%qblankta(&argtext)                            *;
%*                                                                   *;
%*  NOTES:                                                           *;
%*                                                                   *;
%*********************************************************************;
%local i;
%let i=%index(&text,%str( ));
%do %while(&i^=0);
  %IF &I GT 1 %THEN
    %if &i lt %length(&text) %then
    %let text=%qsubstr(&text,1,&i-1)%str(*)%qsubstr(&text,&i+1);
    %else %let text=%qsubstr(&text,1,&i-1)%str(*);
  %ELSE %let text=%str(*)%qsubstr(&text,&i+1);
  %let i=%index(&text,%str( ));
%end;
&text
%mend;

%macro qblanktc(text) ;
%*********************************************************************;
%*                                                                   *;
%*  MACRO: QBLANKTC                                                  *;
%*                                                                   *;
%*  USAGE: 1) %qblanktc(argument)                                    *;
%*                                                                   *;
%*  DESCRIPTION:                                                     *;
%*    REPLACE BLANKS IN ARGUMENT BY COMMAS.                          *;
%*                                                                   *;
%*    Eg. %let macvar=%qblanktc(&argtext)                            *;
%*                                                                   *;
%*  NOTES:                                                           *;
%*    USES %QSYSFUNC AND TRANSLATE FUNCTIONS TO ACCOMPLISH THE       *;
%*    OBJECTIVE.                                                     *;
%*                                                                   *;
%*********************************************************************;

  %if &text ne %then %qsysfunc(translate(&text,%str(,),%str( ))) ;
%mend  qblanktc ;

%macro qlastvar(text);
%*********************************************************************;
%*                                                                   *;
%*  MACRO: QLASTVAR                                                  *;
%*                                                                   *;
%*  USAGE: 1) %qlastvar(argument)                                    *;
%*                                                                   *;
%*  DESCRIPTION:                                                     *;
%*    Finds the last variable name in the argument, which consists   *;
%*    of variable names delimited by blanks.  The name is returned   *;
%*    without leading or trailing blanks.                            *;
%*                                                                   *;
%*    Eg. %let macvar=%qlastvar(&argtext)                            *;
%*                                                                   *;
%*  NOTES:                                                           *;
%*    The %QCMPRES macro in the autocall library is used in this     *;
%*    macro.                                                         *;
%*                                                                   *;
%*********************************************************************;
%local i;
%let text=%qcmpres(&text);
%let i=%index(&text,%str( ));
%do %while(&i^=0);
  %let text=%qsubstr(&text,&i+1);
  %let i=%index(&text,%str( ));
%end;
&text
%mend;
*END OF UTILITY MACROS;


%macro misspat(
      data=_last_,   /* name of input dataset */
      var=_ALL_,     /* allow selecting VAR=_NUMERIC_ or _CHARACTER_ */
      sortby=descending percent,
      BY=,           /* list of blank-separated BY variables         */
      COLLAPSE=NO,
      out=misspat    /* name of output dataset */
      );

    * MISS_PAT.SAS VERSION 1.0
    * THIS MACRO WILL RUN A MISSING PATTERN ANALYSIS ON THE DATA SET &data;
    * 'BY' VARIABLES CAN BE USED BY SPECIFYING &BY;
    * If 'by' variables are specified and collapse=YES, then statistics
      for missing patterns collapsed accross all 'by' variables are
      also printed;
    * All VAR= variables except the 'by' variable are used in the analysis;

    * TITLES CREATED BY THIS MACRO ARE PUT IN TITLE3, and TITLE4 LINES;

    %LOCAL SORTIN; * TO CONTROL DATA SET USE IN SORT BELOW, DEPENDING ON CIRCUMSTANCE;

    %* Guarantee at least one trailing blanks at end of &by;
    %* so as to be able to search the &by list for unique individual
       substrings that do not contain blanks (i.e., search for the
       individual 'by' variables;
    %* Guarantee no more than one blank seperating variable names in &by;
    %* so as to replace the blanks with asterisks for use in proc freq;
    %* also guarantee that characters are upper case for comparisons later;
    %LET BY=%UPCASE(%CMPRES(&BY))%STR( );
    %PUT BY=&BY***;

    * Determine the variables in the data set &data using proc contents ;
    proc contents data=&data noprint
      out=cont_ds(
        keep=name varnum label type
        rename=(name=variable)
        label="Contents of &data: Selected Variables"
         );
    run;

    proc print;

    * Set up formats for the variable 'type' and for missingness;
    proc format;
      value typef
        1='NUMERIC'
        2='CHARACTER'
            ;
      value miss
        0='X'
        1='.'
            ;
    run;

    %let var=%upcase(&var);

    TITLE3 "Variable Name Aliases for &data for Use in Mising Value Pattern Analysis";
    * Note: the proc contents above sorted the data set by 'VARIABLE';
    * If &VAR^=_ALL_, the variable aliases will be inconveniently labeled;
    data aliases;
      attrib alias length=$6;
      format type typef.;
      set cont_ds;
      alias='V'||left(put(varnum,5.0));
            *-- Subset by TYPE or variable name;
            %if &var=_ALL_       %then %str(;);
      %else %if &var=_NUMERIC_   %then %do;  if type=1; %end;
      %else %if &var=_CHARACTER_ %then %do;  if type=2; %end;
      %else %do;  if index("&var", upcase(trim(variable)));     %end;

    run;
    TITLE4 "Sorted by VARIABLE";
    proc print data=aliases;
          id variable;
          var alias label type;
    run;

    TITLE4 "Sorted by ALIAS";
    proc sort data=aliases;
    * note: sorting by alias leads to trouble when greater than 9 variables;
      by varnum;
    run;
    proc print data=aliases;
          id alias;
          var variable label type;
    run;

    * Create macro variables for 'rename' statement, etc. later;
    * exclude variables in the &by list;
    * create the macro variables in order sorted by varnum;
    * also create a list of macro variables from the &by list;
    %local aliases variables;
    data _null_;
      retain  bylist "&by"; * previously added a blank at the end to be
                              able to delimit a string by a trailing blank;
      set aliases end=eof;
      retain aliases variables;
      length aliases variables $200;
      * Seperate processing if variable is in the &by list;
       if not index(bylist,trim(upcase(variable))||' ')
      then do;
        nanalyze+1;
          aliases = trim(aliases) || ' ' || trim(alias);
          variables = trim(variables) || ' ' || trim(variable);
        put 'Outputting macro variables for variable ' NANALYZE '(' variable ') -> ' alias;
          %* &A1, &A2, etc. will contain the alias names;
        call symput('A'||left(put(nanalyze,5.0)),trim(alias));
          %* &VAR1, &VAR2, etc. will contain the variable names;
        call symput ('VAR'||left(put(nanalyze,5.0)),variable);
        %* &T1, &T2, etc. will contain the variable type;
        call symput ('T'||left(put(nanalyze,5.0)),type);
      end;
      else do;
        nbyvars+1;
          put 'Outputting macro variable for BY variable ' NBYVARS '(' variable ')';
        CALL SYMPUT ('BYVAR'||LEFT(PUT(NBYVARS,5.0)),VARIABLE);
      end;
      if eof then do;
        call symput('nanalyze',nanalyze);
          call symput('nbyvars',nbyvars);
          call symput('aliases',aliases);
          call symput('variables',variables);
      end;
    run;

    %put aliases = &aliases;
    %put variables = &variables;


    * Create a data set 'shortnam' with aliases substituted for variable
      names, etc.;
    DATA SHORTNAM;
    * SET UP THE V1, ETC. AS ONE BYTE CHARACTER VARIABLES;
      length &aliases $1;

      * Set up mispat as character of length &nanalyze;
      length mispat $ &nanalyze;
      set &data;
      ;
      * CREATE THE V1_MISS, ETC. VARIABLES, DEPENDING ON VARIABLE TYPE;
      %DO I=1 %TO &NANALYZE;
         ;
         %IF &&T&I = 1 %THEN
             %STR(* NUMERIC VARIABLE;)
         %STR(IF &&VAR&I LE .Z THEN &&A&I='.'; ELSE &&A&I='X';);
             %ELSE
         %STR(* CHARACTER VARIABLE;)
             %STR(IF &&VAR&I EQ ' ' THEN &&A&I='.'; ELSE &&A&I='X';);

             * ITERATIVELY CONSTRUCT MISPAT;
         %IF &I EQ 1 %THEN %STR(MISPAT=&&A&I;);
             %ELSE %STR(MISPAT=TRIM(MISPAT)||&&A&I;);
      %END;
      ;
      * TRANSLATE MISPAT TO A BINARY STRING;
      MISPAT=TRANSLATE(MISPAT,'01','X.');
      ;
      * DROP UNNEEDED DATA;
      DROP &variables;
      /*
      %DO I=1 %TO &NANALYZE;
           &&VAR&I
      %END;
      */
      ;
    RUN;
    *proc print data=shortnam(obs=20);


    PROC FREQ DATA=SHORTNAM;
      TABLE MISPAT%qblankta(%qtrim(%str( )%qcmpres(&by)))/OUT=BYMISPAT NOPRINT MISSING;
    RUN;

    * Add the group number to the observations;
    data bymispa2;
      set bymispat;
      by mispat ;
      if first.mispat then Group+1;
      rename count=Freq;
    run;


    * Print the missing patterns if by groups not specified via &by, otherwise
      print the ungrouped missing patterns if requested via &collapse;
    %IF (%QTRIM(&BY) EQ ) OR ((%QTRIM(&BY) NE ) AND %UPCASE(&COLLAPSE) EQ YES)
     %THEN %DO;

       %IF %QTRIM(&BY) NE %THEN %DO;

        * Summarize collapsing on &by variables ;
        proc freq data=bymispa2;
              table mispat/out=bymispa3 noprint missing;
              weht freq;
        run;

        * Now read the group number to the observations;
        data bymispa4;
          set bymispa3;
          by mispat ;
          if first.mispat then Group+1;
              rename count=Freq;
        run;

            %LET SORTIN=BYMISPA4;
       %END;
       %ELSE %LET SORTIN=BYMISPA2;


        * Results to be printed without by variables;
        * Translate mispat back into v1, v2, etc.;
          *-- Use binary (0/1) variables rather than character and formats for printing as X or .;
          *-- Provide variable name as label for Vi in output dataset;
          *-- Delete OBS variable;
        DATA &out;
          set &sortin;
    *      obs+1;
          drop mispat;
    *        misbin = mispat;  *-- save binary pattern (for testing);

                %do i=1 %to &nanalyze;
                      &&A&i = (substr(mispat,&i,1) = '1');
                      format &&A&i miss.;
                      label  &&A&i = "&&var&i";
                      %end;
          nmiss = sum(of &aliases);      *-- number of missing variables;

          LABEL Group='Group'
                Freq='Freq'
                Percent='Percent'
                      nmiss = 'missing';
          FORMAT PERCENT 5.1;
    *      LABEL OBS='Obs';
        RUN;

        * Next sort the results by percent descending;
        proc sort data=&out;
              by &sortby;
            run;
        PROC PRINT DATA=&out /* LABEL */;
        TITLE4 "Missing data patterns: sorted by &sortby";
          VAR &aliases
             group freq percent;
        RUN;
    %END;

    * If appropriate do computations then print grouped (by &by) missing
      patterns ;
    %IF &BY NE %STR( ) %THEN %DO;
          proc sql;
          create table work.groupct as
          select mispat %qblanktc(%qtrim(%str( )%qcmpres(&by))),freq,group,
                 sum(freq) as bytot,
                 100*freq/sum(freq) as percent
                   from bymispa2
                   group by %qblanktc(%qcmpres(&by))
                   order by %qblanktc(%qcmpres(&by)),percent desc,group
              ;
          quit;

    * TRANSLATE MISPAT BACK INTO V1, V2, ETC.;
    DATA &out;
    /*
    * SET UP THE V1, ETC. AS ONE BYTE CHARACTER VARIABLES;
      LENGTH
      %DO I=1 %TO &NANALYZE;
          &&A&I
      %END;
      $ 1;
    */

      SET GROUPCT(DROP=BYTOT);
     %IF &BY NE %STR( ) %THEN %STR(
      BY &BY ;
      IF FIRST.%QLASTVAR(&BY)THEN OBS=0 ;
    );
      OBS+1;
                %do i=1 %to &nanalyze;
                      &&A&i = (substr(mispat,&i,1) = '1');
                      format &&A&i miss.;
                      label  &&A&i = "&&var&i";
                      %end;
    *  DROP MISPAT;
       * TRANSLATE BACK FROM BINARY STRING;
     /*
      MISPAT=TRANSLATE(MISPAT,'X.','01');
      %DO I=1 %TO &NANALYZE;
      &&A&I=SUBSTR(MISPAT,&I,1);
      %END;
     */
      LABEL GROUP='Group';
      LABEL FREQ='Freq';
      LABEL PERCENT='Percent';
      FORMAT PERCENT 5.1;
      LABEL OBS='ByObs';
    RUN;

    PROC PRINT DATA=&out LABEL ;
      %IF &BY NE %STR( ) %THEN %DO;
        %STR(    BY &BY ;);
        %DO I=1 %TO &NBYVARS;
            *Suppress the label so by variable names, rather than labels, are printed;
            LABEL &&BYVAR&I..=' ';
        %END;
      %END;
      TITLE4 'Missing Data Patterns: Sorted By Descending Percent';
      VAR &aliases
         GROUP FREQ PERCENT;
    RUN;
    %END;

      * switch variable names and labels;
    data _null_;
      set &out (obs=1);
      cmd="proc datasets lib=work;modify &out; rename";
      call execute(cmd);
      putlog cmd;
    /* Array of all character variables */
    array temp1 (*) _character_;

    /* Array of all numeric variables */
    array temp2 (*) _numeric_;

      /* For each element in the character array, assn its label */
      /* as the value of NEWLABEL, and output the observation      */
      do i=1 to dim(temp1);
        lbl=vlabel(temp2[i]);
        nam=vname(temp2[i]);
        cmd=cats(nam,'=',lbl);
        if upcase(strip(nam)) ne upcase(strip(lbl)) then call execute(cmd);
        putlog cmd=;
      end;

      /* For each element of the numeric array, assn its label as */
      /* the value of NEWLABEL, and output the observation          */
      do j=1 to dim(temp2);
        lbl=vlabel(temp2[j]);
        nam=vname(temp2[j]);
        cmd=cats(nam,'=',lbl);
        if upcase(strip(nam)) ne upcase(strip(lbl)) then call execute(cmd);
        putlog cmd=;
      end;
      call execute(';run;quit;');
    stop;
    run;

    proc print data=&out width=min;
    ;run;quit;
    *-- Clear title statements;
    title3; run;
%MEND misspat;


/*
* TWOVARS.SAS REVISED 3-JUL-03;
* DATA FOR EXAMPLE IN NESUG 16 MISS_PAT PAPER;
DATA TWOVARS;
INPUT Variab01 1 Second_Var $ 3-5;
LABEL Variab01='VARIABLE NUMBER 1';
LABEL Second_Var='VARIABLE NUMBER 2';
cards;
2
1 ABC
1
1
2 DEF
2
1
1 GHI
;
PROC PRINT DATA=TWOVARS;
TITLE 'TWOVARS';
RUN;
* Examples of calls to MISS_PAT;
OPTIONS MPRINT;
 %MISSPAT(DATA=WORK.TWOVARS);;run;quit;
OPTIONS NOMPRINT;
OPTIONS MPRINT;
 %MISS_PAT(DS=sashelp.zipcode,by=statecode,collapse=yes)
OPTIONS NOMPRINT;

data geoexs;
  set sashelp.geoexs(keep=predirabrv--blkgrp tlid mtfcc side);
run;quit;

options ls=500;
%misspat(data=work.geoexs);
*/


