%let pgm=utl_classic_editor_command_macro_performance_package;
%let pgm=sas_saspac;

Aligning sas display manager command macros with SAs function keys, command line and logitech's G502 Hero Mouse

I posted a new classic editor performance package on github..

I purchased a new enhanced mouse with almost 30 programmable actions.
The mouse is the Logitech G502 Hero.
Many of the 46 command macros below can be mapped to the mouse.
All can also be executed from the command line.

/*                                             _
  ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |  _ __ ___   __ _  ___ _ __ ___  ___
 / __/ _ \| `_ ` _ \| `_ ` _ \ / _` | `_ \ / _` | | `_ ` _ \ / _` |/ __| `__/ _ \/ __|
| (_| (_) | | | | | | | | | | | (_| | | | | (_| | | | | | | | (_| | (__| | | (_) \__ \
 \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_| |_| |_| |_|\__,_|\___|_|  \___/|___/
*/


MACRO       USAGE                         DESCRIPTION

mish        Usage: mish sex age           Highlight dataset and type mish sex age and for crosstab of missings will appear in output window
_sv         Usage: pf1 or mmb             Save timestamped version of the program in the c:/ver folder and save program in c:/utl
sqldesh     Usage: sqldesh                Hilite table and type sqldesh and sql describe output will appear in log
sasbatch    Usage: sasbatch               Highlight code type sasbatch on command line
evlh        Usage: evlh                   Hilite expression 2*(3+1) and type evlh and 8 will appear in log
sumv        Usage: sumv                   Hilite a column of numbers and an proc means will run on the nummbes mean max min ...
xlrh        Usage: xlrh                   Hilite a table and type xlr and table will open it in excel. No need for pc acces to excel
sumr        Usage: sumr                   Hilite row of numbers type sumr and the sum will appear in the log and macro variable __sumr
iota        Usage: iota                   Type iota 10 and 10 rows with 01 02 03 - 10 will be added to the editor
cuth        Usage: cuth                   Hilite a block of code and type cuth and mutiple spaces will be reduced to single spaces
parh        Usage: parh                   Hilite a line of code and type parh to test for unbalanced parens
xit         Usage: xit                    When exiting sas type xit and last program will open next time you start SAS
cntuh       Usage: cntuh                  Hilite table and count distinct usubjid and number of obs are in pastdmphe buffer *usubjis is hardcoded)
cliph       Usage: cliph                  Hilite a line of and macro variable _clip will contain the statement
cnth        Usage: cnth sex age           Hilite table and type cnth age sex and distinct counts of age sex cobinations in paste buffer and output eindow
avgby       Usage: avgby sex age          Hilite table type avgby sex age for means by sex age also output dataset avgby
tail        Usage: tail                   Type tail and last 40 obs of last dataset in paste buffer and output window
tailh       Usage: tail                   Hilite table and type tailh and the last 40 obs will be in output window and in paste buffer
ls4         Usage: ls4                    Type ls and a list of first 40 obs of last table in output window and paste buffer
lsh         Usage: lsh                    Type lsh for list and output in paste buffer of hilited table
lsfh        Usage: lsfh                   Hilight table type lsfh for 40 obs formatted list and output in paste buffer
lsa         Usage: lsa                    Ttpe lsal to list all obs from the last dataset
lsah        Usage: lsah                   Type lsah for a list of all obs in output and in paste buffer of hilited table
doendh      Usage: foendh                 Hilite block of macro code and match do and end will be tested
lsw         Usage: lsw [dq]]age=14[dq]    Use single and double quotes for chars, 40  filtered for  the _last_ table in pastebuffer and list
avgh        Usage: avgh                   Hilite table and type avgh for proc means output and table avgh will be created
frqv        Usage: frqv                   Hilite variable in _last_ table andn proc freq hiltred variable
cntv        Usage: cntv                   Hilight variable in _last_ table and get count and distinct counts on variable
unvv        Usage: unv                    Hilite a variable from the _last_ table and proc unvariate will be run on that variable
unvh        Usage: unvh                   proc univariate on hilited dataset
rpth        Usage: rpth                   Generate proc report code on hilited dataset. Good template to edit.
dmp         Usage: dmp                    Type dmp and middle observation of last dataset printed vertically
dmph        Usage: dmph                   Type dmph middle observation of highlighted dataset printed vertically with type length and sample values
frq         Usage: frq sex age            Type frq type sex for a crosstab frequency on sex*age for last dataset.akes frq dataset
frqh        Usage: frqh sex age           Highlight dataset and type frqh sex age and  forfrequency on sex xage. Also frqh dataset.
debugh      Usage: debugh                 Highlight macro and type debugh to debug the macro (generates final code and runs it)
con         Usage: con                    Type con and contents of last dataset in outptut
conh        Usage: conh                   Highlight table and type conh on command line. Contents in output window
cm          Usage: cm                     Hilite the blank line and subsequent block of code and the code will be commented out
vu          Usage: vu                     Type vu for viewtable of last dataset created
vuh         Usage: vuh                    Type vuh for viewtable of highlighted dataset
xlsh        Usage: xlsh                   Highlight table and type xlsh and the table  will appear in excel uses libname need pc acces
xplo        Usage: xplo ONEaTWO           Type xplo ONEaTWO and exploded letters will be saved in past buffer. Use lower case for spaces
unqh        Usage: unqh sex age           Distinct counts. Usubjid must be in the datasets
keylist     Usage: keylist                Type keylist and a list og your function keys will be in the log
xpy         Usage: xpy roger              Type xpy roger for program banner with large font https://github.com/rogerjdeangelis/utl_program_banners

/*__                  _   _               _
 / _|_   _ _ __   ___| |_(_) ___  _ __   | | _____ _   _ ___
| |_| | | | `_ \ / __| __| |/ _ \| `_ \  | |/ / _ \ | | / __|
|  _| |_| | | | | (__| |_| | (_) | | | | |   <  __/ |_| \__ \
|_|  \__,_|_| |_|\___|\__|_|\___/|_| |_| |_|\_\___|\__, |___/
                                                   |___/
*/

