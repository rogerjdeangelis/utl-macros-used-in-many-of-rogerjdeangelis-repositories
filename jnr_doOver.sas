%macro jnr_doOver(vars,code=,between=);

  %global prg;

/*
  %let vars=a1 a2 a3 b1 b2 b3;
  %let code=%str(put ?=;);
  %let between=;
*/

  %local quoteIt;
  %let quoteit=;

  %let quoteIt="%qsysfunc(tranwrd(&vars, %str( ) , %str(",")))";
  %let cnt=%qsysfunc(countw(&vars));
  %put &=cnt;

  %dosubl('
  %put quoteit &quoteit;
  data _null_;
   length prg $32756;
   code="&code";
   array pfx[&cnt] $32 (&quoteIt) ;
   do i=1 to dim(pfx);
    %if &between= %then %do;
      prg=cats(prg,tranwrd(code,"?",pfx[i]));
    %end;
    %else %do;
      prg=catx(&between,prg,tranwrd(code,"?",pfx[i]));
    %end;
   end;
   putlog prg=;
   call symputx("prg",prg,"G");
   run;
  ');


%sysfunc(dequote("&prg"))

%mend jnr_doOver;
