
%macro utl_update
   (
      master=
     ,transaction=
     ,key=
    )
    / des="Update Insert Delete in Sybase Table";

/*----------------------------------------------------------*\
|  Make oldrep look exactly like newrep by applying          |
|  the delta dateset using utldmod                           |
|  utl_update is the same as macro above                     |
|  Transaction dataset must contain __type variable          |
|  with the value UPDATE, INSERT or DELETE                   |
\*----------------------------------------------------------*/

 /*-------------------------------------------------*\
 |  This object applyes a transaction dataset to     |
 |  a master RDBMS table or SAS dataset. The result  |
 |  is an updated master ( RDBMS data )              |
 \*-------------------------------------------------*/

 /*----------------------------------------------*\
 |  IPO                                           |
 |    Inputs                                      |
 |    ======                                      |
 |      transaction - Transaction table must have |
 |               variable type which can          |
 |               have 3 values (SAS dataset)      |
 |               DELETE -- Delete Row in Master   |
 |               INSERT -- Insert Row in Master   |
 |               UPDATE -- Update Row in Master   |
 |      key   - unique index                      |
 |                                                |
 |    Process  - Modify SAS/RDBMS Table           |
 |    ======     based on transaction file        |
 |                                                |
 |    Output   - master Modified                  |
 |    ======                                      |
 |    Transaction table can be in work library    |
 \*----------------------------------------------*/

 data &master;
   modify &master &transaction;
   by &key;
   select (_iorc_);
     when (%sysrc(_dsenmr))   /* nomatch in MASTER _Add */
       do;
          if __type="INSERT" then output &master;
          *put "Nomatch" __type=;
          _error_=0;
       end;
     when (%sysrc(_sok))   /* matched Update or Delete */
       do;
          *put "Matched " __type=;
          if      __type="DELETE" then remove  &master;
          else if __type="UPDATE" then replace &master;
          _error_=0;
       end;
     otherwise
       do;
          put "Unexpected ERROR Condition: _IORC_ =" _IORC_;
          _error_=0;
       end;
   end;
run;
%mend utl_update;