Obs    L1L2

  1    F1 home;_sv;
  2    F2 home;copy cmt;
  3    F3 ~run run;quit;
  4    F4 notesubmit;
  5    F5 cntv
  6    F6 home;
  7    F7 log;file "c:\log\&pgm..log";note z;notesubmit '%utl_logcurchk;';
  8    F8 rfind
  9    F9 rchange
 10    F11 ~ru run;quit;
 11    F12 ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
 12    SHF F1 lsa
 13    SHF F2 con
 14    SHF F6 dmph
 15    SHF F7 avghby
 16    SHF F8 avgh
 17    SHF F9 unv
 18    SHF F10 cntv
 19    SHF F11 lsfa
 20    SHF F12 tail
 21    CTL F1 lsah
 22    CTL F2 conh
 23    CTL F3 sqldesh
 24    CTL F11 lsah
 25    CTL F12 tailh
 26    ALT F1 evlh
 27    ALT F2 xlrh
 28    ALT F3 sasbatch
 29    ALT F11 sumv
 30    ALT F12 tailh
 31    CTL B wattention
 32    CTL D data;retain a b 1;proc tabulate;var a b;table a(n)*f=5.*b(n)*f=5.;run;
 33    CTL E n ? "hil";n=*"P Jone";n gt:"Phil";n le "Eva";sql- eqt gtt ltt get let net
 34    CTL G note g.g
 35    CTL H note h.h
 36    CTL I note i.i
 37    CTL J libname x excel ".xlsx";proc sql;update x;set y=2;where n="John"
 38    CTL K :mcu
 39    CTL L :mcl
 40    CTL M proc format;value $a;proc catalog cat=formats;modify a.formatc(desc='OK');run;
 41    CTL Q options minoperator;%macro t(x=a)/minoperator;%if &x in (a b c) %then
 42    CTL R proc report data=sashelp.class named list wrap;run;quit;
 43    CTL T proc tabulate data=class;class sex age;table age,sex*(n pctn<age>)/rts=8
 44    CTL U ~ Usage:
 45    CTL W ~ x 'tree "c:/temp" /F /A | clip'
 46    CTL Y where name like "B_B" "%B%" "B%B"
 47    RMB log;clear;out;clear;pgm;submit;home;log;z;z;
 48    SHF RMB ls4
 49    CTL RMB lsh
 50    MMB ~as assiigned to F1 (push on scroll wheel
 51    SHF MMB assigned to shf f2 lsa all obs last datasets
 52    CTL MMB assigned to cnt ftl ldah all obs highlighed dataset


 /*
 _ __ ___   ___  _   _ ___  ___   _ __ ___   __ _ _ __  ___
| `_ ` _ \ / _ \| | | / __|/ _ \ | `_ ` _ \ / _` | `_ \/ __|
| | | | | | (_) | |_| \__ \  __/ | | | | | | (_| | |_) \__ \
|_| |_| |_|\___/ \__,_|___/\___| |_| |_| |_|\__,_| .__/|___/
 _                      _                        |_|
| |_ ___  _ __   __   _(_) _____      __
| __/ _ \| `_ \  \ \ / / |/ _ \ \ /\ / /
| || (_) | |_) |  \ V /| |  __/\ V  V /
 \__\___/| .__/    \_/ |_|\___| \_/\_/
         |_|

 I left off desctiptions above the buttons because you
 might want to assign different command macros to the mouse actions

                 _______________________________
                /                               \
               /                                 \
              /   Can use with SHF CTL & ALT      \
             /                                     \
            |                                       |
            |                            ___        |
            |                           /   \       |
            |                          | RMB | ------- See Below
            |                           \___/       |  Sas allows direct mapping
            |                                       |
            |                                       |
            |                                       |
            |                                       |
            |                                       |
            |    ___                                |
            |   /   \                               |
            |  | F11 |                              |
            |   \___/                               |
            |                                       |
            |           ___       ___      ___      |
            |          /   \     /   \    /   \     |
            |         | F5  |   | F1  |  | F6  |    |
            |          \___/     \___/    \___/     |
            |                                       |
            |    ___                                |
            |   /   \                               |
            |  | F4  |                              |
            |   \___/                               |
            |                     ___               |
            |                    /   \              |
            |                   | F2  |             |
            |                    \___/              |
             \                                      /
              \                                    /
               \                                  /
                \                                /
                 \______________________________/


     _     _              _
 ___(_) __| | ___  __   _(_) _____      __
/ __| |/ _` |/ _ \ \ \ / / |/ _ \ \ /\ / /
\__ \ | (_| |  __/  \ V /| |  __/\ V  V /
|___/_|\__,_|\___|   \_/ |_|\___| \_/\_/


             _____________
            /             \
           /               \
          /  SIDE VIEW      \
         /                   \
        |                     |
        |    ___              |
        |   /   \             |
        |  | F11 |            |
        |   \___/             -\
        |                     - | Scroll Wheel
        |           ___       - /
        |          /   \      |/
        |         | F5  |     |
        |          \___/      |
        |                     |
        |    ___              |
        |   /   \             |
        |  | F4  |            |
        |   \___/             |
        |                     |
         \                    /
          \                  /
           \                /
            \              /
             \____________/




   RMB log;clear;out;clear;pgm;submit;home;log;z;z; ==> submit code
   SHF RMB ls4                                          40 obs last datsets
   CTL RMB lsh                                          40 obs hilighted dataset


/*                                                          _
 _ __ ___   __ _  ___ _ __ ___    _ __ ___ _ __   ___  _ __| |_
| `_ ` _ \ / _` |/ __| `__/ _ \  | `__/ _ \ `_ \ / _ \| `__| __|
| | | | | | (_| | (__| | | (_) | | | |  __/ |_) | (_) | |  | |_
|_| |_| |_|\__,_|\___|_|  \___/  |_|  \___| .__/ \___/|_|   \__|
                                          |_|
* Create Report on Performance macros;
options ls=255;
data des ;
  length lyn $200;
  infile "c:/utl/sas_saspac.sas";
  input;
  lyn=_infile_;
  if index (compress(_infile_),'des=')>0 then do; put lyn; output; end;
run;quit;

data preRpt;
  set des(firstobs=2);
  macro=scan(lyn,2,' ');
  tmp=scan(lyn,2,'"');
  if missing(tmp) then  tmp=scan(lyn,2,"'");
  usage=scan(tmp,1,".");
  description=left(substr(tmp,index(tmp,'.')+2));
  drop lyn tmp;
run;quit;

*/


/*
 _                     _                                              _
(_)_ __  ___  ___ _ __| |_    ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_
| | `_ \/ __|/ _ \ `__| __|  / __/ _ \| `_ ` _ \| `_ ` _ \ / _ \ `_ \| __|
| | | | \__ \  __/ |  | |_  | (_| (_) | | | | | | | | | | |  __/ | | | |_
|_|_| |_|___/\___|_|   \__|  \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|

Using the classic editor insert an empty commment block at the
cursor position, put A in prefix area and hit PF 4

  To insert a comment at cursor position

  1. create empty comment block

   * *************************************
   * *
   * *
   * *************************************

     note "* *" allows you to update comment lines without end comment moving right;

  2. Type "save cmt" to save comment block in sasuser.profile.cmt.source
  3. Create function key f4 with copy cmt
  4. Finally, type A in the prefix area where you want the comment
  5. Hit F4
*/

/*
  ___ _ __ ___
 / __| `_ ` _ \
| (__| | | | | |    sashelp.class
 \___|_| |_| |_|

*/

/* comment out a block of code */
%macro cm / cmd des="Usage: cm. Hilite the blank line and subsequent block of code and the code will be commented out";
      c ' ' '/*' first;c ' ' '*/' last;
%mend cm;

/*         _     _
 _ __ ___ (_)___| |__
| `_ ` _ \| / __| `_ \
| | | | | | \__ \ | | |   sashelp.class
|_| |_| |_|_|___/_| |_|

*/

%macro mish /cmd parmbuff des="Usage: mish sex age. Highlight dataset and type mish sex age and for crosstab of missings"
   %let argx=%scan(&syspbuff,1,%str( ));
   store;note;notesubmit '%misha;';
   run;
%mend mish;

%macro misha;
  proc format;

     value num2mis
      .          = 'MIS'
      .<-.Z      = 'MIS'
      0          = 'ZRO'
      0<-high    = "POS"
      low-<0     = 'NEG'
      other      = 'POP'
      ;

   value $chr2mis
   " "  ='MIS'
   other='POP'
    ;
   run;quit;

   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argd',_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
   run;
   dm "out;clear;";
   options nocenter;
   footnote;
   ODS NOPROCTITLE;
   title1 "Frequency of &argx in dataset &argd &__dtetym";
   proc freq data=&argd;
   format _numeric_ num2mis. _character_ $chr2mis.;
   tables &argx./list missing out=frqh;
   run;
   title;
   ODS PROCTITLE
   dm "out;top;";
%mend misha;


/*                 _
 _   _ _ __   __ _| |__
| | | | `_ \ / _` | `_ \
| |_| | | | | (_| | | | |
 \__,_|_| |_|\__, |_| |_|
                |_|
*/


/* distinct counts of subid(harcoded) and other clasification variables */

%macro unqh /cmd parmbuff des="Usage: unqh sex age.  distinct counts. Usubjid must be in the datasets";

   store;

   %symdel argx sas_dataset arg / nowarn;

   %let argx=&syspbuff;

   %if %sysfunc(countw(&argx))=2 %then %do;
        %let arg= %qsysfunc(translate(&argx,%str(,),%str( )));
        %put &arg;
   %end;
   %else %do;
       %let arg = &argx;
   %end;

   %let rc=%sysfunc(dosubl('

     proc datasets lib=work nodetails nolist;
      delete __temp;
     run;quit;

     FILENAME clp clipbrd ;
     DATA _NULL_;
       INFILE clp;
       INPUT;
       put _infile_;
       call symputx("sas_dataset",_infile_);
     RUN;
     proc sql;
        create
           table __tmp as
        select
           &arg
          ,count(distinct(subid))   as UNIQUE_SUBID
          ,count(*)                 as OBSEVATIONS
        from
          &sas_dataset
        group
          by &arg
     ;quit;
     options ls=130;
     proc print data=__tmp width=min;
     title "Dataset=&sas_dataset  frequecies and distinct count for &argx";
     run;quit;
     '));

     %symdel argx sas_dataset arg / nowarn;

%mend unqh;

/*                  _             _
__   _____ _ __ ___(_) ___  _ __ (_)_ __   __ _
\ \ / / _ \ `__/ __| |/ _ \| `_ \| | `_ \ / _` |
 \ V /  __/ |  \__ \ | (_) | | | | | | | | (_| |
  \_/ \___|_|  |___/_|\___/|_| |_|_|_| |_|\__, |
                                          |___/
*/

/* save and version program */

%macro _sv /cmd des="Usage: pf1 or mmb. Save timestamped version of the program in the c:/ver folder and save program in c:/utl";
pgm;file .\&pgm..sas;file c:\ver\&pgm.&_q..sas;%let _q=%eval(0&_q +1);
%mend _sv;

/*         _     _
 ___  __ _| | __| | ___  ___
/ __|/ _` | |/ _` |/ _ \/ __|  proc report data=sashelp.class named list wrap;run;quit;
\__ \ (_| | | (_| |  __/\__ \   sashelp.class
|___/\__, |_|\__,_|\___||___/
        |_|
*/

%macro sqldesh / cmd des="Usage: sqldesh. Hilite table and type alt and scroll button(mmb) and sql descibe will appear in log";
   store;note;notesubmit '%sqldesha;';
   run;
%mend sqldesh;

%macro sqldesha;
   %symdel __sql;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('__sql',_infile_);
   run;quit;
   proc sql;
       describe table &__sql;
   ;quit;
%mend sqldesha;

/*             _           _       _
 ___  __ _ ___| |__   __ _| |_ ___| |__
/ __|/ _` / __| `_ \ / _` | __/ __| `_ \    2*3
\__ \ (_| \__ \ |_) | (_| | || (__| | | |
|___/\__,_|___/_.__/ \__,_|\__\___|_| |_|

*/
%macro sasbatch /cmd des="Usage: sasbatch. Highlight code type sasbatch on command line";
   store;note;notesubmit '%sasbatcha;';
%mend sasbatch;

%macro sasbatcha;

     %utlfkil(d:/log/__clp.sas);
     %utlfkil(d:/log/__clp.log);
     %utlfkil(d:/log/__clp.lst);

  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    file "d:/log/__clp.sas";
    put _infile_;
    putlof _infile_;
  RUN;quit;

  filename sin pipe %sysfunc(compbl("c:\PROGRA~1\sas94\SASFoundation\9.4\sas.exe -sysin d:/log/__clp.sas
        -log d:/log/__clp.log -autoexec c:\oto\tut_oto.sas
       -print d:/log/__clp.lst -sasautos c:/oto"));

   data _null_;
     infile sin;
     input;
     put _infile_;
   run;quit;

   x notepad.exe d:/log/__clp.log;

%mend sasBatcha;

/*          _ _
  _____   _| | |__
 / _ \ \ / / | `_ \
|  __/\ V /| | | | |
 \___| \_/ |_|_| |_|

*/

%macro evlh / cmd des="Usage: evlh. Hilite expression 2*(3+1) and type evlh  and 8 will appear in log";
   store;note;notesubmit '%evla;';
   run;
%mend evlh;

%macro evla;
   %symdel __evl;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('__evl',_infile_);
   run;quit;
   data _null_;
     result=&__evl;
     put result=;
   run;quit;
%mend evla;

/*
 ___ _   _ _ __ _____   __
/ __| | | | `_ ` _ \ \ / /
\__ \ |_| | | | | | \ V /
|___/\__,_|_| |_| |_|\_/

*/

%macro sumv / cmd des="Usage: sumv. Hilite a column of numbers and an proc means will run";
   store;note;notesubmit '%sumvha;';
   run;
%mend sumv;

%macro sumvha;
   filename clp clipbrd ;
   data _sumh_;
     infile clp;
     input x;
   run;quit;
   proc means data=_sumh_ n sum mean std min q1 median q3 max;run;quit
%mend sumvha;

/*    _
__  _| |_ __
\ \/ / | `__|
 >  <| | |
/_/\_\_|_|

*/

%macro xlrh /cmd des="Usage: xlrh. Hilite a table and type xlr and table will open it in excel. No need for pc acces to excel";
   store;note;notesubmit '%xlrha;';
   run;
%mend xlrh;

%macro xlrha/cmd;

    %local argx;

    filename clp clipbrd ;

    data _null_;
       infile clp;
       input;
       argx=_infile_;
       call symputx("argx",argx);
       putlog argx=;
    run;quit;

    /* %let argx=sashelp.class; */

    ods escapechar = '~';

    %utlfkil(%sysfunc(getoption(work))/_rpt.xlsx);

    ods listing close;

    ods escapechar='~';

    %utl_xlslan100;

    ods excel file="%sysfunc(getoption(work))/_rpt.xlsx"
            options(
              /* autofit_height           = 'yes'*/
               sheet_name                 = "&argx"
               autofilter                 = "yes"
               frozen_headers             = "1"
               gridlines                  = "yes"
               embedded_titles            = "yes"
               embedded_footnoteS         = "yes"
               );

    proc report data=&argx missing
     style(column)=[textalign=left verticalalign=top cellwidth=8in] split="~" style=utl_xlslan100;
    title "SAS table &argx";
    run;quit;

    ods excel close;

    ods listing;

    options noxwait noxsync;
    /* Open Excel */
    x "'C:\Program Files\Microsoft Office\root\Office16\excel.exe' %sysfunc(getoption(work))/_rpt.xlsx";
    run;quit;

%mend xlrha;

/*
 ___ _   _ _ __ ___  _ __
/ __| | | | `_ ` _ \| `__|
\__ \ |_| | | | | | | |      sashelp.class
|___/\__,_|_| |_| |_|_|

*/

%macro sumr /cmd parmbuff des="Usage: sumr. Hilite row of numbers type sumr and the sum will appear in the log and macro variable __sumr";
    /* hilite 1 2 3 4 5 and */
    store;note;notesubmit '%sumrh;';
   run;
%mend sumr;

%macro sumrh;
   %global __sumr;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     row=translate(_infile_,'+',' ');
     call symputx('row',row);
   run;
   %let __sumr=%sysevalf(&row);
   %put &=__sumr;
%mend sumrh;

/* %put &=__sumr;  */


/*       _
(_) ___ | |_ __ _
| |/ _ \| __/ _` |
| | (_) | || (_| |
|_|\___/ \__\__,_|

*/

%macro iota (utliota1) /cmd des="Usage: iota. Type iota 10 and 10 rows with 01 02 03 - 10 will be added to the editor";
   sub '%iotb';
%mend iota;
/*          _   _
  ___ _   _| |_| |__
 / __| | | | __| `_ \
| (__| |_| | |_| | | |
 \___|\__,_|\__|_| |_|

*/
%macro cuth / cmd des="Usage: cuth. Hilite a block of code and type cuth and mutiple spaces will be reduced to single spaces";
  /* USAGE
     hilight a block of code and type cuth on command line
    this changes two spaces to one space
    becomes
    1          5    3        6
    1 5 3 6
  */

  %do i=1 %to 20;
    c '  ' ' ' all;
  %end;
%mend cuth;

/*                _
 _ __   __ _ _ __| |__
| `_ \ / _` | `__| `_ \
| |_) | (_| | |  | | | |
| .__/ \__,_|_|  |_| |_|
|_|
*/

%macro parh / cmd des="Usage: parh. Hilite a line of code and type parh to test for unbalanced parens";
   store;note;notesubmit '%parha;';
   run;
%mend parh;

%macro parha ;
   filename clp clipbrd ;
   data _null_;
     retain add 0;
     infile clp;
     input ;
     lft=countc(_infile_,'(');
     rgt=countc(_infile_,')');
     lftrgt=lft - rgt;
     abslftrgt=abs(lftrgt);
     select;
        when (lftrgt=0) putlog "**********************" // "Parentheses match  ()"  // "**********************";
        when (lftrgt>0) putlog "**********************" // "Missing " lftrgt ") parentheses  "  // "**********************";
        when (lftrgt<0) putlog "**********************" // "Missing " abslftrgt  "( parentheses  "  // "**********************";
        otherwise;
     end;
   run;
%mend parha;

/*    _ _
__  _(_) |_
\ \/ / | __|
 >  <| | |_
/_/\_\_|\__|

*/

%macro xit/ cmd des='Usage: xit. When exiting sas type xit and last program will open next time you start SAS';
  pgm;file &pgm..sas;file c:\ver\&pgm.&_q..sas;%let _q=%eval(0&_q +1);
  home;save pgm_last r;%sysfunc(sleep(1,1));bye;
%mend xit;


/*          _
  ___ _ __ | |_ _   _
 / __| `_ \| __| | | |  data class ;
| (__| | | | |_| |_| |   set sashelp.class;
 \___|_| |_|\__|\__,_|   usubjid=age;
                        run;quit;
*/

%macro cntuh /cmd parmbuff des="Usage: cntuh. Hilite table and count distinct usubjid and number of obs are in paste buffer";

   %local _vars;
   %let _vars=&syspbuff;
   %put _vars=&_vars;
   %let _vars=%sysfunc(translate(&_vars,%str(,),%str( )));
   store;note;notesubmit '%cntuha;';
   run;
%mend cntuh;

%macro cntuha;

   %local _cnt_ _obs_;

   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('_sasdataset',_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
   run;

   %put &=_sasdataset;
   %put &=_vars;

   proc sql noprint;
    select put(count(distinct usubjid), comma18.) into :_cnt_ separated by '' from &_sasdataset;
    select put(count(*), comma18.) into :_obs_ separated by '' from &_sasdataset;
   quit;

  filename __dm clipbrd ;
  data _null_;file __dm; put "";run;quit;
  data _null_;
     length msg $255;
    file __dm;
    msg=cats('/','*',"--- Number of unique usubjid=&_cnt_ for usubjid in &_sasdataset (obs=&_obs_) &__dtetym ---",'*','/');
    putlog msg;
    put msg;
  run;quit;
  filename __dm clear;
run;quit;
title;
%mend cntuha;



/*    _ _
  ___| (_)_ __
 / __| | | `_ \
| (__| | | |_) |
 \___|_|_| .__/
         |_|
*/

%macro cliph / cmd des="Usage: cliph. Hilite a line of  and macro variable _clip will contain the statement";
   store;note;notesubmit '%clipha;';
   run;
%mend cliph;

%macro clipha/cmd;
 %global _clip;
 %local rc fileref fid len ;
 %let rc = %sysfunc( filename( fileref, , clipbrd ) );
 %if &rc eq 0 %then %do;
 %let fid = %sysfunc( fopen( &fileref, s, 32767, v) );
 %if &fid ne 0 %then %do;
 %do %while( %sysfunc( fread( &fid ) )=0 );
 %let len = %sysfunc( frlen( &fid ) );
 %let rc = %sysfunc( fget( &fid, _clip, &len ) );
 %*put len = &len line = %superq( line );
 %end;
 %let rc = %sysfunc( fclose( &fid ) );
 %end; %else %do;
 %put failed to open clipboard fileref.;
 %end;
 %let rc = %sysfunc( filename( fileref ) );
 %end; %else %do;
 %put %sysfunc( sysmsg( ) );
 %end;
%mend clipha;


/*          _   _
  ___ _ __ | |_| |__
 / __| `_ \| __| `_ \
| (__| | | | |_| | | |
 \___|_| |_|\__|_| |_|

*/

%macro cnth / cmd parmbuff  des='Usage: cnth sex age. Hilite table and type cnth age sex and distinct counts of age sex cobinations in paste buffer';
   %local _vars;
   %let _vars=&syspbuff;
   %put _vars=&_vars;
   %let _vars=%sysfunc(translate(&_vars,%str(,),%str( )));
   %put &=_vars;
   store;note;notesubmit '%cntha;';
   run;
%mend cnth;


%macro cntha;

   %local _cnt_ _obs_;

   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('_sasdataset',_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
   run;

   %put &=_sasdataset;
   %put &=_vars;

   proc sql noprint;
    select put(count(*), comma18.) into :_cnt_ separated by '' from ( select distinct &_vars from &_sasdataset);
    select put(count(*), comma18.) into :_obs_ separated by '' from &_sasdataset;
   quit;

  filename __dm clipbrd ;
  data _null_;file __dm; put "";run;quit;
  data _null_;
     length msg $255;
     file __dm;
    msg=cats('/','*',"----- Number of unique levels=&_cnt_ for &_vars from &_sasdataset (obs=&_obs_) &__dtetym -----",'*','/');
    putlog msg;
    put msg;
  run;quit;
  filename __dm clear;
run;quit;
title;
%mend cntha;

/*                _
  __ ___   ____ _| |__  _   _
 / _` \ \ / / _` | `_ \| | | |
| (_| |\ V / (_| | |_) | |_| |   sashelp.class
 \__,_| \_/ \__, |_.__/ \__, |
            |___/       |___/
*/
%macro avgby /cmd parmbuff des="Usage: avgby sex age. Hilite table type avgby sex age for means by sex age also output dataset avgby";

   /* usage
       hilight sashelp.class and
       type avgby sex age (on classic 1980s command line)
       output will be in paste buffer
   */

   %let argx=&syspbuff;
   store;note;notesubmit '%avgbya;';
   run;
%mend avgby;

%macro avgbya;
   options ls=255;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argd',_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
   run;
   dm "out;clear;";
   options nocenter;
   footnote;
   ODS NOPROCTITLE;
   title1 "Means by &argx datasets &argd &__dtetym";
   proc means data=&argd missing n nmiss sum mean min q1 median q3 max;
   class &argx;
   output out=avgby;
   run;
   title;
   ODS PROCTITLE;
   dm "out;top;"
  ;
%mend avgbya;

/*        _ _
| |_ __ _(_) |  data class;
| __/ _` | | |   set sashelp.shoes;
| || (_| | | |  run;
 \__\__,_|_|_|

*/

%macro tail /cmd des="Usage: tail. Type tail and last 40 obs of last dataset in paste buffer and output window";
   note;gsubmit '%taila;';
%mend tail;


%macro taila /cmd ;
  %put XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
  footnote;
  options nocenter;
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  proc sql noprint;
        select
           put(count(*),comma18.)
          ,count(*)
        into
          :tob  trimmed
         ,:tobs  trimmed
  from _last_;quit;
  data _null_; call symputx("__dtetym",put(datetime(),datetime23.)); run;
  title "last 41 obs from %upcase(%sysfunc(getoption(_last_))) total obs=&tob &__dtetym";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  %let pobs=%sysfunc(ifn(&tobs > 40, %eval(&tobs - 40),1));
  proc print data=_last_ ( firstObs= &pobs ) width=min uniform  heading=horizontal;
  format _all_;
  run;
  proc printto;
  run;quit;
  title;
  filename __dm clipbrd ;
  data _null_;file _dm; put "";run;quit;
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt" end=dne;
     input;
     file __dm ;
     put _infile_;
     file print;
     put _infile_;
  run;quit;
  filename __dm clear;
  run;quit;
  title;
  dm "out;";
%mend taila;


/*        _ _ _
| |_ __ _(_) | |__
| __/ _` | | | `_ \
| || (_| | | | | | |
 \__\__,_|_|_|_| |_|

*/

%macro tailh /cmd des="Usage: tail. Hilite table and type tailh and the last 40 obs will be in output window and in paste buffer";

   store;note;notesubmit '%tailha;';
%mend tailh;

%macro tailha:
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
  RUN;
  footnote;
  options nocenter;
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  proc sql noprint;
        select
           put(count(*),comma18.)
          ,count(*)
        into
          :tob  trimmed
         ,:tobs  trimmed
  from &argx;quit;
  data _null_; call symputx("__dtetym",put(datetime(),datetime23.)); run;
  title "last 41 obs from %upcase(&argx) total obs=&tob &__dtetym";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  %let pobs=%sysfunc(ifn(&tobs > 40, %eval(&tobs - 40),1));
  proc print data=&argx ( firstObs= &pobs ) width=min uniform  heading=horizontal;
  format _all_;
  run;
  proc printto;
  run;quit;
  title;
  filename __dm clipbrd ;
  data _null_;file _dm; put "";run;quit;
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt" end=dne;
     input;
     file __dm ;
     put _infile_;
     file print;
     put _infile_;
  run;quit;
  filename __dm clear;
  run;quit;
  title;
  dm "out;";
%mend tailha;

/*
| |___
| / __|
| \__ \
|_|___/

*/

%macro ls4 / cmd des='Usage: ls4. Type ls and a list of first 40 obs of last table in output window and paste buffer';
   note;notesubmit '%ls40;';
%mend ls4;

%macro ls40 /cmd ;
  dm "out;clear;";
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  data _null_; call symputx("__dtetym",put(datetime(),datetime23.)); run;
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' ' from _last_;quit;
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  proc print data=_last_ ( Obs= 40 ) width=min uniform  heading=horizontal;format _all_;run;
  proc printto;
  filename __dm clipbrd ;
  title "Up to 40 obs from last table %upcase(%sysfunc(getoption(_last_))) total obs=&tob &__dtetym";
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt";
     input; file __dm ; put _infile_; file print; put _infile_;
  run;
  title;
%mend ls40;


/*     _
| |___| |__
| / __| `_ \   data shoes;;
| \__ \ | | |  set sashelp.class;
|_|___/_| |_|  run;quit;

*/

%macro lsh /cmd des='Usage: lsh. Type lsh for list and output in paste buffer of hilited table';
   store;note;notesubmit '%lsha;';
%mend lsh;

%macro lsha;
  dm "out;clear;";
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
    call symputx("__dtetym",put(datetime(),datetime23.));
  RUN;
  title;
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' ' from &argx;quit;
  proc printto print="%sysfunc(pathname(work))/__dm.txt" new;
  proc print data=&argx( Obs= 40 )  width=min uniform  heading=horizontal;
  format _all_;run;
  proc printto;
  filename __dm clipbrd ;
  title "Up to 40 obs from %upcase(&argx) total obs=&tob &__dtetym";
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt" end=dne;
     input;
     file __dm ;
     put _infile_;
     file print;
     put _infile_;
  run;
%mend lsha;

/*      __ _
| |___ / _| |__    data fmt;
| / __| |_| `_ \     date=today();          sashelp.shoes
| \__ \  _| | | |    format date date9.;
|_|___/_| |_| |_|    output;output;output;
                   run;
*/

%macro lsfh /cmd des='Usage: lsfh. Hilight table type lsfh for 40 obs formatted list and output in paste buffer';
   store;note;notesubmit '%lsfha;';
%mend lsfh;

%macro lsfha;
  dm "out;clear;";
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
    call symputx("__dtetym",put(datetime(),datetime23.));
  RUN;
  title;
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' ' from &argx;quit;
  proc printto print="%sysfunc(pathname(work))/__dm.txt" new;
  proc print data=&argx( Obs= 40 )  width=min uniform  heading=horizontal;
  run;
  proc printto;
  filename __dm clipbrd ;
  title "Up to 40 obs from %upcase(&argx) with formatted variables  total obs=&tob &__dtetym";
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt" end=dne;
     input;
     file __dm ;
     put _infile_;
     file print;
     put _infile_;
  run;
%mend lsfha;

/*
| |___  __ _
| / __|/ _` |   data class;
| \__ \ (_| |   set sashelp.shoes;
|_|___/\__,_|   run;

*/

%macro lsa / cmd des="Usage: lsa. Ttpe lsal to list all obs from the last dataset";
   note;notesubmit '%lsaa;';
   run;
%mend lsa;

%macro lsaa /cmd;
  %local __tob __dtetym;
   dm "out;clear;";
  proc sql noprint;select put(count(*),comma18.), put(datetime(),datetime23.)
  into :__tob trimmed, :__dtetym trimmed
  from _last_;quit;
  title "All obs from %upcase(%sysfunc(getoption(_last_))) total obs=&__tob &__dtetym";
  proc print data=_last_  heading=horizontal width=min;
   footnote;
   format _all_;
   run;
   title;
   dm "out;top";
%mend lsaa;

/*           _
| |___  __ _| |__
| / __|/ _` | `_ \
| \__ \ (_| | | | |
|_|___/\__,_|_| |_|

*/

%macro lsah /cmd des='Usage: lsah. Type lsah for a list of all obs in output and in paste buffer of hilited table';
   store;note;notesubmit '%lsaha;';
%mend lsah;

%macro lsaha/cmd;
  %local tob __dtetym;
  dm "out;clear;";
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
    call symputx("__dtetym",put(datetime(),datetime23.));
  RUN;
  proc sql noprint;select put(count(*),comma18.) into :tob trimmed from &argx;quit;
  proc print data=&argx  width=min uniform  heading=horizontal;
  title "All obs from &argx total obs=&tob &__dtetym";
  format _all_;run;
%mend lsaha;


/*
macro oldmac;
data class;
 set sashelp.class;
run;quit;
%
*/

/*   _                      _ _
  __| | ___   ___ _ __   __| | |__
 / _` |/ _ \ / _ \ `_ \ / _` | `_ \
| (_| | (_) |  __/ | | | (_| | | | |
 \__,_|\___/ \___|_| |_|\__,_|_| |_|

 %do i=1 to 10;
   %do j=1 to 10 ;
     x=2;
     x=2;
     x=3;
   end;

**********************

Missing 2  %END

**********************
*/

/* match %do and %end */
%macro doendh / cmd des='Usage: foendh. Hilite block of macro code and match dos and ends';
   store;note;notesubmit '%doendha;';
   run;
%mend doendh;

%macro doendha;
   filename clp clipbrd ;
   data _null_;
     retain lft rgt 0 ;
     infile clp end=dne;
     do until(dne);
         input ;
         lft=lft+count(upcase(_infile_),'%DO ');
         rgt=rgt+count(upcase(_infile_),'%END;');
         put lft= rgt=;
     end;
     lftrgt=lft - rgt;
     abslftrgt=abs(lftrgt);
     select;
        when (lftrgt=0) putlog "**********************" // '%DO %END  match'  // "**********************";
        when (lftrgt>0) putlog "**********************" // 'Missing ' lftrgt ' %END  '  // "**********************";
        when (lftrgt<0) putlog "**********************" // 'Missing ' abslftrgt  ' %DO;  '  // "**********************";
        otherwise;
     end;
   run;
%mend doendha;

/*
| |_____      __
| / __\ \ /\ / /  data class;
| \__ \\ V  V /      set sashelp.class;   lsw "sex='F'"
|_|___/ \_/\_/    run;quit;

*/

%macro lsw /cmd parmbuff des='Usage: lsw [dq]]age=14[dq]. Use single and doubple quotes for chars, 40 obs  filter for  the _last_ table in pastebuffer and list';
   %let argx=&syspbuff;
   %put &=argx;
   note;notesubmit '%lswa;';
%mend lsw;

%macro lswa/cmd;
  dm "out;clear;";
  title;footnote;
  data _null_; call symputx("__dtetym",put(datetime(),datetime23.)); run;
  proc printto print="%sysfunc(pathname(work))/__dm.txt" new;
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' ' from _last_;quit;
  proc print data=_last_(obs=40 where=(%sysfunc(dequote(&argx)))) width=min uniform heading=horizontal;format _all_;
  proc printto;
  filename __dm clipbrd ;
  title "Up to 40 obs %upcase(%sysfunc(getoption(_last_))) total obs=&tob &__dtetym";
  data _null_;
     infile "%sysfunc(pathname(work))/__dm.txt" end=dne;
     input;
     file __dm ;
     put _infile_;
     file print;
     put _infile_;
  run;quit;
  filename __dm clear;
  dm "out;top;";
  run;quit;
%mend lswa;

/*              _
| |_____      _| |__
| / __\ \ /\ / / `_ \
| \__ \\ V  V /| | | |   sashelp.class lswh "age=14 and sex='F'"
|_|___/ \_/\_/ |_| |_|

*/

%macro lswh /cmd parmbuff Des='Usage: lswh "age=14 weigth=89". Hilight table and type lswh "age=14" and first 40 obs that satisfy filter in output and paste buffer';
   %let argx=&syspbuff;
   store;note;notesubmit '%lswha;';
   run;
%mend lswh;

%macro lswha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argd',_infile_);
   run;
   dm "out;clear;";
   proc datasets lib=work nodetails nolist;
   delete frqh;
   run;quit;
   options nocenter;
   data frqh;
      set &argd(where=(%sysfunc(dequote(&argx))));
   run;quit;
   title "Up to 40 obs from from &argd(where %sysfunc(dequote(&argx))) total obs=&tob &__dtetym ";
   proc print data=frqh(obs=100 )  width=min;
   format _all_;
   run;
   dm "out;top;";
%mend lswha;


/*                _
  __ ___   ____ _| |__
 / _` \ \ / / _` | `_ \    data class;
| (_| |\ V / (_| | | | |     set sashelp.class;   age
 \__,_| \_/ \__, |_| |_|   run;quit;
            |___/
*/

%macro avgh / cmd des="Usage: avgh. Hilite table and type avgh for proc means output and table avgh will be created";
   store;note;notesubmit '%avgha;';
   run;
%mend avgh;

%macro avgha;
   proc datasets lib=work nodetails nolist;
     delete avgh;
   run;quit;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     _infile_=upcase(_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
     cmd=catx(' ',
          'proc means data= ',_infile_,'n nmiss sum mean min q1 median q3 max;'
         ,'Title SAS daatset',_infile_,"&__dtetym;",'output out=avgh;run;quit' );
     put cmd=;
     call execute (cmd);
     stop;
   run;
%mend avgha;

/*__
 / _|_ __ __ ___   __
| |_| `__/ _` \ \ / /     data class;
|  _| | | (_| |\ V /        set sashelp.class;
|_| |_|  \__, | \_/         id = age ;
            |_|           run;quit;
*/

%macro frqv / cmd  des="Usage: frqv. Hilite variable in _last_ table andn proc freq hiltred variable";
   store;note;notesubmit '%frqva;';
   run;
%mend frqv;

%macro frqva;
   filename clp clipbrd ;
   title "proc freq table = %upcase(%sysfunc(getoption(_last_)))";
   data _null_;
     infile clp;
     input;
     cmd=catx(' ',
       'proc freq  data=_last_ levels order=freq;tables',_infile_,'/missing;run;quit');
     call execute (cmd);
   run;
%mend frqva;

/*          _
  ___ _ __ | |___   __
 / __| `_ \| __\ \ / /
| (__| | | | |_ \ V /
 \___|_| |_|\__| \_/

var         obs   uniques
-------------------------
 age         19         6

*/

%macro cntv / cmd des="Usage: cntv. Hilight variable in _last_ table and get count and distinct counts on variable";
   store;note;notesubmit '%cntva';
   run;
%mend cntv;

%macro cntva/cmd;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc sql;select','"',_infile_,'" as var, count(*) as obs, count(distinct',_infile_,') as uniques from _last_;quit;');
     putlog cmd;
     call execute (cmd);
   run;
%mend cntva;

/*
 _   _ _ ____   ____   __
| | | | `_ \ \ / /\ \ / /
| |_| | | | \ V /  \ V /
 \__,_|_| |_|\_/    \_/

*/

%macro unvv / cmd des="Usage: unv. Hilite a variable from the _last_ table and proc unvariate will be run on that variable";
   store;note;notesubmit '%unvva;';
   run;
%mend unvv;

%macro unvva;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc univariate data=_last_ plot;var',_infile_,';run;quit');
     call execute (cmd);
   run;
%mend unvva;

/*                _
 _   _ _ ____   _| |__
| | | | `_ \ \ / / `_ \
| |_| | | | \ V /| | | |     sashelp.class
 \__,_|_| |_|\_/ |_| |_|

*/

%macro unvh /cmd des="Usage: unvh. proc univariate on hilighted dataset";
   store;note;notesubmit '%unvha;';
   run;
%mend unvh;
%macro unvha;
   %local  __dtetym tob
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argx',_infile_);
   run;
   %symdel tob;

   proc sql;select count(*),put(datetime(),datetime23.)  into :tob trimmed, :__dtetym trimmed from _last_;quit;
   run;

   title "proc univariate Table = &argx - Total Obs &tob &__dtetym";

   ods graphics off;
   proc univariate data=&argx plot;
   run;quit;

%mend unvha;


/*          _   _
 _ __ _ __ | |_| |__
| `__| `_ \| __| `_ \        sashelp.class
| |  | |_) | |_| | | |
|_|  | .__/ \__|_| |_|
     |_|
*/


%macro rpth /cmd des="Usage: rpth. Generate proc report code on hilighted dataset";
   store;note;notesubmit '%rptha;';
   run;
%mend rpth;
%macro rptha;
   %local  __dtetym tob
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argx',_infile_);
   run;
   %symdel tob;

   proc sql;select count(*),put(datetime(),datetime23.)  into :tob trimmed, :__dtetym trimmed from _last_;quit;
   run;

   title "proc report Table = &argx - Total Obs &tob &__dtetym";

   proc report data=&argx(obs=3) named list wrap;
   run;quit;

%mend rptha;

/*   _
  __| |_ __ ___  _ __
 / _` | `_ ` _ \| `_ \
| (_| | | | | | | |_) |  ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
 \__,_|_| |_| |_| .__/
                |_|
*/

%macro dmp /cmd des="Usage: dmp. Type dmp and middle observation of last dataset printed vertically";
   note;notesubmit '%dmpa';
   run;
%mend dmp;

%macro dmpa;
   /* all this to get middle record */
   %local tob __dtetym;
   proc sql;select count(*),put(datetime(),datetime23.)  into :tob trimmed, :__dtetym trimmed from _last_;quit;
   data _null_;
      If _n_=0 then set _last_ nobs=mobs;
      rec=max(int(mobs/2),1);
      set _last_ point=rec;
      array chr[*] $80 _character_;
      array num[*] _numeric_;
      put "Middle Observation(" rec ") of table = &argx - Total Obs &tob &__dtetym";
      putlog // ' -- CHARACTER -- ';
      putlog @1 "Variable" @33 'Typ' @40 'Value' @67 'Label' /;
      do i=1 to dim(chr);
         nam=vname(chr[i]);
         typ=vtype(chr[i]);
         len=vlength(chr[i]);
         lbl=vlabel(chr[i]);
         putlog @1 nam @34 typ @35 len @40 chr[i] $44. @67 lbl $40.;
      end;
      putlog // ' -- NUMERIC -- ';
      putlog @1 "Variable" @33 'Typ' @40 'Value' @67 'Label' /;
      do i=1 to dim(num);
         nam=vname(num[i]);
         typ=vtype(num[i]);
         len=vlength(num[i]);
         lbl=vlabel(num[i]);
         numc=put(num[i],best. -l);
         putlog @1 nam @34 typ @41 len @40 numc   @67 lbl $40.;
      end;
      stop;
   run;quit;
%mend dmpa;

/*   _                 _
  __| |_ __ ___  _ __ | |__
 / _` | `_ ` _ \| `_ \| `_ \
| (_| | | | | | | |_) | | | |   sashelp.class
 \__,_|_| |_| |_| .__/|_| |_|
                |_|
*/

%macro dmph /cmd des="Usage: dmph. Type dmph middle observation of highlighted dataset printed vertically with type length and sample value";
   store;note;notesubmit '%dmpha;';
   run;
%mend dmph;
%macro dmpha;
   %local  __dtetym tob
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argx',_infile_);
   run;
   /* all this to get middle record */
   %symdel tob;

   proc sql;select count(*),put(datetime(),datetime23.)  into :tob trimmed, :__dtetym trimmed from _last_;quit;
   run;

   data _null_;

      If _n_=0 then set &argx nobs=mobs;
      rec=max(int(mobs/2),1);
      set &argx point=rec;
      call symputx("__dtetym",put(datetime(),datetime23.));
      totobs=put(&tob,comma16. -l);
      put "Middle Observation(" rec ") of table = &argx - Total Obs &tob &__dtetym";
      putlog // ' -- CHARACTER -- ';
      putlog @1 "Variable" @33 'Typ' @40 'Value' @67 'Label' /;

      array chr[*] _character_;
      array num[*] _numeric_;
      do i=1 to dim(chr);
         nam=vname(chr[i]);
         typ=vtype(chr[i]);
         len=vlength(chr[i]);
         lbl=vlabel(chr[i]);
         putlog @1 nam @34 typ @35 len @40 chr[i] $44. @67 lbl $40.;
      end;
      putlog // ' -- NUMERIC -- ';
      do i=1 to dim(num);
         nam=vname(num[i]);
         typ=vtype(num[i]);
         len=vlength(num[i]);
         lbl=vlabel(num[i]);
         numc=put(num[i],best. -l);
         putlog @1 nam @34 typ @41 len @40 numc   @67 lbl $40.;
      end;
      stop;
   run;quit;
%mend dmpha;

/*__
 / _|_ __ __ _
| |_| `__/ _` |  data class;
|  _| | | (_| |  set sashelp.class
|_| |_|  \__, |  ;run;quit;
            |_|
*/

%macro frq /cmd parmbuff des="Usage: frq sex age. Type frq type sex for a crosstab frequency on sex*age for last dataset.akes frq dataset";
/*-----------------------------------------*\
|  frq sex*age                              |
\*-----------------------------------------*/
   %*let argx=%scan(&syspbuff,1,%str( ));
   %let argx=%trim(&syspbuff);
   %let argx=%sysfunc(translate(&argx,%str(*),%str( )));
   %put argx=&argx;
   note;notesubmit '%frqa;';
   run;
%mend frq;

%macro frqa;
   dm "out;clear;";
   *rsubmit;
   options nocenter;
   footnote;
   data _null_;
      call symputx("__dtetym",put(datetime(),datetime23.));
   run;quit;

   title1 "Frequency of &argx datasets %sysfunc(getoption(_last_)) &__dtetym";
   proc freq data=_last_ levels;
   tables &argx./list missing out=frq;
   run;
   title;
   *endrsubmit;
   dm "out;top;";
%mend frqa;


/*__           _
 / _|_ __ __ _| |__
| |_| `__/ _` | `_ \
|  _| | | (_| | | | |
|_| |_|  \__, |_| |_|
            |_|
*/

%macro frqh /cmd parmbuff des="Usage: frqh sex age. Highlight dataset and type frqh sex age and  forfrequency on sex xage. Also frqh dataset.";
   %let argx=%trim(&syspbuff);
   %let argx=%sysfunc(translate(&argx,%str(*),%str( )));
   store;note;notesubmit '%frqha;';
   run;
%mend frqh;

%macro frqha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argd',_infile_);
     call symputx("__dtetym",put(datetime(),datetime23.));
   run;
   dm "out;clear;";
   options nocenter;
   footnote;
   title1 "frequency of &argx datasets &argd &__dtetym";
   proc freq data=&argd levels;
   tables &argx./list missing out=frqh;
   run;
   title;
   dm "out;top;";
%mend frqha;

%macro prtwh /cmd parmbuff;
/*-----------------------------------------*\
|  highlight dataset in editor              |   data class; set sashelp.class; x =name; run;quit;
|  prt "sex='F'"                            |
\*-----------------------------------------*/
   %let argx=&syspbuff;
   store;note;notesubmit '%prtwha;';
   run;
%mend prtwh;

%macro prtwha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argd',_infile_);
   run;
   dm "out;clear;";
   proc datasets lib=work nodetails nolist;
   delete frqh;
   run;quit;
   options nocenter;
   data frqh;
      set &argd(where=(%sysfunc(dequote(&argx))));
   run;quit;
   title1 "print of datasets ";
   title2 &argx;
   proc print data=frqh(obs=10000)  width=min;
   run;
   title;
   dm "out;top;";
%mend prtwha;



/*   _      _                 _
  __| | ___| |__  _   _  __ _| |__
 / _` |/ _ \ `_ \| | | |/ _` | `_ \
| (_| |  __/ |_) | |_| | (_| | | | |
 \__,_|\___|_.__/ \__,_|\__, |_| |_|
                        |___/
*/

%macro debugh /cmd des="Usage: debugh. Highlight macro and type debugh to debug the macro";
   store;note;notesubmit '%debugha;';
   run;
%mend debugh;

%macro debugha;
   %let rc=%sysfunc(filename(myRef,%sysfunc(pathname(work))/mactxt.sas));
   %let sysrc=%sysfunc(fdelete(&myRef));
   %let rc=%sysfunc(filename(&myref));
   filename clp clipbrd ;
   data _null_;
     infile clp;
     file "%sysfunc(pathname(work))/macraw.sas";
     input;
     put _infile_;
   run;
   filename mprint  "%sysfunc(pathname(work))/mactxt.sas";
   options mfile mprint source2;
   %inc "%sysfunc(pathname(work))/macraw.sas";
   run;quit;
   options nomfile nomprint;
   filename mprint clear;
   %inc "%sysfunc(pathname(work))/mactxt.sas";
   run;quit;
%mend debugha;

/*
  ___ ___  _ __
 / __/ _ \| `_ \
| (_| (_) | | | |
 \___\___/|_| |_|

*/

%macro con / cmd des="Usage: con. Type con and contents of last dataset in outptut";
  note;notesubmit '%cona;';
%mend con;

%macro cona   / cmd ;
dm "out;clear;";
  options nocenter;
  footnote;
  proc contents data=_last_ position;
  run;
  title;
run;
dm "out;top;";
%mend cona;

/*               _
  ___ ___  _ __ | |__
 / __/ _ \| `_ \| `_ \
| (_| (_) | | | | | | |  sashelp.class
 \___\___/|_| |_|_| |_|

*/


%macro conh / cmd des="Usage: conh. Highlight table and type conh on command line. Results in output window";
  store;note;notesubmit '%conha;';
%mend conh;


%macro conha;
FILENAME clp clipbrd ;
DATA _NULL_;
  INFILE clp;
  INPUT;
  put _infile_;
  call symputx('argx',_infile_);
RUN;
dm "out;clear;";
title "Contents of &argx.";
options nocenter;
proc contents data=&argx. position;
run;
title;
dm "out;top";
%mend conha;

/*
__   ___   _
\ \ / / | | |
 \ V /| |_| |   sashelp.class
  \_/  \__,_|

*/

%macro vu  / cmd des="Usage: vu. Type vu for viewtable of last dataset created";
   vt _last_ COLHEADING=NAMES;
   run;
%mend vu ;

/*           _
__   ___   _| |__
\ \ / / | | | `_ \
 \ V /| |_| | | | |
  \_/  \__,_|_| |_|

*/

%macro vuh / cmd des="Usage: vuh. Type vuh for viewtable of highlighted dataset";
   store;note;notesubmit '%vuha;';
   run;
%mend vuh;

%macro vuha;
filename clp clipbrd ;
data _null_;
  infile clp;
  input;
  put _infile_;
  call symputx('argx',_infile_);
run;
dm "vt &argx"  COLHEADING=NAMES;
%mend vuha;

/*    _     _
__  _| |___| |__
\ \/ / / __| `_ \
 >  <| \__ \ | | |
/_/\_\_|___/_| |_|

*/

%macro xlsh /cmd des="Usage: xlsh. Highlight table and type xlsh and the table  will appear in excel uses libname need pc acces";;
   store;note;notesubmit '%xlsha;';
   run;
%mend xlsh;

%macro xlsha/cmd;

    filename clp clipbrd ;
    data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argx',_infile_);
    run;

    %let __tmp=%sysfunc(pathname(work))\myxls.xlsx;

    data _null_;
        fname="tempfile";
        rc=filename(fname, "&__tmp");
        put rc=;
        if rc = 0 and fexist(fname) then
       rc=fdelete(fname);
    rc=filename(fname);
    run;

    libname __xls excel "&__tmp";
    data __xls.%scan(__&argx,1,%str(.));
        set &argx.;
    run;quit;
    libname __xls clear;

    data _null_;z=sleep(1);run;quit;

    options noxwait noxsync;
    /* Open Excel */
    x "'C:\Program Files\Microsoft Office\OFFICE14\excel.exe' &__tmp";
    run;quit;

%mend xlsha;

%macro xplo ( AFSTR1 )/cmd des="Usage: xplo ONEaTWO. Type xplo ONEaTWO and exploded letters will be saved in past buffer. Use lower case for spaces";
note;notesubmit '%xploa';

%mend xplo;

%macro xploa;

options noovp;
title;
footnote;

%let uj=1;

%do %while(%scan(&afstr1.,&uj) ne );
   %let uj=%eval(&uj+1);
   %put uj= &uj;
%end;

data _null_;
   rc=filename('__xplo', "%sysfunc(pathname(work))/__xplo");
   if rc = 0 and fexist('__xplo') then rc=fdelete('__xplo');
   rc=filename('__xplo');

   rc=filename('__clp', "%sysfunc(pathname(work))/__clp");
   if rc = 0 and fexist('__clp') then rc=fdelete('__clp');
   rc=filename('__clp');
run;

filename ft15f001 "%sysfunc(pathname(work))/__xplo";

* format for proc explode;
data _null_;
file ft15f001;
   %do ui=1 %to %eval(&uj-1);
      put "D";
      put " %scan(&afstr1.,&ui)";
   %end;
run;

filename __clp "%sysfunc(pathname(work))/__clp";

proc printto print=__clp;
run;quit;

proc explode;
run;

filename ft15f001 clear;
run;quit;
proc printto;
run;quit;

filename __dm clipbrd ;

   data _null_;
     infile __clp end=dne;
     file __dm;
     input;
     putlog _infile_;
     put _infile_;
     if dne then put / "#! &afstr1 ;";
   run;

filename __dm clear;

%mend xploa;

/*              _ _     _
| | _____ _   _| (_)___| |_
| |/ / _ \ | | | | / __| __|
|   <  __/ |_| | | \__ \ |_
|_|\_\___|\__, |_|_|___/\__|
          |___/
*/

%macro keylist / cmd des="Usage: keylist. Type keylist and a list og your function keys will be in the log";
   note;notesubmit '%keylista;';
   run;
%mend keylist;

%macro keylista;
   proc datasets lib=work nodetails nolist;
     select _keys _fix;
   run;quit;
   data _null_;
     cmd=cats('filename _cat catalog "sasuser.profile.','dmkeys.keys',
     '";data _keys;infile _cat;input;putlog _infile_ $171. ;lyn=_infile_;run;quit;');
     putlog cmd;
     call execute(cmd);
   run;
   data _fix;
     length lyn l1 l2 $171;
     if _n_=0 then set _keys nobs=obs;
    do pnt=2 to obs by 2;
     set _keys point=pnt;
     lyn=substr(lyn,1,notprint(lyn)-1);
     l1=lyn;
     pnt1=pnt+1;
     set _keys point=pnt1;
     l2=lyn;
     l1l2=catx(" ",l1,l2);
     if index(l1l2,'~')>0 then l1l2=catx(" ",substr(l1l2,1,7),scan(l1l2,2,"~"));
     drop lyn l1 l2;
     output;
   end;
   stop;
   run;quit;
   proc print data=_fix width=min;
   title1 "Keylist is in work datasets _fix";
   run;quit;
%mend keylista;





/*
__  ___ __  _   _
\ \/ / `_ \| | | |
 >  <| |_) | |_| |
/_/\_\ .__/ \__, |
     |_|    |___/
*/

%macro xpy / cmd parmbuff des='Usage: xpy roger. Type xpy roger for program banner with large font https://github.com/rogerjdeangelis/utl_program_banners';


/* see https://github.com/rogerjdeangelis/utl_program_banners */

%let afstr1=&syspbuff;

note;notesubmit '%xpya';

%mend xpy;

%macro xpya;

%local uj revslash;

options noovp;
title;
footnote;

data _null_;
   rc=filename('__xplp', "%sysfunc(pathname(work))/__xplp");
   if rc = 0 and fexist('__xplo') then rc=fdelete('__xplp');
   rc=filename('__xplp');
run;

%let revslash=%sysfunc(translate(%sysfunc(pathname(work)),'/','\'));
%put &=revslash;
run;quit;

* note uou can altename single and double quotes;
%utl_submit_py64_310(resolve('
import sys;
from pyfiglet import figlet_format;
txt=figlet_format("&afstr1.", font="standard");
with open("&revslash./__xplp","w") as f:;
.    f.write(txt);
'));

filename __dm clipbrd ;

   data _null_;
     infile "%sysfunc(pathname(work))/__xplp" end=dne;
     file __dm;
     input;
     _infile_=translate(_infile_,"`","'");
     if _n_=1 then substr(_infile_,1,2)='/*';
     putlog _infile_;
     put _infile_;
     if dne then do;
        put '*/';
        putlog '*/';
     end;
   run;

filename __dm clear;

%mend xpya;
