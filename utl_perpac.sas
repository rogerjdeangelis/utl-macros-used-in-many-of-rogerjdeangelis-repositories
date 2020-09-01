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
  proc print data=&argx ( firstObs= &pobs ) width=min uniform  heading=horizontal;
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
     cmd=catx(' ','proc means data=_last_ n sum mean std min q1 median q3 max;var',_infile_,';run;quit');
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
  proc print data=_last_  heading=horizontal width=min;
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

%macro cnth /cmd parmbuff;                                                                                            
   %let argx=&syspbuff;                                                                                               
   %*syslput argx=&argx;                                                                                              
   %* add comma for sql;                                                                                              
   %let argx=%sysfunc(translate(&argx,%str(,),%str( )));                                                              
   store;note;notesubmit '%cntha;';                                                                                   
   run;                                                                                                               
%mend cnth;                                                                                                           
                                                                                                                      
%macro cntha;                                                                                                         
   filename clp clipbrd ;                                                                                             
   data _null_;                                                                                                       
     infile clp;                                                                                                      
     input;                                                                                                           
     put _infile_;                                                                                                    
     call symputx('argd',_infile_);                                                                                   
   run;                                                                                                               
   proc sql noprint;                                                                                                  
    select put(count(*), comma18.) into :_cnt_ separated by '' from ( select distinct &argx from &argd);              
    select put(count(*), comma18.) into :_obs_ separated by '' from &argd;                                            
   quit;                                                                                                              
   %put "----- Number of unique levels=&_cnt_ for &argx from &argd (obs=&_obs_) -----";                               
%mend cntha;                                                                                                          
                                                                                                                      
                                                                                                                      
%macro cnt /cmd parmbuff;                                                                                             
   %let argx=&syspbuff;                                                                                               
   %*syslput argx=&argx;                                                                                              
   %let argx=%sysfunc(translate(&argx,%str(,),%str( )));                                                              
   note;notesubmit '%cnta;';                                                                                          
   run;                                                                                                               
%mend cnt;                                                                                                            
                                                                                                                      
%macro cnta;                                                                                                          
  proc sql noprint;                                                                                                   
    select count(*) into :_cnt_ separated by '' from ( select distinct &argx from _last_);                            
    select count(*) into :_obs_ separated by '' from _last_;                                                          
  quit;                                                                                                               
  %put "----- Number of unique levels=&_cnt_ for &argx from %sysfunc(getoption(_last_))(obs=&_obs_) -----";           
%mend cnta;                                                                                                           
                                                                                                                      
                                                                                                                      





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



%macro prt /cmd parmbuff;
/*-----------------------------------------*\
|  highlight dataset in editor              |
|  prt "sex='F'"                    |
\*-----------------------------------------*/
   %let argx=&syspbuff;
   note;notesubmit '%prta;';
   run;
%mend prtw;

%macro prta;
   dm "out;clear;";
   options nocenter;
   title1 "print of datasets %sysfunc(getoption(_last_))";
   title2 &argx;
   proc print data=_last_(obs=60 where=(%sysfunc(dequote(&argx))))  width=min;
   run;
   title;
   dm "out;top;";
%mend prta;





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
   proc means data=_sumh_ n sum mean std min q1 median q3 max;run;quit
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

%macro sasbat /cmd des="highlight code type sas7bat on command line";                                             
   store;note;notesubmit '%sasbath;';                                                                             
%mend sasbat;                                                                                                     
                                                                                                                  