%macro utl_delta
    (
     uinmem1 =work.oldrep,       /* Last Months Data */
     uinmem2 =work.newrep,       /* Current Month Data */
     uinkey  =rep_socs,           /* primary unique key both tables */
     uotmem1 =repdelta,         /* delta tble for RDBMS update */
     uotmem2 = repsame           /* records that do not change  */
    )
    / des = "Build delta SAS table for RDBMS update";
    /*----------------------------------------------*\
    |  WIN95 SAS611   --  UNIX SAS611 SOLARIS 2.5    |
    |                                                |
    |                                                |
    |  Create a delta ( transaction ) dataset        |
    |  based on a comparison of old and new data.    |
    |                                                |
    |  Use this new delta dataset to bring older     |
    |  RDBMS table up to date. ( invoke utldmod )    |
    |                                                |
    |  Proc compare new feed against updated RDBMS   |
    |  Result should be an exact comparison          |
    |                                                |
    |  You are probably asking why not just drop     |
    |  the RDBMS table and load the new table.       |
    |                                                |
    |  1. As a rule we keep SAS image tables         |
    |     of most read only RDBMS tables.            |
    |     And it is very easy to do detailed analysis|
    |     such as this before any major sales        |
    |     representative alnment.                  |
    |                                                |
    |  2. The delta dataset is very useful for QC,   |
    |     before updating RDBMS tables.              |
    |                                                |
    |  3. Table may reside in as many as three       |
    |     different databases on different platforms.|
    |     (Oracle, Sybase, Watcom, MS-Access)        |
    |     This plays to SASes strength               |
    |                                                |
    |  This code represents a slhtly new           |
    |  methodology and as such has not been          |
    |  completely tested. CompuCraft would           |
    |  greatly appreciate any feedback.              |
    \*----------------------------------------------*/

    /*%^&*------------------------------------------*\
    | Description:                                   |
    |  Create a delta ( transaction ) dataset        |
    |  based on new data.                            |
    |                                                |
    |  This code creates the delta ( transaction )   |
    |  dataset.                                      |
    |                                                |
    |  IPO                                           |
    |   INPUTS                                       |
    |   ======                                       |
    |   Old table ( previous month - in RDBMS )      |
    |   (ie OLSSNJOB)                                |
    |                                                |
    |       SSN         JOB            ACTIVE        |
    |                                                |
    |      001001110  carpenter1       YES           |
    |      002001110  plumber1         YES           |
    |      003001110  mason1           YES           |
    |      004001110  plumber1         YES           |
    |      005001110  electrician1     YES           |
    |      006001110  mason3           YES           |
    |      008001110  mason4           NO            |
    |                                                |
    |   New table ( New data not in RDBMS )          |
    |   (ie NUSSNJOB)                                |
    |                                                |
    |       SSN         JOB            ACTIVE        |
    |                                                |
    |      001001110  carpenter1       YES           |
    |      002001110  plumber1         YES           |
    |      003001110  painter1         YES           |
    |      004001110  plumber1         YES           |
    |      005001110  electrician1     YES           |
    |      007001110  painter2         YES           |
    |                                                |
    |   PROCESS                                      |
    |   =======                                      |
    |    Extract the old data from the RDBMS.        |
    |                                                |
    |    Union old and new data. Put an indicator    |
    |    variable on union. This variable            |
    |    identifies the orin of record ( old/new). |
    |                                                |
    |    Sort the union table on all fields.         |
    |                                                |
    |    If record appears only in the old table     |
    |    then deactivate the record. ( DELETE )      |
    |                                                |
    |    If a record appears only in the new data    |
    |    ( at least one field makes record diff)     |
    |    and the key appears in both new and old     |
    |    data then perform an update ( UPDATE )      |
    |                                                |
    |    If a record appears only in the new data    |
    |    and the key does not appear in old table    |
    |    then perform an insert ( INSERT )           |
    |                                                |
    |    If the record is exactly the same in        |
    |    both tables then leave it alone             |
    |                                                |
    |   OUTPUT                                       |
    |   ======                                       |
    |  Transaction data set                          |
    |                                                |
    |     SSN       JOB     ACTIVE          __TYPE   |
    |                                                |
    |  006001110    mason3       YES       DELETE    |
    |  008001110    mason4       NO        DELETE    |
    |  007001110    painter2     YES       INSERT    |
    |  003001110    painter1     YES       UPDATE    |
    |                                                |
    \*%^&*------------------------------------------*/

 /*  for testing without macro
 %let uinmem1 =oldrep;
 %let uinmem2 =newrep;
 %let uinkey  =rep_socs;
 %let uotmem1 =repdelta;
 %let uotmem2= repsame;
 */

 %put %sysfunc(ifc(%sysevalf(%superq(uinmem1)=,boolean),  **** Please Provide Previous dataset                  ,));
 %put %sysfunc(ifc(%sysevalf(%superq(uinmem2)=,boolean),  **** Please Provide Current dataset                   ,));
 %put %sysfunc(ifc(%sysevalf(%superq(uinkey)=,boolean),**** Please Provide primary unique key both tables    ,));
 %put %sysfunc(ifc(%sysevalf(%superq(uotmem1)=,boolean),**** Please Provide transaction records dataset       ,));
 %put %sysfunc(ifc(%sysevalf(%superq(uotmem2)=,boolean), **** Please Provide records that do not change dataset,));

 %if %eval(
    %sysfunc(ifc(%sysevalf(%superq(uinmem1)=,boolean),1,0)) +
    %sysfunc(ifc(%sysevalf(%superq(uinmem2)=,boolean),1,0)) +
    %sysfunc(ifc(%sysevalf(%superq(uinkey)=,boolean),1,0)) +
    %sysfunc(ifc(%sysevalf(%superq(uotmem1)=,boolean),1,0)) +
    %sysfunc(ifc(%sysevalf(%superq(uotmem2)=,boolean),1,0))
    ) eq 0 %then %do;

    data utldlta1
         (
          label = "Union of current & previous month"
         )
         / view=utldlta1;
       retain &uinkey;
       set  &uinmem1 ( in = prevmnth )
            &uinmem2 ( in = currmnth );
       if prevmnth then __split = "OLD";
       else __split = "NEW";
    run;
    proc sql;
        select
            name into : ucols separated by ' '
        from
            dictionary.columns
         where
            libname = %upcase('work')         and
            memname = %upcase ( 'utldlta1' )  and
            name not eq %upcase( '__split' );
    quit;
    %put ucols = &ucols;
    proc sort data = utldlta1  out = utldlta2;
        by &ucols __split;
    run;
    %let uwrds = %sysfunc(countw(&ucols));
    %let ulastcol = %scan (&ucols, &uwrds );
    data utldlta3
         (
          label = "Transactions"
         )
         &uotmem2
         (
          label = "No change"
         );
        set utldlta2;
        by &ucols;
        retain __split __type;
        select;
            /* Only in previous month */
            when ( ( first.&ulastcol eq last.&ulastcol ) and __split = "OLD") do;
                if ( first.&uinkey eq last.&uinkey ) then do; /* unique record */
                    __type="DELETE";                          /* key unique    */
                    output utldlta3;                          /* OLD data only */
                end;
                else do;                                      /* unique record */
                    __type = "UPDATE";                        /* key same      */
                    output &uotmem2;                      /* other field changed */
                end;
            end;
            /* Only in new month */
            when ( first.&ulastcol eq last.&ulastcol ) do;    /* unique record */
                if ( first.&uinkey eq last.&uinkey ) then do; /* new key       */
                    __type = "INSERT";
                    output utldlta3;
                end;
                else do;                                      /* unique record */
                    __type = "UPDATE";                        /* same key      */
                    output utldlta3;                          /* new data only */
                end;
            end;

            /* Duplicate records same in both months */
            when ( first.&ulastcol ne last.&ulastcol ) do;    /* duplicate record  */
                output &uotmem2;
            end;
        otherwise put "ERROR ===========> NEVER SAY NEVER <=============== ERROR";
        end;
    run;
    proc sort data=utldlta3
        out=&uotmem1
        (
        label = "Transaction dataset"
        index = ( &uinkey   / unique )
        );
    by __type;
    run;
    %macro utl_nlobs(dsn);
       %let dsid=%sysfunc(open(&dsn));%sysfunc(attrn(&dsid,nlobs)) %let rc=%sysfunc(close(&dsid));
    %mend utl_lnobs;
    proc print data=&uinmem1
