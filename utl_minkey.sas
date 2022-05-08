%macro utl_minkey(sdtm,keys=);

/****************************************************************************************************************************/
/*                                                                                                                          */
/*  This macro function can find a minimum primary key given a candidate primary key                                        */
/*                                                                                                                          */
/*  The code uses several external macros                                                                                   */
/*                                                                                                                          */
/*  1. UTL_COMBOS                                                                                                           */
/*     Author: Michael Friendly   <friendly@yorku.ca>                                                                       */
/*  2. ARRAY abd DO_OVER                                                                                                    */
/*     Ted Clay, M.S.   tclay@ashlandhome.net                                                                               */
/*  3. ARRAYDELETE                                                                                                          */
/*                                                                                                                          */
/*  The code stops as soon as it finds a mininmum compound primary key.                                                     */
/*  It does not find multiple primary keys of equal length                                                                  */
/*  _            _                                                                                                          */
/* | |_ ___  ___| |_    ___ __ _ ___  ___  ___                                                                              */
/* | __/ _ \/ __| __|  / __/ _` / __|/ _ \/ __|                                                                             */
/* | ||  __/\__ \ |_  | (_| (_| \__ \  __/\__ \                                                                             */
/*  \__\___||___/\__|  \___\__,_|___/\___||___/                                                                             */
/*      _                     _ _                                                                                           */
/*   __| |_   _ _ __     __ _| | | __   ____ _ _ __ ___                                                                     */
/*  / _` | | | | `_ \   / _` | | | \ \ / / _` | `__/ __|                                                                    */
/* | (_| | |_| | |_) | | (_| | | |  \ V / (_| | |  \__ \                                                                    */
/*  \__,_|\__,_| .__/   \__,_|_|_|   \_/ \__,_|_|  |___/                                                                    */
/*             |_|                                                                                                          */
/*                                                                                                                          */
/*   Testing this Key                                                                                                       */
/*                                                                                                                          */
/*  OUTPUT                                                                                                                  */
/*  ======                                                                                                                  */
/*                                                                                                                          */
/*    NAME SEX AGE HEIGHT                                                                                                   */
/*                                                                                                                          */
/*    First two obs have all variables equal even variables not in key                                                      */
/*                                                                                                                          */
/*    proc sql;                                                                                                             */
/*     Create table dm (NAME varchar(7), SEX varchar(7),AGE varchar(7),HEIGHT varchar(7),WEIGHT varchar(7),DMSEQ num);      */
/*     insert into dm _combos("Alfred","M","11","69","88",1);                                                               */
/*     insert into dm _combos("Alfred","M","11","69","88",2);                                                               */
/*     insert into dm _combos("Alfred","F","12","69","88",3);                                                               */
/*    quit;                                                                                                                 */
/*                                                                                                                          */
/*    FIRST TWO OBSERVATIONS ARE DUPLICATES ON ALL VARIABLES                                                                */
/*                                                                                                                          */
/*    Up to 40 obs from DM total obs=3 26APR2022:12:09:26                                                                   */
/*                                                                                                                          */
/*    Obs     NAME     SEX    AGE    HEIGHT    DMSEQ                                                                        */
/*                                                                                                                          */
/*     1     Alfred     M     11       69        1                                                                          */
/*     2     Alfred     M     11       69        2                                                                          */
/*     3     Alfred     F     12       69        3                                                                          */
/*                                                                                                                          */
/* PROCESS                                                                                                                  */
/* =======                                                                                                                  */
/*                                                                                                                          */
/* %utl_minkey(work.dm,keys=name sex age height);                                                                           */
/*                                                                                                                          */
/*  OUTPUT                                                                                                                  */
/*  ======                                                                                                                  */
/*                                                                                                                          */
/*  Duplicates using all variables except dmseq - need to add keys                                                          */
/*                                                                                                                          */
/*  Obs     NAME     SEX    AGE    HEIGHT                                                                                   */
/*                                                                                                                          */
/*   1     Alfred     M     11       69                                                                                     */
/*   2     Alfred     M     11       69                                                                                     */
/*       _                             _                                                                                    */
/*    __| |_   _ _ __     ___  _ __   | | _____ _   _                                                                       */
/*   / _` | | | | `_ \   / _ \| `_ \  | |/ / _ \ | | |                                                                      */
/*  | (_| | |_| | |_) | | (_) | | | | |   <  __/ |_| |                                                                      */
/*   \__,_|\__,_| .__/   \___/|_| |_| |_|\_\___|\__, |                                                                      */
/*              |_|                             |___/                                                                       */
/*                                                                                                                          */
/*     Key: NAME SEX AGE HEIGHT                                                                                             */
/*                                                                                                                          */
/*     First two obs have dups on key (Height is different)                                                                 */
/*                                                                                                                          */
/*     proc sql;                                                                                                            */
/*      Create table ex (NAME varchar(7),SEX varchar(7),AGE varchar(7),HEIGHT varchar(7),WEIGHT varchar(7)EXSEQ num);       */
/*      insert into ex _combos("Alfred","M","11","69","77",1);                                                              */
/*      insert into ex _combos("Alfred","M","11","69","89",2);                                                              */
/*      insert into ex _combos("Alfred","F","13","55","90",3);                                                              */
/*     quit;                                                                                                                */
/*                                                                                                                          */
/*    Primary key SEX AGE HEIGHT                                                                                            */
/*                                                                                                                          */
/*    Up to 40 obs from DM total obs=3 26APR2022:13:07:49                                                                   */
/*                                                                                                                          */
/*    Obs     NAME     SEX    AGE    HEIGHT    DMSEQ                                                                        */
/*                                                                                                                          */
/*     1     Alfred     M     11       69        2                                                                          */
/*     2     Alfred     M     11       69        3                                                                          */
/*     3     Alfred     F     12       69        1                                                                          */
/*                                                                                                                          */
/*    __ _           _       _                _              _                                                              */
/*   / _(_)_ __   __| |  ___| |__   ___  _ __| |_ ___ _ __  | | _____ _   _                                                 */
/*  | |_| | `_ \ / _` | / __| `_ \ / _ \| `__| __/ _ \ `__| | |/ / _ \ | | |                                                */
/*  |  _| | | | | (_| | \__ \ | | | (_) | |  | ||  __/ |    |   <  __/ |_| |                                                */
/*  |_| |_|_| |_|\__,_| |___/_| |_|\___/|_|   \__\___|_|    |_|\_\___|\__, |                                                */
/*                                                                     |___/                                                */
/*                                                                                                                          */
/*    FIND THE SHORTED KEY   TO ADD VARIABLES                                                                               */
/*                                                                                                                          */
/*     PROGRAM SELECT SEX AGE HEIGHT                                                                                        */
/*                                                                                                                          */
/*     proc sql;                                                                                                            */
/*      Create table vs (NAME varchar(7), SEX varchar(7),AGE varchar(7),HEIGHT varchar(7),WEIGHT varchar(7),VSSEQ num);     */
/*      insert into vs _combos("Alfred","F","11","69","88",1);                                                              */
/*      insert into vs _combos("Alfred","M","21","69","88",2);                                                              */
/*      insert into vs _combos("Alfred","M","11","70","88",3);                                                              */
/*     quit;                                                                                                                */
/*                                                                                                                          */
/*                                                                                                                          */
/************************************************************************ ***************************************************/