%macro sasbath;                                                                                                   
                                                                                                                  
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
                                                                                                                  
  filename sin pipe %sysfunc(compbl("c:\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin d:/log/__clp.sas        
        -log d:/log/__clp.log -autoexec c:\oto\tut_oto.sas                                                        
       -print d:/log/__clp.lst -config \cfg\cfgsas94m6.cfg -sasautos c:/oto"));                                   
                                                                                                                  
   data _null_;                                                                                                   
     infile sin;                                                                                                  
     input;                                                                                                       
     put _infile_;                                                                                                
   run;quit;                                                                                                      
                                                                                                                  
   x notepad.exe d:/log/__clp.log;                                                                                
                                                                                                                  
%mend sasBath;                                                                                                    
                                                                                                                  


%macro xpy()/cmd parmbuff;

%let afstr1=&syspbuff;

/*-----------------------------------------*\
|  xplo %str(ONE TWO THREE)                 |
|  lower case letters produce spaces        |
\*-----------------------------------------*/

note;notesubmit '%xpya';

%mend xpy;

%macro xpy()/cmd parmbuff;                                                       
                                                                                 
%let afstr1=&syspbuff;                                                           
                                                                                 
/*-----------------------------------------*\                                    
|  xplo %str(ONE TWO THREE)                 |                                    
|  lower case letters produce spaces        |                                    
\*-----------------------------------------*/                                    
                                                                                 
note;notesubmit '%xpya';                                                         
                                                                                 
%mend xpy;                                                                       
                                                                                 
%macro xpya                                                                      
/  des = "Exploded Banner for Printouts";                                        
                                                                                 
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
%utl_submit_py64_38(resolve('                                                    
import sys;                                                                      
from pyfiglet import figlet_format;                                              
txt=figlet_format("&afstr1.", font="standard");                                  
with open("&revslash./__xplp", "w") as f:;                                       
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



%macro utl_submit_py64_38(                                                                                                                                                                                                                                      
      pgm                                                                                                                                                                                                                                                       
     ,return=  /* name for the macro variable from Python */                                                                                                                                                                                                    
     )/des="Semi colon separated set of python commands - drop down to python";                                                                                                                                                                                 
                                                                                                                                                                                                                                                                
  * write the program to a temporary file;                                                                                                                                                                                                                      
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recfm=v;                                                                                                                                                                                     
  data _null_;                                                                                                                                                                                                                                                  
    length pgm  $32755 cmd $1024;                                                                                                                                                                                                                               
    file py_pgm ;                                                                                                                                                                                                                                               
    pgm=&pgm;                                                                                                                                                                                                                                                   
    semi=countc(pgm,";");                                                                                                                                                                                                                                       
      do idx=1 to semi;                                                                                                                                                                                                                                         
        cmd=cats(scan(pgm,idx,";"));                                                                                                                                                                                                                            
        if cmd=:". " then                                                                                                                                                                                                                                       
           cmd=trim(substr(cmd,2));                                                                                                                                                                                                                             
         put cmd $char384.;                                                                                                                                                                                                                                     
         putlog cmd $char384.;                                                                                                                                                                                                                                  
      end;                                                                                                                                                                                                                                                      
  run;quit;                                                                                                                                                                                                                                                     
  %let _loc=%sysfunc(pathname(py_pgm));                                                                                                                                                                                                                         
  %put &_loc;                                                                                                                                                                                                                                                   
  filename rut pipe  "c:\Python38\python.exe &_loc";                                                                                                                                                                                                   
  data _null_;                                                                                                                                                                                                                                                  
    file print;                                                                                                                                                                                                                                                 
    infile rut;                                                                                                                                                                                                                                                 
    input;                                                                                                                                                                                                                                                      
    put _infile_;                                                                                                                                                                                                                                               
  run;                                                                                                                                                                                                                                                          
  filename rut clear;                                                                                                                                                                                                                                           
  filename py_pgm clear;                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                
  * use the clipboard to create macro variable;                                                                                                                                                                                                                 
  %if "&return" ^= "" %then %do;                                                                                                                                                                                                                                
    filename clp clipbrd ;                                                                                                                                                                                                                                      
    data _null_;                                                                                                                                                                                                                                                
     length txt $200;                                                                                                                                                                                                                                           
     infile clp;                                                                                                                                                                                                                                                
     input;                                                                                                                                                                                                                                                     
     putlog "*******  " _infile_;                                                                                                                                                                                                                               
     call symputx("&return",_infile_,"G");                                                                                                                                                                                                                      
    run;quit;                                                                                                                                                                                                                                                   
  %end;                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                
%mend utl_submit_py64_38;            



%macro utlnopts(note2err=nonote2err,nonotes=nonotes)
    / des = "Turn  debugging options off";

OPTIONS
     MSGLEVEL=N
     FIRSTOBS=1
     NONUMBER
     MLOGICNEST
   /*  MCOMPILENOTE */
     MPRINTNEST
     lrecl=384
     MAUTOLOCDISPLAY
     NOFMTERR     /* turn  Format Error off                           */
     NOMACROGEN   /* turn  MACROGENERATON off                         */
     NOSYMBOLGEN  /* turn  SYMBOLGENERATION off                       */
     &NONOTES     /* turn  NOTES off                                  */
     NOOVP        /* never overstike                                  */
     NOCMDMAC     /* turn  CMDMAC command macros on                   */
     NOSOURCE    /* turn  source off * are you sure?                 */
     NOSOURCE2    /* turn  SOURCE2   show gererated source off        */
     NOMLOGIC     /* turn  MLOGIC    macro logic off                  */
     NOMPRINT     /* turn  MPRINT    macro statements off             */
     NOCENTER     /* turn  NOCENTER  I do not like centering          */
     NOMTRACE     /* turn  MTRACE    macro tracing                    */
     NOSERROR     /* turn  SERROR    show unresolved macro refs       */
     NOMERROR     /* turn  MERROR    show macro errors                */
     OBS=MAX      /* turn  max obs on                                 */
     NOFULLSTIMER /* turn  FULLSTIMER  give me all space/time stats   */
     NODATE       /* turn  NODATE      suppress date                  */
     DSOPTIONS=&NOTE2ERR
     ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
     DKRICOND=ERROR    /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */

     /* NO$SYNTAXCHECK  be careful with this one */
;

RUN;quit;

%MEND UTLNOPTS;

%MACRO UTLOPTS
         / des = "Turn all debugging options off forgiving options";

OPTIONS
   MSGLEVEL=I
   OBS=MAX
   FIRSTOBS=1
   lrecl=384
   NOFMTERR      /* DO NOT FAIL ON MISSING FORMATS                              */
   SOURCE      /* turn sas source statements on                               */
   SOURCe2     /* turn sas source statements on                               */
   MACROGEN    /* turn  MACROGENERATON ON                                     */
   SYMBOLGEN   /* turn  SYMBOLGENERATION ON                                   */
   NOTES       /* turn  NOTES ON                                              */
   NOOVP       /* never overstike                                             */
   CMDMAC      /* turn  CMDMAC command macros on                              */
   /* ERRORS=2    turn  ERRORS=2  max of two errors                           */
   MLOGIC      /* turn  MLOGIC    macro logic                                 */
   MPRINT      /* turn  MPRINT    macro statements                            */
   MRECALL     /* turn  MRECALL   always recall                               */
   MERROR      /* turn  MERROR    show macro errors                           */
   NOCENTER    /* turn  NOCENTER  I do not like centering                     */
   DETAILS     /* turn  DETAILS   show details in dir window                  */
   SERROR      /* turn  SERROR    show unresolved macro refs                  */
   NONUMBER    /* turn  NONUMBER  do not number pages                         */
   FULLSTIMER  /*   turn  FULLSTIMER  give me all space/time stats            */
   NODATE      /* turn  NODATE      suppress date                             */
   /*DSOPTIONS=NOTE2ERR                                                                              */
   /*ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
   DKRICOND=WARN      /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */
   DKROCOND=WARN      /*  variable is missing from output data during a DROP=, KEEP=, or RENAME=     */
   /* NO$SYNTAXCHECK  be careful with this one */
 ;

run;quit;

%MEND UTLOPTS;



%macro utlfkil                                               
    (                                                        
    utlfkil                                                  
    ) / des="delete an external file";                       
                                                             
                                                             
    /*-------------------------------------------------*\    
    |                                                   |    
    |  Delete an external file                          |    
    |   From SAS macro guide                            |    
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
                                                             
    %let urc = %sysfunc(filename(fname,""));                 
                                                             
  run;                                                       
                                                             
%mend utlfkil;                                               
                                                             

%macro utl_submit_r64(
      pgmx
     ,returnVar=N           /* set to Y if you want a return SAS macro variable from python */
     )/des="Semi colon separated set of R commands - drop down to R";
  * write the program to a temporary file;
  filename r_pgm "d:/txt/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    pgm=&pgmx;
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "C:\R362\bin\R.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;

  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;

%mend utl_submit_r64;

                                                                                                                                                                                                                                                               
%macro utl_macrodelete(macro)/des="delete catalog macro entry";                                                                                                                                                                                                 
   %if (%sysfunc(cexist(&macro))) %then %do;                                                                                                                                                                                                                    
       proc catalog catalog=work.sasmacr;                                                                                                                                                                                                                       
           delete cst_050.macro;                                                                                                                                                                                                                                
       quit;                                                                                                                                                                                                                                                    
       %put work.sasmacr.cst_050.macro deleted;                                                                                                                                                                                                                 
   %end;                                                                                                                                                                                                                                                        
%mend utl_macrodelete;        


%macro debug/cmd;                                                                                                                       
   store;note;notesubmit '%debuga;';                                                                                                    
   run;                                                                                                                                 
%mend debug;                                                                                                                            
                                                                                                                                        
%macro debuga;                                                                                                                          
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
%mend debuga;   



%macro arraydelete(pfx)/des="Delete array macrovariables create by array macro";
  %do i= 1 %to &&&pfx.n;
      %symdel &pfx&i / nowarn;
  %end;
  %symdel  &&pfx.n / nowarn;
%mend arraydelete;







%MACRO DO_OVER(arraypos, array=, 
               values=, delim=%STR( ),
               phrase=?, escape=?, between=, 
               macro=, keyword=);

 /*  Last modified: 8/4/2006
                                                           72nd col -->|
  Function: Loop over one or more arrays of macro variables 
           substituting values into a phrase or macro.

  Authors: Ted Clay, M.S.  
              Clay Software & Statistics
              tclay@ashlandhome.net  (541) 482-6435
           David Katz, M.S. www.davidkatzconsulting.com
         "Please keep, use and pass on the ARRAY and DO_OVER macros with
               this authorship note.  -Thanks "
          Send any improvements, fixes or comments to Ted Clay.

  Full documentation with examples appears in 
     "Tight Looping with Macro Arrays".SUGI Proceedings 2006, 
       The keyword parameter was added after the SUGI article was written.

  REQUIRED OTHER MACROS:
        NUMLIST -- if using numbered lists in VALUES parameter.
        ARRAY   -- if using macro arrays.

  Parameters:

     ARRAYPOS and 
     ARRAY are equivalent parameters.  One or the other, but not both, 
             is required.  ARRAYPOS is the only position parameter. 
           = Identifier(s) for the macro array(s) to iterate over. 
             Up to 9 array names are allowed. If multiple macro arrays
             are given, they must have the same length, that is, 
             contain the same number of macro variables.

     VALUES = An explicit list of character strings to put in an 
             internal macro array, VALUES may be a numbered lists of 
             the form 3-15, 03-15, xx3-xx15, etc.

     DELIM = Character used to separate values in VALUES parameter.  
             Blank is default.

     PHRASE = SAS code into which to substitute the values of the 
             macro variable array, replacing the ESCAPE
             character with each value in turn.  The default
             value of PHRASE is a single <?> which is equivalent to
             simply the values of the macro variable array.
             The PHRASE parameter may contain semicolons and extend to
             multiple lines.
             NOTE: The text "?_I_", where ? is the ESCAPE character, 
                   will be replaced with the value of the index variable
                   values, e.g. 1, 2, 3, etc. 
             Note: Any portion of the PHRASE parameter enclosed in 
               single quotes will not be scanned for the ESCAPE.
               So, use double quotes within the PHRASE parameter. 

             If more than one array name is given in the ARRAY= or 
             ARRAYPOS parameter, in the PHRASE parameter the ESCAPE 
             character must be immediately followed by the name of one 
             of the macro arrays, using the same case.

     ESCAPE = A single character to be replaced by macro array values.
             Default is "?".  

     BETWEEN = code to generate between iterations of the main 
             phrase or macro.  The most frequent need for this is to
             place a comma between elements of an array, so the special
             argument COMMA is provided for programming convenience.
             BETWEEN=COMMA is equivalent to BETWEEN=%STR(,).

     MACRO = Name of an externally-defined macro to execute on each 
             value of the array. It overrides the PHRASE parameter.  
             The parameters of this macro may be a combination of 
             positional or keyword parameters, but keyword parameters
             on the external macro require the use of the KEYWORD=
             parameter in DO_OVER.  Normally, the macro would have 
             only positional parameters and these would be defined in
             in the same order and meaning as the macro arrays specified
             in the ARRAY or ARRAYPOS parameter. 
             For example, to execute the macro DOIT with one positional
             parameter, separately define
                      %MACRO DOIT(STRING1); 
                          <statements>
                      %MEND;
             and give the parameter MACRO=DOIT.  The values of AAA1, 
             AAA2, etc. would be substituted for STRING.
             MACRO=DOIT is equivalent to PHRASE=%NRQUOTE(%DOIT(?)).
             Note: Within an externally defined macro, the value of the 
             macro index variable would be coded as "&I".  This is 
             comparable to "?_I_" within the PHRASE parameter.

    KEYWORD = Name(s) of keyword parameters used in the definition of 
             the macro refered to in the MACRO= parameter. Optional.  
             This parameter controls how DO_OVER passes macro array 
             values to specific keyword parameters on the macro.
             This allows DO_OVER to execute a legacy or standard macro.
             The number of keywords listed in the KEYWORD= parameter
             must be less than or equal to the number of macro arrays 
             listed in the ARRAYPOS or ARRAY parameter.  Macro array 
             names are matched with keywords proceeding from right 
             to left.  If there are fewer keywords than macro array 
             names, the remaining array names are passed as positional 
             parameters to the external macro.  See Example 6.

  Rules:
      Exactly one of ARRAYPOS or ARRAY or VALUES is required.
      PHRASE or MACRO is required.  MACRO overrides PHRASE.
      ESCAPE is used when PHRASE is used, but is ignored with MACRO.
      If ARRAY or ARRAYPOS have multiple array names, these must exist 
          and have the same length.  If used with externally defined 
          MACRO, the macro must have positional parameters that 
          correspond 1-for-1 with the array names.  Alternatively, one 
          can specify keywords which tell DO_OVER the names of keyword 
          parameters of the external macro.
 
  Examples:
     Assume macro array AAA has been created with 
             %ARRAY(AAA,VALUES=x y z)
      (1) %DO_OVER(AAA) generates: x y z;
      (2) %DO_OVER(AAA,phrase="?",between=comma) generates: "x","y","z"
      (3) %DO_OVER(AAA,phrase=if L="?" then ?=1;,between=else) generates:
                    if L="x" then x=1;
               else if L="y" then y=1;
               else if L="z" then z=1;
 
      (4) %DO_OVER(AAA,macro=DOIT) generates:
                %DOIT(x) 
                %DOIT(y)
                %DOIT(z)
          which assumes %DOIT has a single positional parameter.
          It is equivalent to:
          %DO_OVER(AAA,PHRASE=%NRSTR(%DOIT(?)))

      (5) %DO_OVER(AAA,phrase=?pct=?/tot*100; format ?pct 4.1;) 
            generates: 
                xpct=x/tot*100; format xpct 4.1;
                ypct=y/tot*100; format ypct 4.1;
                zpct=z/tot*100; format zpct 4.1;
      (6) %DO_OVER(aa bb cc,MACRO=doit,KEYWORD=borders columns)
         is equivalent to %DO_OVER(aa,bb,cc,
                  PHRASE=%NRSTR(%doit(?aa,borders=?bb,columns=?cc)))
         Either example would generate the following internal do-loop:
         %DO I=1 %to &AAN;
           %doit(&&aa&I,borders=&&bb&I,columns=&&cc&I)
         %END;
         Because we are giving three macro array names, the macro DOIT 
         must have three parameters.  Since there are only two keyword
         parameters listed, the third parameter is assumed to be 
         positional.  Positional parameters always preceed keyword
         parameters in SAS macro definitions, so the first parameter
         a positional parameter, which is given the values of first 
         macro array "aa".  The second is keyword parameter "borders=" 
         which is fed the values of the second array "bb".  The third 
         is a keyword parameter "columns=" which is fed the values of
         the third array "cc".  

  History
    7/15/05 changed %str(&VAL) to %quote(&VAL).          
    4/1/06 added KEYWORD parameter
    4/9/06 declared "_Intrnl" array variables local to remove problems
            with nesting with VALUES=.
    8/4/06 made lines 72 characters or less to be mainframe compatible
*/

%LOCAL 
  _IntrnlN
  _Intrnl1  _Intrnl2  _Intrnl3  _Intrnl4  _Intrnl5  
  _Intrnl6  _Intrnl7  _Intrnl8  _Intrnl9  _Intrnl10
  _Intrnl11 _Intrnl12 _Intrnl13 _Intrnl14 _Intrnl15 
  _Intrnl16 _Intrnl17 _Intrnl18 _Intrnl19 _Intrnl20
  _Intrnl21 _Intrnl22 _Intrnl23 _Intrnl24 _Intrnl25
  _Intrnl26 _Intrnl27 _Intrnl28 _Intrnl29 _Intrnl30
  _Intrnl31 _Intrnl32 _Intrnl33 _Intrnl34 _Intrnl35
  _Intrnl36 _Intrnl37 _Intrnl38 _Intrnl39 _Intrnl40
  _Intrnl41 _Intrnl42 _Intrnl43 _Intrnl44 _Intrnl45
  _Intrnl46 _Intrnl47 _Intrnl48 _Intrnl49 _Intrnl50
  _Intrnl51 _Intrnl52 _Intrnl53 _Intrnl54 _Intrnl55
  _Intrnl56 _Intrnl57 _Intrnl58 _Intrnl59 _Intrnl60
  _Intrnl61 _Intrnl62 _Intrnl63 _Intrnl64 _Intrnl65
  _Intrnl66 _Intrnl67 _Intrnl68 _Intrnl69 _Intrnl70
  _Intrnl71 _Intrnl72 _Intrnl73 _Intrnl74 _Intrnl75
  _Intrnl76 _Intrnl77 _Intrnl78 _Intrnl79 _Intrnl80
  _Intrnl81 _Intrnl82 _Intrnl83 _Intrnl84 _Intrnl85
  _Intrnl86 _Intrnl87 _Intrnl88 _Intrnl89 _Intrnl90
  _Intrnl91 _Intrnl92 _Intrnl93 _Intrnl94 _Intrnl95
  _Intrnl96 _Intrnl97 _Intrnl98 _Intrnl99 _Intrnl100
 _KEYWRDN _KEYWRD1 _KEYWRD2 _KEYWRD3 _KEYWRD4 _KEYWRD5 
 _KEYWRD6 _KEYWRD7 _KEYWRD8 _KEYWRD9
 _KWRDI
 ARRAYNOTFOUND CRC CURRPREFIX DELIMI DID FRC I ITER J KWRDINDEX MANUM
 PREFIXES PREFIXN PREFIX1 PREFIX2 PREFIX3 PREFIX4 PREFIX5 
 PREFIX6 PREFIX7 PREFIX8 PREFIX9
 SOMETHINGTODO TP VAL VALUESGIVEN
 ;

%let somethingtodo=Y;

%* Get macro array name(s) from either keyword or positional parameter;
%if       %str(&arraypos) ne %then %let prefixes=&arraypos;
%else %if %str(&array)    ne %then %let prefixes=&array;
%else %if %quote(&values) ne %then %let prefixes=_Intrnl;
%else %let Somethingtodo=N;

%if &somethingtodo=Y %then
%do;

%* Parse the macro array names;
%let PREFIXN=0;
%do MAnum = 1 %to 999; 
 %let prefix&MANUM=%scan(&prefixes,&MAnum,' ');
 %if &&prefix&MAnum ne %then %let PREFIXN=&MAnum;
 %else %goto out1;
%end; 
%out1:

%* Parse the keywords;
%let _KEYWRDN=0;
%do _KWRDI = 1 %to 999; 
 %let _KEYWRD&_KWRDI=%scan(&KEYWORD,&_KWRDI,' ');
 %if &&_KEYWRD&_KWRDI ne %then %let _KEYWRDN=&_KWRDI;
 %else %goto out2;
%end; 
%out2:

%* Load the VALUES into macro array 1 (only one is permitted);
%if %length(%str(&VALUES)) >0 %then %let VALUESGIVEN=1;
%else %let VALUESGIVEN=0;
%if &VALUESGIVEN=1 %THEN 
%do;
         %* Check for numbered list of form xxx-xxx and expand it 
            using NUMLIST macro.;
         %IF (%INDEX(%STR(&VALUES),-) GT 0) and 
             (%SCAN(%str(&VALUES),2,-) NE ) and 
             (%SCAN(%str(&VALUES),3,-) EQ ) 
           %THEN %LET VALUES=%NUMLIST(&VALUES);

%do iter=1 %TO 9999;  
  %let val=%scan(%str(&VALUES),&iter,%str(&DELIM));
  %if %quote(&VAL) ne %then
    %do;
      %let &PREFIX1&ITER=&VAL;
      %let &PREFIX1.N=&ITER;
    %end;
  %else %goto out3;
%end; 
%out3:
%end;

%let ArrayNotFound=0;
%do j=1 %to &PREFIXN;
  %*put prefix &j is &&prefix&j;
  %LET did=%sysfunc(open(sashelp.vmacro 
                    (where=(name eq "%upcase(&&PREFIX&J..N)")) ));
  %LET frc=%sysfunc(fetchobs(&did,1));
  %LET crc=%sysfunc(close(&did));
  %IF &FRC ne 0 %then 
    %do;
       %PUT Macro Array with Prefix &&PREFIX&J does not exist;
       %let ArrayNotFound=1;
    %end;
%end; 

%if &ArrayNotFound=0 %then %do;

%if %quote(%upcase(&BETWEEN))=COMMA %then %let BETWEEN=%str(,);

%if %length(%str(&MACRO)) ne 0 %then 
  %do;
     %let TP = %nrstr(%&MACRO)(;
     %do J=1 %to &PREFIXN;
         %let currprefix=&&prefix&J;
         %IF &J>1 %then %let TP=&TP%str(,);
            %* Write out macro keywords followed by equals. 
               If fewer keywords than macro arrays, assume parameter 
               is positional and do not write keyword=;
            %let kwrdindex=%eval(&_KEYWRDN-&PREFIXN+&J);
            %IF &KWRDINDEX>0 %then %let TP=&TP&&_KEYWRD&KWRDINDEX=;
         %LET TP=&TP%nrstr(&&)&currprefix%nrstr(&I);
     %END;
     %let TP=&TP);  %* close parenthesis on external macro call;
  %end; 
%else
  %do;
     %let TP=&PHRASE;
     %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE._I_,%nrstr(&I.)));
     %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE._i_,%nrstr(&I.)));
     %do J=1 %to &PREFIXN;
         %let currprefix=&&prefix&J;
         %LET TP = %qsysfunc(tranwrd(&TP,&ESCAPE&currprefix,
                                 %nrstr(&&)&currprefix%nrstr(&I..))); 
         %if &PREFIXN=1 %then %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE,
                                 %nrstr(&&)&currprefix%nrstr(&I..)));
     %end;
  %end;