(obs=30) width=minimum noobs;
    title "Old RDBMS Data obs=%utl_nlobs(&uinmem1)";
    run;
    proc print data=&uinmem2(obs=30) width=minimum noobs;
    title "New Feed Data obs=%utl_nlobs(&uinmem2)";
    run;
    proc print data=&uotmem1(obs=30) width=minimum noobs;
    title "Transaction data set obs=%utl_nlobs(&uotmem1)";
    run;
    proc print data=&uotmem2(obs=30 drop=__type) width=minimum noobs;
    title "No change data set obs=%utl_nlobs(&uotmem2)";
    run;
    /*----------------------------------------------------------*\
    |  Make oldrep look exactly like newrep by applying          |
    |  the delta dateset using utldmod                           |
    \*----------------------------------------------------------*/

    /*

   data oldrep;
     input rep_socs : $9. JOB  : $16. ACTIVE  : $3.;
   cards;
      001001110  carpenter1       YES
      002001110  plumber1         YES
      003001110  mason1           YES
      004001110  plumber1         YES
      005001110  electrician1     YES
      006001110  mason3           YES
      008001110  mason4           NO
   ;
   run;
   data newrep;
     input rep_socs : $9. JOB  : $16. ACTIVE  : $3.;
   cards;
      001001110  carpenter1       YES
      002001110  plumber1         YES
      003001110  painter1         YES
      004001110  plumber1         YES
      005001110  electrician1     YES
      007001110  painter2         YES
   ;
   run;

   %utl_delta
    (
     uinmem1 =oldrep,
     uinmem2 =newrep,
     uinkey  =rep_socs,
     uotmem1 =repdelta,
     uotmem2= repsame
    );
    %utl_delta;

    proc sort data=dat.oldrep out=ol;by rep_socs;run;
    proc sort data=dat.newrep out=nu;by rep_socs;run;

    title "Indepth comparison Updated RDMS table with New Feed";

    proc compare data=ol compare=nu;
    run;
    */
 %end; /* end macro argument checks */

%mend utl_delta;


data oldrep;  /* rep_socs is primary ket */
  input rep_socs : $9. JOB  : $16. ACTIVE  : $3.;
cards;
   001001110  carpenter1       YES
   002001110  plumber1         YES
   003001110  mason1           YES
   004001110  plumber1         YES
   005001110  electrician1     YES
   006001110  mason3           YES
   008001110  mason4           NO
;
run;

data newrep;
  input rep_socs : $9. JOB  : $16. ACTIVE  : $3.;
cards;
   001001110  carpenter1       YES
   002001110  plumber1         YES
   003001110  painter1         YES
   004001110  plumber1         YES
   005001110  electrician1     YES
   007001110  painter2         YES
;
run;

%utl_delta
    (
     uinmem1 =oldrep,       /* Last Months Data */
     uinmem2 =newrep,       /* Current Month Data */
     uinkey  =rep_socs,      /* primary unique key both tables */
     uotmem1 =repdelta,   /* delta tble for RDBMS update */
     uotmem2= repsame
    );

%utl_update
   (
    master=oldrep
   ,transaction=repdelta
   ,key=rep_socs
   );

proc sort data=oldrep out=ol;by rep_socs;run;  /* oldrep has been updated with transactions and now is equal to newrep */
proc sort data=newrep out=nu;by rep_socs;run;
title "Indepth comparison Updated RDMS table with New Feed";

proc compare data=ol compare=nu;
run;