%local _idx _res _nlobs;

title;
footnote;

 /*
   %let sdtm=work.dm;
   %let keys=name sex age height weight;
 */

 %put %sysfunc(ifc(%sysevalf(%superq(sdtm )=,boolean) ,**** Please Provide input dataset ie libref.dm  ****,));
 %put %sysfunc(ifc(%sysevalf(%superq(keys )=,boolean), **** Please Provide a candidate key ie minkey=name age  ****,));

 %let _res= %eval
 (
     %sysfunc(ifc(%sysevalf(%superq(sdtm )=,boolean),1,0))
   + %sysfunc(ifc(%sysevalf(%superq(keys )=,boolean),1,0))
 );

  %if &_res = 0 %then %do;

      %let _seq=%substr(&sdtm,%eval(%length(&sdtm)-1),2)seq;

      proc sort data=&sdtm out=_utl_minKeyAll (drop=&_seq) nouniquekey noequals;
           by _all_;
      run;quit;

      %if %utl_nlobs(_utl_minKeyAll) ne 0 %then %do;
          %put xxx  Duplicates using all variables except &_seq xxx;
          proc print data=_utl_minKeyAll(obs=3) width=min;
            title "Duplicates using all variables except &_seq - There may not be a usable primary key";
          run;quit;
          %goto done;
      %end;

      proc sort data=&sdtm out=_utl_minKeyCan(keep=&keys) nouniquekey noequals;
          by &keys;
      run;quit;

      %if %utl_nlobs(_utl_minKeyCan) ne 0 %then %do;
          %put xxx  Duplicates using candidate key xxx;
          proc print data=_utl_minKeyCan(obs=3) width=min;
            title "Duplicates on candidate key  &_seq - add some of the other variables?";
          run;quit;
          %goto done;
      %end;

  %end;

  %let _numKey = %sysfunc(countw(&keys));
  %put &=_numkey;

  %do _idx=1 %to &_numkey;

    /* %let _idx=2;  */

    %if &_idx=1 %then %do;
        proc datasets lib=work nolist nodetails;
            delete _utl_minkey;
        run;quit;
    %end;

    %put &=keys;
    %utl_combos(&keys,&_idx,result=_combos,join=@);
    %put &=_combos;

    %let _combos=%qsysfunc(compbl(&_combos));
    %put &=_combos;

    %let _combos=%qsysfunc(tranwrd(&_combos,%str(@  ),@));
    %put &=_combos;

    %let _combos=%qsysfunc(translate(&_combos,%str(@ ),@));
    %put &_combos;

    %array(_ky,values=&_combos,delim=@);

    %put &=_ky1;
    %put &=_ky3;
    %put &=_kyn;

    %do_over(_ky,phrase=%str(
        proc sort data=&sdtm(keep=?) out=_utlTmp noequals nouniquekey;
           by ?;
        run;quit;
        proc sql ;
          create
             table _utlSql as
          select
             upcase("&sdtm")          as  table length=44
             ,"?"                     as  key length=44
             ,put(count(*),comma16.)  as  Dups_Groups length=16
             ,countw("?")             as  length
             ,(select count(*) from &sdtm) as total_obs
             ,case
                 when (count(*)=0) then  "Primary Key"
                 else                    "Dup Obs"
              end as Key_Type
          from
             _utlTmp
        ;quit;
        proc append data=_utlSql base=_utl_minkey;
        run;quit;
        ));

       proc sort data=_utl_minkey out=_utl_minKeyFin;
          by  Dups_Groups length;
       run;quit;

       proc print data=_utl_minKeyFin width=min;
           title "Minimum length primary keys - Supplied Key &keys";
       run;quit;

  %end;

%done: %mend utl_minkey;