%* resolve TP (the translated phrase) and perform the looping;
%do I=1 %to &&&prefix1.n;
%if &I>1 and %length(%str(&between))>0 %then &BETWEEN;
%unquote(&TP)
%end;  

%end;
%end;

%MEND;

                                                                                                                        
                                




%MACRO ARRAY(arraypos, array=, data=, var=, values=,
                       delim=%STR( ), debug=N, numlist=Y);

 /* last modified 8/4/2006                    a.k.a. MACARRAY( ).  
                                                           72nd col -->|
 Function: Define one or more Macro Arrays
     This macro creates one or more macro arrays, and stores in them 
     character values from a SAS dataset or view, or an explicit list 
     of values.

     A macro array is a list of macro variables sharing the same prefix
     and a numerical suffix.  The suffix numbers run from 1 up to a 
     highest number.  The value of this highest number, or the length 
     of the array, is stored in an additional macro variable with the 
     same prefix, plus the letter “N”.  The prefix is also referred to
     as the name of the macro array. For example, "AA1", "AA2", "AA3", 
     etc., plus "AAN".  All such variables are declared GLOBAL.

 Authors: Ted Clay, M.S.   tclay@ashlandhome.net  (541) 482-6435
          David Katz, M.S. www.davidkatzconsulting.com
      "Please keep, use and pass on the ARRAY and DO_OVER macros with
          this authorship note.  -Thanks "

 Full documentation with examples appears in SUGI Proceedings, 2006, 
     "Tight Looping With Macro Arrays" by Ted Clay
 Please send improvements, fixes or comments to Ted Clay.

 Parameters: 
    ARRAYPOS and 
    ARRAY are equivalent parameters.  One or the other, but not both, 
             is required.  ARRAYPOS is the only position parameter. 
           = Identifier(s) for the macro array(s) to be defined. 
    DATA = Dataset containing values to load into the array(s).  Can be
              a view, and dataset options such as WHERE= are OK.
    VAR  = Variable(s) containing values to put in list. If multiple 
              array names are specified in ARRAYPOS or ARRAY then the 
              same number of variables must be listed.  
    VALUES  = An explicit list of character strings to put in the list 
              or lists.  If present, VALUES are used rather than DATA 
              and VAR.  VALUES can be a numbered list, eg 1-10, a01-A20, 
              a feature which can be turned of with NUMLIST=N.
              The VALUES can be used with one or more array names 
              specified in the ARRAYPOS or ARRAY parameters.  If more 
              than one array name is given, the values are assigned to
              each array in turn.  For example, if arrays AA and BB 
              are being assigned values, the values are assigned to 
              AA1, BB1, AA2, BB2, AA3, BB3, etc.  Therefore the number
              of values must be a multiple of the number of arrays. 

    DELIM = Character used to separate values in VALUES parameter.  
              Blank is default.

    DEBUG = N/Y. Default=N.  If Y, debugging statements are activated.

    NUMLIST = Y/N.  Default=Y.  If Y, VALUES may be a number list.

 REQUIRED OTHER MACRO: Requires NUMLIST if using numbered lists are used
              in the VALUES parameter.

 How the program works.
    When the VALUES parameter is used, it is parsed into individual 
    words using the scan function. With the DATA parameter, each 
    observation of data to be loaded into one or more macro
    arrays, _n_ determines the numeric suffix.  Each one is declared
    GLOBAL using "call execute" which is acted upon by the SAS macro 
    processor immediately. (Without this "global" setting, "Call symput" 
    would by default put the new macro variables in the local symbol 
    table, which would not be accessible outside this macro.)  Because 
    "call execute" only is handling macro statements, the following 
    statement will normally appear on the SAS log: "NOTE: CALL EXECUTE 
    routine executed successfully, but no SAS statements were generated."

 History
  7/14/05 handle char variable value containing single quote
  1/19/06 VALUES can be a a numbered list with dash, e.g. AA1-AA20 
  4/1/06 simplified process of making variables global.
  4/12/06 allow VALUES= when creating more than one macro array.

    */

