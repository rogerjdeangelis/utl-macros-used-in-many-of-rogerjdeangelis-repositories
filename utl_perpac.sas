/*

Below are a set of command macros that can greatly increase your programming performance.

I have over 20 of these performance command macros mapped to my logitect G203 5 button mouse
 and many more mapped to function keys, and if this in not enough the same
command macros can be called with and without arguments from the SAS classic editor command line.

All of SAS, R, Python and Perl can operate directly
on the SAS command line or on text the in the SAS classic (1980s) editor.
Python functions and code can be alsi be executed by mouse keys.


* just put this in your autoexcec;
%inc "c:/oto/utl_perpac.sas";
*/


%macro cuth/cmd;
  %do i=1 %to 20;
    c '  ' ' ' all;
  %end;
%mend cuth;


%macro tail / cmd
   des="last 10 obs from the last dataset";
   note;notesubmit '%taila;';
   run;
%mend tail;

%macro taila /cmd des="last 10 obs from table";
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  footnote;
  options nocenter;
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  proc sql noprint;
        select
           put(count(*),comma18.)
          ,count(*)
        into
          :tob  trimmed
         ,:tobs  trimmed
      from _last_;quit;
  title "last 11 obs %upcase(%sysfunc(getoption(_last_))) total obs=&tob";
  %let pobs=%sysfunc(ifn(&tobs > 10, %eval(&tobs - 10),1));
  proc print data=_last_ ( firstObs= &pobs ) width=min uniform  heading=horizontal;
     format _all_;
  run;quit;
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


%macro tailh /cmd des="lat 10 obs from highlighted dataset";
   store;note;notesubmit '%tailha;';
%mend tailh;


%macro tailha /cmd des="last 10 obs highlight dataset and type tailha for a list of 10 obs";
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
  title "last 11 obs from %upcase(&argx) total obs=&tob";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  %let pobs=%sysfunc(ifn(&tobs > 10, %eval(&tobs - 10),1));
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
%mend tailha;


%macro tailfh /cmd des="lat 10 obs from highlighted dataset";
   store;note;notesubmit '%tailfha;';
%mend tailfh;


%macro tailfha /cmd des="last 10 obs highlight dataset and type tailfha for a list of 10 obs";
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
  title "last 11 obs from %upcase(&argx) total obs=&tob";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  %let pobs=%sysfunc(ifn(&tobs > 10, %eval(&tobs - 10),1));
  proc print data=_last_ ( firstObs= &pobs ) width=min uniform  heading=horizontal;
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
%mend tailfha;



%macro ls40 / cmd
   des="list 40 obs from the last dataset";
   /* i put this on shift right mouse button */
   note;notesubmit '%ls40a;';
   run;
%mend ls40;

%macro ls40a /cmd des="Print 40 obs from table";
  dm "out;clear;";
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  footnote;
  options nocenter;
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' '
      from _last_;quit;
  title "Up to 40 obs %upcase(%sysfunc(getoption(_last_))) total obs=&tob";
  proc print data=_last_ ( Obs= 40 ) /*width=full*/ width=min uniform  heading=horizontal;
     format _all_;
  run;quit;
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
%mend ls40a;



%macro ls40h /cmd;
   store;note;notesubmit '%ls40ha;';
%mend ls40h;


%macro ls40ha /cmd des="highlight dataset and type ls40ha for a list of 40 obs";
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
  RUN;
  dm "out;clear;";
  footnote;
  options nocenter;
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' '
  from &argx;quit;
  title "Up to 40 obs from %upcase(&argx) total obs=&tob";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  proc print data=&argx( Obs= 40 ) /* width=full */ width=min uniform  heading=horizontal;
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
%mend ls40ha;



%macro ls40hf /cmd;
   store;note;notesubmit '%ls40haf;';
%mend ls40hf;


%macro ls40haf /cmd des="highlight dataset and type ls40ha for a list of 40 obs";
  FILENAME clp clipbrd ;
  DATA _NULL_;
    INFILE clp;
    INPUT;
    put _infile_;
    call symputx('argx',_infile_);
  RUN;
  dm "out;clear;";
  footnote;
  options nocenter;
  %utlfkil("%sysfunc(pathname(work))/__dm.txt");
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' '
  from &argx;quit;
  title "%upcase(&argx) total obs=&tob";
  proc printto print="%sysfunc(pathname(work))/__dm.txt";
  proc print data=&argx( Obs= 40)  width=min  heading=horizontal;
  proc printto;
  run;quit;
  title;
  filename __dm clipbrd ;
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
  dm "out;";
