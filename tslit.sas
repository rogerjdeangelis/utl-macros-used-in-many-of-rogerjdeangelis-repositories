/*---------------------------------------------------------------------
*
*                 SAS  TEST  LIBRARY
*
*      NAME: tslit.sas
*     TITLE: %tslit - puts single quotes around input value
*     INPUT:
*    OUTPUT: none
*  SPEC.REQ:
*   SUPPORT: flash - gordon Keener
*            domcge - Don McGee - Dev Testing Austin (DTA)
*            04May06 domcge - updated macro with Gordon Keener's version.
*-------------------------------------------------------------------*/

/*********************************************************************
 NAME: tslit
 FUNCTION: puts single quote around the input value.  This comes in
           useful when needing to evaluate a macro variable and at the
           same time put singe quotes (') around the value.

           For example:
           %put %tslit(test);           ---  will output 'test' to the log

           %put %tslit(&SYSHOSTNAME);   --- will output the value in &SYSHOSTNAME
                                            in single quotes, ie. 'rdaw3squad'

           An example in PROC TSSQL:
           proc tssql;
              CREATE TABLE tab1(var1 CHAR(10));

              INSERT INTO tab1 VALUES(%tslit(&SYSHOSTNAME));

              --- The following will produce an error because it ---
              --- it thinks it is looking for a column name.     ---
              INSERT INTO tab1 VALUES("&SYSHOSTNAME");

              SELECT * FROM tab1;

              DROP TABLE tab1;
           quit;

           The log:
           31              proc tssql;
           32                 CREATE TABLE tab1(var1 CHAR(10));
           NOTE: Execution succeeded. No rows affected.


           33
           34                 INSERT INTO tab1 VALUES(%tslit(&SYSHOSTNAME));
           NOTE: Execution succeeded. One row affected.


           35
           36                 INSERT INTO tab1 VALUES("&SYSHOSTNAME");
           ERROR:   Column not found ERROR:   column "rdaw3squad" not found

           37
           38                 SELECT * FROM tab1;

                                           VAR1
                                           ----------
                                           rdaw3squad

           39
           40                 DROP TABLE tab1;
           NOTE: Execution succeeded. No rows affected.


           41              quit;


           NOTE: PROCEDURE TSSQL used (Total process time):
                 real time           0.25 seconds
                 cpu time            0.23 seconds

**********************************************************************/


/*********************************************************************
* This version of the macro was provided by Gordon Keener.  It will  *
* work in the datastep because it unquotes the result at the end.    *
* It also uses the datastep function quote to added the necessary    *
* values to the input value.                                         *
*********************************************************************/
%macro tslit(value);
   %local s1 s2 v1 v2 v3;

   %let s1 = %str(%'%");
   %let s2 = %str(%"%');

   %let v1 = %qsysfunc(translate(&value, &s1, &s2));

   %let v2 = %qsysfunc(quote(&v1));

   %let v3 = %qsysfunc(translate(&v2, &s2, &s1));

   %unquote(&v3)
%mend;