%LOCAL prefixes PREFIXN manum _VAR_N iter i J val VAR WHICH MINLENG
   PREFIX1 PREFIX2 PREFIX3 PREFIX4 PREFIX5 PREFIX6 PREFIX7 PREFIX8 
   PREFIX9 PREFIX10 PREFIX11
   var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 ;

%* Get array names from either the keyword or positional parameter;
%if &ARRAY= %then %let PREFIXES=&ARRAYPOS;
%else %let PREFIXES=&ARRAY;

%* Parse the list of macro array names;
%do MANUM = 1 %to 999; 
 %let prefix&MANUM=%scan(&prefixes,&MAnum,' ');
 %if &&prefix&MANUM ne %then 
   %DO;
    %let PREFIXN=&MAnum;
    %global &&prefix&MANUM..N;
    %* initialize length to zero;
    %let &&prefix&MANUM..N=0;
   %END;
  %else %goto out1;
%end; 
%out1:

%if &DEBUG=Y %then %put PREFIXN is &PREFIXN;

%* Parse the VAR parameter;
%let _VAR_N=0;
%do MANUM = 1 %to 999; 
 %let _var_&MANUM=%scan(&VAR,&MAnum,' ');
 %if %str(&&_var_&MANUM) ne %then %let _VAR_N=&MAnum;
 %else %goto out2;
