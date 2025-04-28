/**************************************************************************************************************************/
/*  Name: utl_concat.sas                                                                                                  */
/*  Type: Macro function                                                                                                  */
/*  Description: Returns macro variable _vals                                                                             */
/*  Parameters:                                                                                                           */
/*          Data       - Name of table <libname.>memname                                                                  */
/*          VAR        - Variable values to cocatenate                                                                    */
/*          UNIQUE     - N,Y  Unique vales of variable                                                                    */
/*          Qstyle=    - Quote style:                                                                                     */
/*                         DOUBLE is like "Name" "Sex" "Weight"...                                                        */
/*                         SAS is like 'Name' 'Sex' 'Weight'...                                                           */
/*          Od         - %str( ) - Output delimiter                                                                       */
/*          PRX=      -  PRX expression                                                                                   */
/*                                                                                                                        */
/*  EXAMPLES                                                                                                              */
/*                                                                                                                        */
/*  data class;                                                                                                           */
/*   set sashelp.class(obs=5                                                                                              */
/*    keep=name sex);                                                                                                     */
/*   if _n_=3 then sex='U';                                                                                               */
/*  run;quit;                                                                                                             */
/*                                                                                                                        */
/*  *---- WITH QUOTES ----*;                                                                                              */
/*  %utl_concat(class,var=sex,unique=N,qstyle=DOUBLE,od=%str(,),prx="/^F/");   ;  "F","F"   * comma delimites             */
/*  %utl_concat(class,var=sex,unique=N,qstyle=DOUBLE,od=%str( ),prx="/^F/");   ;  "F" "F"   * space delimited             */
/*  %utl_concat(class,var=sex,unique=N,qstyle=DOUBLE,od=%str(,));              ;  "M","F","U","F","M"                     */
/*  %utl_concat(class,var=sex,unique=N,qstyle=DOUBLE,od=%str( ));              ;  "M" "F" "U" "F" "M"                     */
/*  %utl_concat(class,var=sex,unique=N,qstyle=SAS,od=%str(,),prx="/^F/");      ;  'F','F'                                 */
/*  %utl_concat(class,var=sex,unique=N,qstyle=SAS,od=%str( ),prx="/^F/");      ;  'F' 'F'                                 */
/*  %utl_concat(class,var=sex,unique=N,qstyle=SAS,od=%str(,));                 ;  'M','F','U','F','M'                     */
/*  %utl_concat(class,var=sex,unique=N,qstyle=SAS,od=%str( ));                 ;  'M' 'F' 'U' 'F' 'M'                     */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=DOUBLE,od=%str(,),prx="/^F|U/"); ;  "F","U"                                 */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=DOUBLE,od=%str(,),prx="/^F|U/"); ;  "F","U"                                 */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=DOUBLE,od=%str(,));              ;  "F","M","U"                             */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=DOUBLE,od=%str( ));              ;  "F" "M" "U"                             */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=SAS,od=%str(,),prx="/^F|U/");    ;  'F','U'                                 */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=SAS,od=%str( ),prx="/^F|U/");    ;  'F' 'U'                                 */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=SAS,od=%str(,));                 ;  'F','M','U'                             */
/*  %utl_concat(class,var=sex,unique=Y,qstyle=SAS,od=%str( ));                 ;  'F' 'M' 'U'                             */
/*                                                                             ;                                          */
/*  *---- WITHOUT QUOTES ----*;                                                                                           */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str(,),prx="/^F/");            ;   F,F                                    */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str( ),prx="/^F/");            ;   F F                                    */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str(,),return=vals);           ;   M,F,U,F,M                              */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str( ));                       ;   M F U F M                              */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str(,),prx="/^F/");            ;   F,F                                    */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str(),prx="/^F/");             ;   FF                                     */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str(,));                       ;   M,F,U,F,M                              */
/*  %put %utl_concat(class,var=sex,unique=N,od=%str( ));                       ;   M F U F M                              */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str(,),prx="/^F/");            ;   F                                      */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str(,),prx="/^F/");            ;   F                                      */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str(,));                       ;   F,M,U                                  */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str( ));                       ;   F M U                                  */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str(,),prx="/^F/");            ;   F                                      */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str( ),prx="/^F/");            ;   F                                      */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str(,));                       ;   F,M,U                                  */
/*  %put %utl_concat(class,var=sex,unique=Y,od=%str( ));                       ;   F M U                                  */
/**************************************************************************************************************************/
%macro utl_concat(data,var=name,unique=N,qstyle=,od=%str( ),prx=%str("/./"));
  %symdel _vals / nowarn;
  %global _vals ;
  %if &unique=N & &qstyle=DOUBLE %then %do;
     %dosubl(%nrstr(
       proc sql noprint;
        select quote(strip(&var)) into: _vals separated by "&od" from &data where prxmatch(&prx,&var)
       ;quit;
     ))
  %end;
  %else %if &unique=N & &qstyle=SAS %then %do;
     %dosubl(%nrstr(
      proc sql noprint;
        select quote(strip(&var)) into: _vals separated by " " from &data  where prxmatch(&prx,&var)
       ;quit;
       ))
      %let _vals =%sysfunc(tranwrd(%str(&_vals),%str(%"),%str(%')));
      %let _vals =%sysfunc(tranwrd(%str(&_vals),%str( ),%str(&od)));
  %end;
  %else %if &unique=Y & &qstyle=DOUBLE %then %do;
     %dosubl(%nrstr(
       proc sql noprint;
        select distinct(quote(strip(&var))) into: _vals separated by "&od" from &data  where prxmatch(&prx,&var)
       ;quit;
     ))
  %end;
  %else %if &unique=Y & &qstyle=SAS %then %do;
     %dosubl(%nrstr(
       proc sql noprint;
        select distinct(quote(strip(&var))) into: _vals separated by " " from &data  where prxmatch(&prx,&var)
       ;quit;
     ))
      %let _vals =%sysfunc(tranwrd(%str(&_vals),%str(%"),%str(%')));
      %let _vals =%sysfunc(tranwrd(%str(&_vals),%str( ),%str(&od)));
  %end;
  %else %if &unique = N %then %do;
     %dosubl(%nrstr(
       proc sql noprint;
        select &var into: _vals separated by "&od" from &data  where prxmatch(&prx,&var)
       ;quit;
     ))
  %end;
  %else %if %substr(%upcase(&unique),1,1) =Y %then %do;
     %dosubl(%nrstr(
       proc sql noprint;
        select distinct(&var) into: _vals separated by "&od" from &data  where prxmatch(&prx,&var)
       ;quit;
     ))
  %end;
  &_vals
%mend utl_concat;
