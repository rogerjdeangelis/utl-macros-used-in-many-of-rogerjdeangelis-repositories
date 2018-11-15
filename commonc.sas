%macro commonc(var,action=INIT);
 * dosubl sets sysindex to 1;
 * we are in dosubl if sysindex=1;
 * increment sysindex so it is not 1 next time macro called;
 %local varcut varlen;
 %let varcut=%scan(&var,1);
 %let varlen=%scan(&var,2);
 %if %upcase(&action) = INIT %then %do;
    length &var;
    retain &varcut " ";
    call symputx("varadr",put(addrlong(&varcut.),hex16.),"G");
    
 %end;
 %if "%upcase(&action)" = "PUT" %then %do;
    length &var;
    retain &varcut;
    call pokelong(&varcut.,"&varadr."x, &varlen.);
 %end;
 %else %if "%upcase(&action)" = "GET" %then %do;

    retain &varcut " ";
    &varcut = peekclong("&varadr."x,&varlen.);
    %end;
   
%mend commonc;