%end; 
%out2:

%IF &PREFIXN=0 %THEN 
    %PUT ERROR: No macro array names are given;
%ELSE %IF %LENGTH(%STR(&DATA)) >0 and &_VAR_N=0 %THEN
    %PUT ERROR: DATA parameter is used but VAR parameter is blank;
%ELSE %IF %LENGTH(%STR(&DATA)) >0 and &_VAR_N ne &PREFIXN %THEN
    %PUT ERROR: The number of variables in the VAR parameter is not 
 equal to the number of arrays;
%ELSE %DO;

%*------------------------------------------------------;
%*  CASE 1: VALUES parameter is used
%*------------------------------------------------------;

%IF %LENGTH(%STR(&VALUES)) >0 %THEN 
%DO;
     %IF &NUMLIST=Y %then
     %DO;
         %* Check for numbered list of form xxx-xxx and expand it using
             the NUMLIST macro.;
         %IF (%INDEX(%quote(&VALUES),-) GT 0) and 
             (%length(%SCAN(%quote(&VALUES),1,-))>0) and 
             (%length(%SCAN(%quote(&VALUES),2,-))>0) and 
             (%length(%SCAN(%quote(&VALUES),3,-))=0) 
           %THEN %LET VALUES=%NUMLIST(&VALUES);
     %END;

