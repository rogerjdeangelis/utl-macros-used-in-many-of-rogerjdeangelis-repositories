%macro utl_mytitle;

/*---- cut and pase code below ----*/
title1 "Hello Q";
title2 "How is James Bond today";
title3 "How are You";

options cmplib=work.functions;
proc fcmp outlib=work.functions.mytitle;
function mytitle(ttl$) $2550;
    outargs ttl;
    length ttl trct $2550; /*---- SAS MAX SIZE FOR 10 TITLES        ----*/

    dsid = open ( "sashelp.vtitle" );

   if  dsid > 0 then do ;
      do until ( rc ^= 0 ) ;
         rc = fetch ( dsid )  ;
         if rc=0 then do ;
            ttl = catx('|',ttl, getvarc ( dsid , 3 ));
         end ;
      end ;
      dsid =close ( dsid ) ;
   end ;
   else put "Rstr()ROR: (nrstr()&sysmacroname) could not open sashelp.vtitle" ;

   put ttl=;
return(ttl);

endfunc;
run;quit;

data _null_;
  length title $2550;
  title=mytitle(title);
  put 'FCMP without DOSUBL mytitle(title))' title;
run;quit;

%put 'FCMP without DOSUBL %sysfunc(mytitle(title))' %sysfunc(mytitle(title)) ;

%mend utl_mytitle;