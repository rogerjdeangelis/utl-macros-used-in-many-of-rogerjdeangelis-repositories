%macro utl_gettitle
   (Number=_ALL_  /*Number 1-10, _ALL_, or space delimited list of numbers*/
   ,type=T        /*T for titles, F for footnote*/
   ,dlm=|         /*delimiter for list of titles*/
   );

   %local where dsid rc ldlm titletext ;

   %let where=Type="&Type" ;
   %if %upcase(&Number) ne _ALL_ %then %do ;
      %let where=&where and Number IN (&Number)  ;
   %end ;

   %let dsid = %sysfunc ( open ( sashelp.vtitle(where=(&where)) ) ) ;

   %if &dsid > 0 %then %do ;
      %do %until ( &rc ^= 0 ) ;
         %let rc = %sysfunc ( fetch ( &dsid ) ) ;
         %if &rc=0 %then %do ;
            %let TitleText =&TitleText&ldlm%sysfunc ( getvarc ( &dsid , 3 ) ) ;
            %let ldlm=&dlm ;
         %end ;
      %end ;
      %let dsid = %sysfunc(close ( &dsid ) ) ;
   %end ;
   %else %put ER%str()ROR: (%nrstr(%%)&sysmacroname) could not open sashelp.vtitle ;

&TitleText /*return*/
%mend utl_gettitle ;

%put "Titles from Quentins macro" %utl_gettitle ;