%LET MINLENG=99999;
%DO J=1 %TO &PREFIXN;
%DO ITER=1 %TO 9999;  
  %LET WHICH=%EVAL((&ITER-1)*&PREFIXN +&J); 
  %LET VAL=%SCAN(%STR(&VALUES),&WHICH,%STR(&DELIM));
  %IF %QUOTE(&VAL) NE %THEN
    %DO;
      %GLOBAL &&&&PREFIX&J..&ITER;
      %LET &&&&PREFIX&J..&ITER=&VAL;
      %LET &&&&PREFIX&J..N=&ITER;
    %END;
  %ELSE %goto out3;
%END; 
%out3: %IF &&&&&&PREFIX&J..N LT &MINLENG
          %THEN %LET MINLENG=&&&&&&PREFIX&J..N;
%END;

%if &PREFIXN >1 %THEN 
%DO J=1 %TO &PREFIXN;
    %IF &&&&&&PREFIX&J..N NE &MINLENG %THEN 
%PUT ERROR: Number of values must be a multiple of the number of arrays;
%END;

%END;
%ELSE %DO;

%*------------------------------------------------------;
%*  CASE 2: DATA and VAR parameters used
%*------------------------------------------------------;

%* Get values from one or more variables in a dataset or view;
  data _null_;
  set &DATA end = lastobs;