%mend ls40haf;





/* match %do and %end */
%macro doendh / cmd;
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
         lft=lft+count(upcase(_infile_),'%DO;');
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



%macro prth /cmd parmbuff;                                                                                                                                                                                                                              
/*-----------------------------------------*\                                                                                                                                                                                                           
|  highlight dataset in editor              |                                                                                                                                                                                                           
|  prt "sex='F'"                    |                                                                                                                                                                                                                   
\*-----------------------------------------*/                                                                                                                                                                                                           
   %let argx=&syspbuff;                                                                                                                                                                                                                                 
   store;note;notesubmit '%prtha;';                                                                                                                                                                                                                     
   run;                                                                                                                                                                                                                                                 
%mend prth;                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                        
%macro prtha;                                                                                                                                                                                                                                           
   filename clp clipbrd ;                                                                                                                                                                                                                               
   data _null_;                                                                                                                                                                                                                                         
     infile clp;                                                                                                                                                                                                                                        
     input;                                                                                                                                                                                                                                             
     put _infile_;                                                                                                                                                                                                                                      
     call symputx('argd',_infile_);                                                                                                                                                                                                                     
   run;                                                                                                                                                                                                                                                 
   dm "out;clear;";                                                                                                                                                                                                                                     
   options nocenter;                                                                                                                                                                                                                                    
   title1 "print of datasets &argd";                                                                                                                                                                                                                    
   title2 &argx;                                                                                                                                                                                                                                        
   proc print data=&argd(obs=60 )  width=min;                                                                                                                                                                                                           
   var &argx;                                                                                                                                                                                                                                           
   run;                                                                                                                                                                                                                                                 
   title;                                                                                                                                                                                                                                               
   dm "out;top;";                                                                                                                                                                                                                                       
%mend prtha;   
                                                                                                                                                                                                                                         
             
%macro utlfkil
    (
    utlfkil
    ) / des="delete an external file";


    /*-------------------------------------------------*\
    |                                                   |
    |  Delete an external file                          |
    |   From SAS macro guide                                                |
    |  Sample invocations                               |
    |                                                   |
    |  WIN95                                            |
    |  %utlfkil(c:\dat\utlfkil.sas);                    |
    |                                                   |
    |                                                   |
    |  Solaris 2.5                                      |
    |  %utlfkil(/home/deangel/delete.dat);              |
    |                                                   |
    |                                                   |
    |  Roger DeAngelis                                  |
    |                                                   |
    \*-------------------------------------------------*/

    %local urc;

    /*-------------------------------------------------*\
    | Open file   -- assign file reference              |
    \*-------------------------------------------------*/

    %let urc = %sysfunc(filename(fname,%quote(&utlfkil)));

    /*-------------------------------------------------*\
    | Delete file if it exits                           |
    \*-------------------------------------------------*/

    %if &urc = 0 and %sysfunc(fexist(&fname)) %then
        %let urc = %sysfunc(fdelete(&fname));

    /*-------------------------------------------------*\
    | Close file  -- deassign file reference            |
    \*-------------------------------------------------*/

    %let urc = %sysfunc(filename(fname,''));

  run;

%mend utlfkil;

%macro sumv / cmd
    des="highlight row of numeric variables and type sumh on command line for proc means using last dataset";
   store;note;notesubmit '%sumva;';
   run;
%mend sumv;

%macro sumva;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc means data=_last_ n sum mean min q1 median q3 max;var',_infile_,';run;quit');
     call execute (cmd);
   run;
%mend sumva;



%macro avgh / cmd
   des="highlight dataset or view in the classic editor and type avgh on command line for proc means";
   store;note;notesubmit '%avgha;';
   run;
%mend avgh;

%macro avgha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc means data=',_infile_,'n sum mean min q1 median q3 max;run;quit');
     call execute (cmd);
   run;
%mend avgha;




