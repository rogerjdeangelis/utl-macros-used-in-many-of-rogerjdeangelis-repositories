%macro bgetVars(
  ds               /* Name of the dataset, required. */
, sep = %str( )    /* Variables separator, space is the default one. */
, pattern = .*     /* Variable name regexp pattern, .*(i.e. any text) is the default, case INSENSITIVE! */
, varRange = _all_ /* Named range list of variables, _all_ is the default. */
, quote =          /* Quotation symbol to be used around values, blank is the default */
, mcArray =        /* Name of macroArray to be generated from list of variables */
)
/des = 'The %getVars() and %QgetVars() macro functions allows to extract variables list from dataset.'
;
/*%local t;*/
/*%let t = %sysfunc(time());*/

  %local VarList di dx i VarName VarCnt;
  %let VarCnt = 0;

  %let di = %sysfunc(open(&ds.(keep=&varRange.), I)); /* open dataset with subset of variables */
  %let dx = %sysfunc(open(&ds.                 , I)); /* open dataset with ALL variables */
  %if &di. > 0 %then
    %do;
      %do i = 1 %to %sysfunc(attrn(&dx., NVARS)); /* iterate over ALL variables names */
        %let VarName = %sysfunc(varname(&dx., &i.));

        %if %sysfunc(varnum(&di., &VarName.)) > 0 /* test if the variable is in the subset */
            AND
            %sysfunc(prxmatch(/%bquote(&pattern.)/i, &VarName.)) > 0 /* check the pattern */
        %then
          %do;
            %let VarCnt = %eval(&VarCnt. + 1);
            %if %superq(mcArray) = %then
              %do;
                %local VarList&VarCnt.;
                  %let VarList&VarCnt. = %nrbquote(&quote.)&VarName.%nrbquote(&quote.);
              %end;
            %else
              %do;
                %global &mcArray.&VarCnt.;
                   %let &mcArray.&VarCnt. = %unquote(%nrbquote(&quote.)&VarName.%nrbquote(&quote.));
              %end;
            /*
            %if %bquote(&VarList.) = %then
              %let VarList = %nrbquote(&quote.)&VarName.%nrbquote(&quote.);
            %else
              %let VarList = &VarList.%nrbquote(&sep.)%nrbquote(&quote.)&VarName.%nrbquote(&quote.);
            */
          %end;
      %end;
    %end;
  %let di = %sysfunc(close(&di.));
  %let dx = %sysfunc(close(&dx.));
/*%put (%sysevalf(%sysfunc(time()) - &t.));*/
%if %superq(mcArray) = %then
  %do;
    %do i = 1 %to &VarCnt.;%unquote(&&VarList&i.)%if &i. NE &VarCnt. %then %do;%unquote(&sep.)%end;%end;
  %end;
%else
  %do;
  /*-----------------------------------------------------------------------------------------------------------*/
    %put NOTE-;
    %put NOTE: When mcArray= parameter is active the getVars macro cannot be called within the %nrstr(%%put) statement.;
    %put NOTE: Execution like: %nrstr(%%put %%getVars(..., mcArray=XXX)) will result with an e.r.r.o.r.;
               /*e.r.r.o.r. - explicit & radical refuse of run */
    %put NOTE-;
    %local mtext rc;
    %let mtext = _%sysfunc(int(%sysevalf(1000000000 * %sysfunc(rand(uniform)))))_;
    %global &mcArray.LBOUND &mcArray.HBOUND &mcArray.N;
    %let &mcArray.LBOUND = 1;
    %let &mcArray.HBOUND = &VarCnt.;
    %let &mcArray.N      = &VarCnt.;
    %let rc = %sysfunc(doSubL( /*%nrstr(%%put ;)*/
    /*===============================================================================================*/
      options nonotes nosource %str(;)
      DATA _NULL_ %str(;)
       IF %unquote(&VarCnt.) > 0
       THEN
         CALL SYMPUTX("&mtext.",
          ' %MACRO ' !! "&mcArray." !! '(J,M);' !!
          '%local J M; %if %qupcase(&M.)= %then %do;' !! /* empty value is output, I is input */
          '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&&&sysmacroname.&J.%end;' !!
          '%else %do; ' !!
            '%put WARNING:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
            '%put WARNING-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
            '%put WARNING-[Macroarray &sysmacroname.] Missing value is used.;' !!
          '%end;' !!
          '%end;' !!
          '%else %do; %if %qupcase(&M.)=I %then %do;' !!
          '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&sysmacroname.&J.%end;' !!
          '%else %do;' !!
            '%put ERROR:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
            '%put ERROR-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
          '%end;' !!
          '%end; %end;' !!
          '%MEND;', 'G') %str(;)
       ELSE
         CALL SYMPUTX("&mtext.", ' ', 'G') %str(;)
       STOP %str(;)
      RUN %str(;)
    /*===============================================================================================*/
    )); &&&mtext. %symdel &mtext. / NOWARN ;
    %put NOTE:[&sysmacroname.] &VarCnt. macro variables created;
  /*-----------------------------------------------------------------------------------------------------------*/
  %end;
%mend bgetVars;