%DO J=1 %to &PREFIXN; 
  call execute('%GLOBAL '||"&&PREFIX&J.."||left(put(_n_,5.)) );
  call symput(compress("&&prefix&J"||left(put(_n_,5.))), 
              trim(left(&&_VAR_&J)));
  if lastobs then 
   call symput(compress("&&prefix&J"||"N"), trim(left(put(_n_,5.))));
%END;
  run ;

%* Write message to the log;
%IF &DEBUG=Y %then
%DO J=1 %to &PREFIXN;
 %PUT &&&&PREFIX&J..N is &&&&&&PREFIX&J..N;
%END;

%END;
%END;

%MEND;





%MACRO NUMLIST(listwithdash); 
  /* 
                                                           72nd col -->|
    Function: Generate the elements of a numbered list.

              For example, AA1-AA3 generates AA1 AA2 AA3
              No prefix is necessary -- 1-3 generates 1 2 3.

      Author: Ted Clay, M.S.
            Clay Software & Statistics
            tclay@ashlandhome.net  (541) 482-6435
      "Please keep, use and share this macro with this authorship note."

   Parameter: 
       ListWithDash -- text string containing a dash.  
           The text before the dash, and the text after the dash, 
           usually begin with a the same character string, called the
           stem.  (The stem could be blank or null, as is the case of 
           number-dash-number.) After the common stem must be two 
           numbers.  The first number must be less than the second 
           number.  Leading zeroes on the numbers are preserved.

  How it works: The listwithdash is parsed into _before and _after.
         _before and _after are compared equal up to the length of the
         "stem".  What is after the "stem" is assigned to _From and _to,
         which must convert to numerics. Finally, the macro generates 
         stem followed by all the numbers from _from through _to

  Examples:
     %numlist(3-6) generates 3 4 5 6.
     %numlist(1993-2004) generates 1993 1994 1995 1996 1997 1998 1999
                                   2000 2001 2002 2003 2004.
     %numlist(var8-var12) generates var8 var9 var10 var11 var12.
     %numlist(var08-var12) generates var08 var09 var10 var11 var12.

  */

%local _before _after _length1 _length2 minlength samepos _pos 
       _from _to i;

  %let _before = %scan(%quote(&listwithdash),1,-);
  %let _after  = %scan(%quote(&listwithdash),2,-);
  %let _length1 = %length(%quote(&_before));
  %let _length2 = %length(%quote(&_after));
  %let minlength=&_length1;
  %if &_length2 < &minlength %then %let minlength=&_length2;