%macro frqv / cmd
   des="highlight list of variables and type frqv on command line for proc freq data=_last_ ";
   store;note;notesubmit '%frqva;';
   run;
%mend frqv;

%macro frqva;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc freq  data=_last_ levels order=freq;tables',_infile_,'/missing;run;quit');
     call execute (cmd);
   run;
%mend frqva;


%macro unv / cmd
   des="highlight row of numeric variables and type unv on command line for proc univariate data=_last_ ";
   store;note;notesubmit '%unva;';
   run;
%mend unv;

%macro unva;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc univariate data=_last_ plot;var',_infile_,';run;quit');
     call execute (cmd);
   run;
%mend unva;




%macro cntv / cmd
   des="highlight a single variable and type cntv on command line for sql distinct count distinct data=_last_ ";
   /* better on a function key or mouse action */
   store;note;notesubmit '%cntva';
   run;
%mend cntv;


%macro cntva;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=catx(' ','proc sql;select','"',_infile_,'" as var, count(*) as obs, count(distinct',_infile_,') as lvl from _last_;quit;');
     putlog cmd;
     call execute (cmd);
   run;
%mend cntva;




%macro dmp /cmd
   des="middle observation of last dataset printed vertically";
   /* I put this on function het F5 */
   note;notesubmit '%dmpa';
   run;
%mend dmp;

%macro dmpa;
   /* all this to get middle record */
   %symdel tob;
   proc sql;select count(*) into :tob separated by ' ' from _last_;quit;
   data _null_;
      If _n_=0 then set _last_ nobs=mobs;
      rec=max(int(mobs/2),1);
      set _last_ point=rec;
      put "Middle Observation(" rec ") of Last dataset = %sysfunc(getoption(_last_)) - Total Obs &tob";
      array chr[*] _character_;
      array num[*] _numeric_;
      putlog // ' -- CHARACTER -- ';
      do i=1 to dim(chr);
         nam=vname(chr[i]);
         typ=vtype(chr[i]);
         len=vlength(chr[i]);
         lbl=vlabel(chr[i]);
         putlog @1 nam @34 typ @39 len @47 chr[i] $16. @67 lbl;
      end;
      putlog // ' -- NUMERIC -- ';
      do i=1 to dim(num);
         nam=vname(num[i]);
         typ=vtype(num[i]);
         len=vlength(num[i]);
         lbl=vlabel(num[i]);
         putlog @1 nam @34 typ @39 len @47 num[i] best.-l @67 lbl;
      end;
      stop;
   run;quit;
%mend dmpa;




%macro dmph /cmd
   des="middle observation of highlighted dataset printed vertically with type length and sample value";
   store;note;notesubmit '%dmpha;';
   run;
%mend dmph;
%macro dmpha;

   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('argx',_infile_);
   run;
   /* all this to get middle record */
   %symdel tob;

   proc sql;select count(*) into :tob separated by ' ' from &argx;quit;
   run;

   data _null_;

      If _n_=0 then set &argx nobs=mobs;
      rec=max(int(mobs/2),1);
      set &argx point=rec;
      totobs=put(&tob,comma16. -l);
      put "Middle Observation(" rec ") of &argx - Total Obs " totobs;
      array chr[*] _character_;
      array num[*] _numeric_;
      putlog // ' -- CHARACTER -- ';
      do i=1 to dim(chr);
         nam=vname(chr[i]);
         typ=vtype(chr[i]);
         len=vlength(chr[i]);
         lbl=vlabel(chr[i]);
         putlog @1 nam @34 typ @39 len @47 chr[i] $16. @67 lbl;
      end;
      putlog // ' -- NUMERIC -- ';
      do i=1 to dim(num);
         nam=vname(num[i]);
         typ=vtype(num[i]);
         len=vlength(num[i]);
         lbl=vlabel(num[i]);
         putlog @1 nam @34 typ @39 len @47 num[i] best.-l @67 lbl;
      end;
      stop;
   run;quit;
%mend dmpha;







%macro lsal / cmd
   des="list all obs from the last dataset - type lsal on command line";
   note;notesubmit '%lsala;';
   run;
%mend lsal;

