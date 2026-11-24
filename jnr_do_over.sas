%macro jnr_do_over(
    arrayName=nams vals
   ,code=%str(x="?";y="#";output;)
   ,between=','
   )/des="Dynamic code iterating over macro code fragments";

   %if %sysfunc(countw(&arrayName))=2 %then %do;
      %let arraynamea=%scan(&arrayname,1);
      %let arraynameb=%scan(&arrayname,2);
   %end;
   %else %do;
      %let arraynamea=%scan(&arrayname,1);
      %let arraynameb=%scan(&arrayname,1);
   %end;

   %let rc=%sysfunc(dosubl(
     data work._null_ %str(;)
        length codex $32756 %str(;)
        codex='' %str(;)
        do i=1 to &&&arraynamea.n %str(;)
          code=tranwrd("&code","?",symget(cats("&arraynamea",i))) %str(;)
          code=tranwrd(code,"#",symget(cats("&arraynameb",i))) %str(;)
          codex=cats(codex,code) %str(;)
          if i ne &&&arraynamea.n then codex=cats(codex,&between) %str(;)
     end %str(;)
     call symputx("codex",codex,"G") %str(;)
   run %str(;)
   ));

   &codex

%mend jnr_do_over;
