%macro utl_flatfile(lib=,  /* libref of input sas dataset to convert */
   sasdsn=,                /* second-level sas dataset name */
   file=d:/sas/fixinp.sas,             /* name of file to write to  */
   tl=3,                   /* default is to generate a title3 stmt  */
   spaces=1                /* number of spaces separating output fields */
   );
   %local putlist ;
   %let lib=%upcase(&lib);
   %let sasdsn=%upcase(&sasdsn);

   proc sql noprint ;
      select
        case
          when format ^= " " then
               name || " " || format
          when upcase(type) = "CHAR" then
               name || " $char"||trim(left(put(length,3.)))||"."
          else
               name || " best10."
        end  into :putlist separated by " +&spaces "
        from dictionary.columns
        where libname = "&lib" and memname = "&sasdsn"
      ;
      reset print ;
      title&tl "Layout for &lib..&sasdsn to &file" ;
      select name , type ,
        case
          when format ^= " " then trim(format)
          when upcase(type) = "CHAR" then "$"||trim(left(put(length,3.)))||"."
          else "best10."
        end  || " +&spaces " as fmtlen
        from dictionary.columns
        where libname = "&lib" and memname = "&sasdsn"
      ;
      title&tl ;
   quit;

   data _null_;

     set &lib..&sasdsn(obs=1) &lib..&sasdsn end=dne;
     file "&file";
     if _n_=1 then do;
       put "data table;";
       inp=compbl("input &putlist;");
       put inp;
       put "cards4;";
     end;
     else put &putlist;
     if dne then do;
        put ';;;;';
        put 'run;quit;';
     end;
   run;
%mend utl_flatfile;

%utlfkil(d:/sas/inpfix.sas);
                                                                                                           