%macro lsala /cmd;
   dm "out;clear;";
  proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' '
  from _last_;quit;
  title "Up to 40 obs %upcase(%sysfunc(getoption(_last_))) total obs=&tob";
  proc print data=_last_  uniform  heading=horizontal width=full;
   footnote;
   format _all_;
   run;
   title;
   dm "out;;top";
%mend lsala;



%macro frqh /cmd parmbuff
   des="highlight dataset and type frqh sex on command line for a frequency on sex";
   %let argx=%scan(&syspbuff,1,%str( ));
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
   run;
   dm "out;clear;";
   options nocenter;
   footnote;
   title1 "frequency of &argx datasets &argd";
   proc freq data=&argd levels;
   tables &argx./list missing;
   run;
   title;
   dm "out;top;";
%mend frqha;






/* data class;set sashelp.class;run;quit; */


%macro cnt /cmd parmbuff
   des="type cnt sex on command line for a frequency on sex for last dataset";
   %let argx=%scan(&syspbuff,1,%str( ));
   %let argx=%sysfunc(translate(&argx,%str(,),%str(*)));
   %put &=argx;
   note;notesubmit '%cnta;';
%mend cnt;

%macro cnta;
  proc sql noprint;select put(count(*),comma18.) into :__tob  separated by ' '
  from _last_;quit;
  proc sql;select "%sysfunc(getoption(_last_))(obs=&__tob) and levels of (&argx)"
       ,count(*) from (select distinct &argx  from _last_);quit;
%mend cnta;






%macro cnth /cmd parmbuff
   des="highlight dataset and type cnth sex on command line for a frequency on sex";
   %let argx=%scan(&syspbuff,1,%str( ));
   %let argx=%sysfunc(translate(&argx,%str(,),%str(*)));
   %put &=argx;
   store;note;notesubmit '%cntha;';
%mend cnth;

%macro cntha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('__argd',_infile_);
   run;
  proc sql noprint;select put(count(*),comma18.) into :__tob  separated by ' '
  from _last_;quit;
  proc sql;select "%sysfunc(getoption(_last_))(obs=&__tob) and levels of (&argx)"
       ,count(*) from (select distinct &argx  from &__argd );quit;
%mend cntha;






%macro frq /cmd parmbuff
des="type frq sex*sage on command line for a crosspatb frequency on sex*age for last dataset";
/*-----------------------------------------*\
|  frq sex*age                              |
\*-----------------------------------------*/
   %let argx=%scan(&syspbuff,1,%str( ));
   %*syslput argx=&argx;
   note;notesubmit '%frqa;';
   run;
%mend frq;

%macro frqa;
   dm "out;clear;";
   *rsubmit;
   options nocenter;
   footnote;
   title1 "Frequency of &argx datasets %sysfunc(getoption(_last_))";
   proc freq data=_last_ levels;
   tables &argx./list missing;
   run;
   title;
   *endrsubmit;
   dm "out;top;";
%mend frqa;






%macro prtwh /cmd parmbuff;
/*-----------------------------------------*\
|  highlight dataset in editor              |
|  prt "sex='F'"                    |
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
   options nocenter;
   title1 "print of datasets &argd";
   title2 &argx;
   proc print data=&argd(obs=60 where=(%sysfunc(dequote(&argx))))  width=min;
   run;
   title;
   dm "out;top;";
%mend prtwha;



%macro prtw /cmd parmbuff;
/*-----------------------------------------*\
|  highlight dataset in editor              |
|  prt "sex='F'"                    |
\*-----------------------------------------*/
   %let argx=&syspbuff;
   note;notesubmit '%prtwa;';
   run;
%mend prtw;

%macro prtwa;
   dm "out;clear;";
   options nocenter;
   title1 "print of datasets %sysfunc(getoption(_last_))";
   title2 &argx;
   proc print data=_last_(obs=60 where=(%sysfunc(dequote(&argx))))  width=min;
   run;
   title;
   dm "out;top;";
%mend prtwa;





%macro debugh/cmd
   des="highlight macro and type debug on command line to debug the macro";
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






%macro parh / cmd
   des="highlight a line of code and type parh on the command line to test for unbalanced quotes";
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







%macro con / cmd des="type conh on command line. Contents of last dataset in outptut";
  note;notesubmit '%cona;';
%mend con;