%*put before is &_before;
%*put after is &_after;
%*put minlength is &minlength;
  %* Stemlength should be just before the first number or the first 
      unequal character;
  %let stemlength=0;
  %let foundit=0;
  %do _pos = 1 %to &minlength;
    %LET CHAR1=%upcase(%substr(%quote(&_before),&_pos,1));
    %LET CHAR2=%upcase(%substr(%quote(&_after ),&_pos,1));
    %if %index(1234567890,%QUOTE(&CHAR1)) GE 1 %then %let ISANUMBER=Y;
    %else %let isanumber=N;

    %if &foundit=0 and 
         ( &isanumber=Y OR %quote(&CHAR1) NE %QUOTE(&CHAR2) )
         %then %do;
             %let stemlength=%EVAL(&_pos-1);
             %*put   after assignment stemlength is &stemlength;
             %let foundit=1;
          %end;
  %end; 

  %if &stemlength=0 %then %let stem=;
  %else %let stem = %substr(&_before,1,&stemlength);

  %let _from=%substr(&_before,%eval(&stemlength+1));
  %let _to  =%substr(&_after, %eval(&stemlength+1));

%IF %verify(&_FROM,1234567890)>0 or
    %verify(&_TO  ,1234567890)>0 %then 
  %PUT ERROR in NUMLIST macro: Alphabetic prefixes are different;
 
%else %if &_from <= &_to %then
%do _III_=&_from %to &_to;
    %LET _XXX_=&_iii_;
    %do _JJJ_=%length(&_iii_) %to %eval(%length(&_from)-1);
        %let _XXX_=0&_XXX_;
    %end;
%TRIM(&stem&_XXX_)
%end; 
%else %PUT ERROR in NUMLIST macro: From "&_from" not <= To "&_to";

%MEND; 





%macro verify(text,target);
%*********************************************************************;
%*                                                                   *;
%*  MACRO: VERIFY                                                    *;
%*                                                                   *;
%*  USAGE: 1) %verify(argument,target)                               *;
%*                                                                   *;
%*  DESCRIPTION:                                                     *;
%*    This macro returns the position of the first character in the  *;
%*    argument that is not in the target value. If every character   *;
%*    that is in the argument is also in the target value then this  *;
%*    fuction returns a value of 0. The syntax for its use is        *;
%*    is similar to that of native macro functions.                  *;
%*                                                                   *;
%*    Eg. %let i=%verify(&argtext,&targtext)                         *;
%*                                                                   *;
%*  SUPPORT: sassmo                                                  *;
%*  NOTES:                                                           *;
%*    Both values to this function must have non-zero lengths or an  *;
%*    error message will be produced.                                *;
%*                                                                   *;
%*********************************************************************;
%local i;
%if %length(&text)=0 OR %length(&target)=0 %then %do;
  %put ERROR: ARGUMENT TO VERIFY FUNCTION MISSING.;

  %goto errout;
%end;
%do i=1 %to %length(&text);
  %if NOT %index(&target,%qsubstr(&text,&i,1)) %then %goto verfnd;
%end;
%verfnd: %if &i>%length(&text) %then 0;
           %else &i;
%errout:
%mend;












/************************************************************
         Name: VarList.sas
         Type: Macro function
  Description: Returns variable list from table
   Parameters:
           Data       - Name of table <libname.>memname
           Keep=      - variables to keep
           Drop=      - variables to drop
           Qstyle=    - Quote style:
                          ORACLE is like "Name" "Sex" "Weight"...
                          SAS is like 'Name'n 'Sex'n 'Weight'n...
                          Anything else is like Name Sex Weight...
           Od=%str( ) - Output delimiter
           prx=       - PRX expression
       Notes: An error provokes %ABORT CANCEL
    Examples:
           %put %varlist(sashelp.class,keep=_numeric_);
           %put %varlist(sashelp.class,qstyle=sas);
           %put %varlist(sashelp.class,qstyle=Oracle,od=%str(,));
           %put %varlist(sashelp.class,prx=/ei/i);
           %put %varlist(sashelp.class,prx=funky error); %* provokes error;
 
   Author: Søren Lassen, s.lassen@post.tele.dk
 **************************************************************/
 %macro varlist(data,keep=,drop=,qstyle=,od=%str( ),prx=);
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
         %else %if ORACLE=&qstyle %then
           %do;&od2.%qsysfunc(quote(&w))%end;
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
 
%mend;



%macro par / cmd;                                             
   store;note;notesubmit '%para;';                            
   run;                                                       
%mend par;                                                    
                                                              
%macro para;                                                  
     filename clp clipbrd ;                                   
     data _null_;                                             
       infile clp end=dne;                                    
       input;                                                 
       putlog _infile_;                                       
       string=_infile_;                                       
       do until (status=9);                                   
          link scan;                                          
       end;                                                   
       string = translate(string,'  ()','()'||"FAFB"x);       
       put string=;                                           
RETURN;                                                       
SCAN:                                                         
    do i=1 to length(string);                                 
       status = 9;                                            
       if substr(string,i,1) = '(' then p = i;                
       if substr(string,i,1) = ')' and p>0                    
          then do;                                            
          substr(string,p,1) = 'FA'x;                         
          substr(string,i,1) = 'FB'x;                         
          p=0;                                                
          status=0;                                           
          leave;                                              
       end;                                                   
    end;                                                      
RETURN;                                                       
RUN;                                                          
%mend para;                                                   

 



