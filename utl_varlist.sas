/************************************************************
         Name: VarList.sas
         Type: Macro function
  Description: Returns variable list from table
   Parameters:
           Data       - Name of table <libname.>memname
           Keep=      - variables to keep
           Drop=      - variables to drop
           Qstyle=    - Quote style:
                          DOUBLE is like "Name" "Sex" "Weight"...
                          SAS is like 'Name'n 'Sex'n 'Weight'n...
                          Anything else is like Name Sex Weight...
           Od=%str( ) - Output delimiter
           prx=       - PRX expression
       Notes: An error provokes %ABORT CANCEL
    Examples:
           %put %varlist(sashelp.class,keep=_numeric_);
           %put %varlist(sashelp.class,qstyle=sas);
           %put %varlist(sashelp.class,qstyle=DOUBLE,od=%str(,));
           %put %varlist(sashelp.class,prx=/ei/i);
           %put %varlist(sashelp.class,prx=funky error); %* provokes error;

   Author: Søren Lassen, s.lassen@post.tele.dk
 **************************************************************/
 %macro utl_varlist(data,keep=,drop=,qstyle=,od=%str( ),prx=);
   %local dsid1 dsid2 i w rc error prxid prxmatch od2;

  %let qstyle=%upcase(&qstyle);

  %let dsid1=%sysfunc(open(&data));
   %if &dsid1=0 %then %do;
     %let error=1;
     %goto done;
     %end;

  %let dsid2=%sysfunc(open(&data(keep=&keep drop=&drop)));
   %if &dsid2=0 %then %do;
     %let error=1;
     %goto done;
     %end;

  %if %length(&prx) %then %do;
     %let prxid=%sysfunc(prxparse(&prx));
     %if &prxid=. %then %do;
       %let prxid=;
       %let error=1;
       %goto done;
       %end;
     %end;
   %else %let prxmatch=1;

  %do i=1 %to %sysfunc(attrn(&dsid1,NVARS));
     %let w=%qsysfunc(varname(&dsid1,&i));
     %if %sysfunc(varnum(&dsid2,&w)) %then %do;
       %if 0&prxid %then
         %let prxmatch=%sysfunc(prxmatch(&prxid,&w));
       %if &prxmatch %then %do;
         %if SAS=&qstyle %then
           %do;&od2.%str(%')%qsysfunc(tranwrd(&w,%str(%'),''))%str(%')n%end;
         %else %if DOUBLE=&qstyle %then
           %do;%unquote(&od2.%qsysfunc(quote(&w)))%end;
         %else
           %do;&od2.&w%end;
         %let od2=&od;
         %end;
       %end;
     %end;

%done:
   %if 0&dsid1 %then
     %let rc=%sysfunc(close(&dsid1));
   %if 0&dsid2 %then
     %let rc=%sysfunc(close(&dsid2));
   %if 0&prxid %then
     %syscall prxfree(prxid);
   %if 0&error %then %do;
     %put %sysfunc(sysmsg());
     %abort cancel;
     %end;

%mend utl_varlist;