%macro cona   / cmd des="create contents output";
dm "out;clear;";
  options nocenter;
  footnote;
  proc contents data=_last_ position;
  run;
  title;
run;
dm "out;top;";
%mend cona;





%macro conh / cmd des="highlight dataseta and type conh on command line. Results in output window";
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





%macro lsalh / cmd des="Type lsalh on command line. Lista ll obs highlighted dataset";
  store;note;notesubmit '%lsalha;';
%mend lsalh;

%macro lsalha;
FILENAME clp clipbrd ;
DATA _NULL_;
  INFILE clp;
  INPUT;
  put _infile_;
  call symputx('argx',_infile_);
RUN;
dm "out;clear;";
proc sql noprint;select put(count(*),comma18.) into :tob  separated by ' '
  from &argx;quit;
title "All Obs(&tob) from dataset &argx.";
options nocenter;
proc print  data=&argx. width=min;
format _all_;
run;
title;
dm "out;top";
%mend lsalha;








%macro vu  / cmd des="viewtable of last dataset created";
   vt _last_ COLHEADING=NAMES;
   run;
%mend vu ;






%macro vuh / cmd des="viewtable of highlighted dataset";
   note;notesubmit '%vuha;';
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




%macro xlsh /cmd des="highlight dataset and type xlsh and the dataset will appear in excel";;
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





%macro iota(utliota1)/cmd
   des="type iota 10 and a list or 01 02 02 - 10 will be added to the editor";
   sub '%iotb';
%mend iota;


%macro iotb
/ des="Called by utliota n integers in editor";

%local ui;
%let urc=%sysfunc(filename(utliotb1,"work.utliotb1.utliotb1.catams"));

%put urc=&urc;

%let ufid = %sysfunc(fopen(&utliotb1,o));

%do ui = 1 %to &utliota1;

%let uzdec = %sysfunc(putn(&ui,z%length(&utliota1)..));

%let urc=%sysfunc(fput(&ufid,&uzdec));

%let urc=%sysfunc(fwrite(&ufid));

%end;

%let urc=%sysfunc(fclose(&ufid));

%let urc=%sysfunc(filename(utliotb1));

dm "inc 'work.utliotb1.utliotb1.catams'";

%mend iotb;












%macro xplo ( AFSTR1 )/cmd des="type xplo ONEaTWO and exploded letters will be saved in past buffer";

/*-----------------------------------------*\
|  xplo ONEaTWOaTHREE                       |
|  lower case letters produce spaces        |
\*-----------------------------------------*/

note;notesubmit '%xploa';

%mend xplo;

%macro xploa
/  des = "Exploded Banner for Printouts";

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


%macro utlfix(dum) / des="vcalled by unfreeze command";
* fix frozen sas and restore to invocation ;
 dm "odsresults;clear;";
 options ls=171 ps=65;run;quit;
 ods listing;
 ods select all;
 ods graphics off;
 proc printto;run;
 goptions reset=all;
 endsubmit;
 endrsubmit;
 run;quit;
 %utlopts;

%mend utlfix;




%macro evlh / cmd
   des="highlight expression to evaluate. ie highlight  2*(3+1) and  8 will appear in log";
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

%macro sumh / cmd;
   store;note;notesubmit '%sumha;';
   run;
%mend sumh;

%macro sumha;
   filename clp clipbrd ;
   data _sumh_;
     infile clp;
     input x;
   run;quit;
   proc means data=_sumh_ n sum mean min q1 median q3 max;run;quit
%mend sumha;



%macro bueh / cmd des="highlight 'set view_class' and the view code will appear" ;
   store;note;notesubmit '%bueha;';
   run;
%mend bueh;


%macro bueha;
   filename _tmp_ clear;
   %utlchkfyl(%sysfunc(pathname(work))/_vue.txt);
   filename tmp "%sysfunc(pathname(work))/_vue.txt";
   filename clp clipbrd ;
   data _null_;
     infile clp end=dne;
     file tmp;
     put 'data _vue/view=_vue;';
     do until (dne);
        input ;
        put _infile_;
     end;
     if dne then do;
        put ';run;quit;';
        put 'data view=_vue;describe;run;quit;';
     end;
     stop;
   run;quit;
   %include "%sysfunc(pathname(work))/_vue.txt";
   filename tmp clear;
%mend bueha;



%macro mGetFileNoExt(pth)/des="macro variable get file name without extension";
   %qscan(&pth,-2,%str(./\))
 %mend mGetFileNoExt;

%macro mGetFileWithExt(pth)/des="macro variable get file name with extention";
   %qscan(&pth,-1,%str(/\))
%mend mGetFileWithExt;

%macro mgetFolder(pth)/des="macro variable get folder name";
   %let revstr=%qleft(%qsysfunc(reverse(&pth)));
   %let cutstr=%qsubstr(&revstr,%qsysfunc(indexc(&revstr,%str(/\))));
   %let gotstm=%qleft(%qsysfunc(reverse(&cutstr)));
   %str(&gotstm)
%mend mgetFolder;


%macro getFileNoExt(pth)/des="datastep variable get file name without extension";
   scan(full_path,-2,"./\")
 %mend getFileNoExt;

%macro getFileWithExt(pth)/des="datastep variable get file name with extension";
   scan(full_path,-1,"/\")
%mend GetFileWithExt;


%macro getFolder(pth)/des="datastep variable get folder name";
 left(reverse(left(scan(reverse(full_path),1,"/\"))))
%mend getFolder;

%macro cath / cmd des="applies to sasuser,profile. List catalog entries in the log";
   /* highlight
         dmkeys.keys anf type cath on the classic editor command line
         box.source  for a comment box
         hdr.source for standard header
      or for source entries
         put an 'a'(for after) in the prefic area and type copy box on the command line
*/
   store;note;notesubmit '%catha;';
   run;
%mend cath;

%macro catha;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     cmd=cats('filename _cat catalog "sasuser.profile.',compress(_infile_),
     '";data _null_;infile _cat;input;putlog _infile_ $171. ;run;quit;');
     putlog cmd;
     call execute(cmd);
   run;
%mend catha;

   %macro utl_vartype(dsn,var)/des="Variable type returns N or C";
     %local dsid posv rc;
      %let dsid = %sysfunc(open(&dsn,i));
      %let posv = %sysfunc(varnum(&dsid,&var));
      %sysfunc(vartype(&dsid,&posv))
      %let rc = %sysfunc(close(&dsid));
   %mend utl_vartype;

   %macro utl_varlen(dsn,var)/des="Variable length";
     %local dsid posv rc;
      %let dsid = %sysfunc(open(&dsn,i));
      %let posv = %sysfunc(varnum(&dsid,&var));
      %sysfunc(varlen(&dsid,&posv))
      %let rc = %sysfunc(close(&dsid));
   %mend utl_varlen;

   %macro utl_varfmt(dsn,var)/des="Variable format";
     %local dsid posv rc;
      %let dsid = %sysfunc(open(&dsn,i));
      %let posv = %sysfunc(varnum(&dsid,&var));
      %sysfunc(varfmt(&dsid,&posv))
      %let rc = %sysfunc(close(&dsid));
   %mend utl_varfmt;

   %macro utl_varinfmt(dsn,var)/des="Variable informat";
     %local dsid posv rc;
      %let dsid = %sysfunc(open(&dsn,i));
      %let posv = %sysfunc(varnum(&dsid,&var));
      %sysfunc(varinfmt(&dsid,&posv))
      %let rc = %sysfunc(close(&dsid));
   %mend utl_varinfmt;

   %macro utl_varlabel(dsn,var)/des="Variable label";
     %local dsid posv rc;
      %let dsid = %sysfunc(open(&dsn,i));
      %let posv = %sysfunc(varnum(&dsid,&var));
      %sysfunc(varlabel(&dsid,&posv))
      %let rc = %sysfunc(close(&dsid));
   %mend utl_varlabel;

   %macro utl_varcount(dsn)/des="Number of variables";
     %local dsid posv rc;
       %let dsid = %sysfunc(open(&dsn,i));
       %sysfunc(attrn(&dsid,NVARS));
       %let rc = %sysfunc(close(&dsid));
   %mend utl_varcount;


    /* comment a block of text */
    %macro cm / cmd;
          c ' ' '/*' first;c ' ' '*/' last;
    %mend cm;
