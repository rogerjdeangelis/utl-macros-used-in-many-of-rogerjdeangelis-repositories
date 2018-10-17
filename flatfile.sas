%macro flatfile (   /* SUGI 19 */
          data = _LAST_ ,                 /* SAS input data        */
          cntlin = ,                      /* SAS control file      */
          out = ,             /* filename for flat file output     */
          pgm = ,             /* filename for flat file program    */
          report = YES ,        /* YES produce print file report   */
          usefmts = NO ,        /* YES get format from contents    */
          order = ALPHA-NUMERIC ,          /* ALPHA-NUMERIC or POS */
          sep = ,        /* separator: null, ' ' , '09'x, etc.     */
          l2 = 3, l3 = 5, l4 = 8,  /* dflt out len as function of  */
          l5 = 10, l6 = 13, l7 = 15,     /* stored length for VAX  */
          l8 = 19 ,               /* decimal point assumed for l8  */
          vcond = ,               /* variable subsetting condition */
          cond = ,                /* data subsetting condition     */
          tl = 3                  /* available title line number   */
) / des="SUGI Flatfile proram";

   %* ------------------------------------------------------------ *;
   %* FLATFILE -                                                   *;
   %*   Purpose: Create one or more of the following               *;
   %*        Flat file corresponding to SAS data set &data         *;
   %*        Documentation layout for the flat file                *;
   %*        Data step "PUT" program to create the flat file       *;
   %*        Control file __CNTL for controlling another execution *;
   %*                                                              *;
   %*   Side effects:                                              *;
   %*        work data sets __contnt & __cntl may be generated     *;
   %*        title line &tl (when > 0) used and cleared            *;
   %*                                                              *;
   %* Examples:                                                    *;
   %*     %flatfile (out=out)                    report and file   *;
   %*     %flatfile(data=mydat,pgm=pgm)          report & program  *;
   %*     %flatfile(data=mydat,out=out,l3=2,l8=6,usefmts=yes)      *;
   %*     %flatfile (cntlin=mycntl,out=out)      use control file  *;
   %*                                                              *;
   %* Reference: Ian Whitlock RE302 x4347                20mar92   *;
   %* Modified:                           01apr93,       06feb94   *;
   %*                                     19oct94,       06mar95   *;
   %* ------------------------------------------------------------ *;

   /* ------------------------ housekeeping ---------------------- */

   %put NOTE: *** Executing %nrstr(%flatfile) - version 1.4 06MAR95 ;

   %local i tlsep lrecl pgm_file flatout adjlen ;

   %let data = %upcase ( &data ) ;
   %let report = %upcase ( %substr ( &report, 1, 1 ) ) ;
   %let usefmts = %upcase ( %substr ( &usefmts, 1, 1 ) ) ;
   %let order = %upcase ( %substr ( &order, 1, 1 ) ) ;
   %let pgm_file = %length ( &pgm&out ) ;
   %if %length ( &out ) > 0 %then
   %let flatout = &out ;
   %else
   %let flatout = out ;

   %if %length ( &sep ) > 0 %then
   %let adjlen = 2 ;
   %else
   %let adjlen = 1 ;

   %if &data = _LAST_ %then %let data = &syslast ;
   %if %length ( &cntlin ) = 0 %then %goto getcntl ;

   /* -------------------- control file given -------------------- */

   data __cntl ( keep = name outpos outlen outfmt label ) ;
      length outlen $ 3 name $ 8 outfmt __revout $ 15 label $ 40
             outpos 8 ;
      retain __pos 1 __xcl  'ABCDEFGHIJKLMNOPQRSTUVWXYZ$_' ;
      if __eof then
         call symput  ( 'lrecl' , left ( put ( __pos - &adjlen, 5. ) ) ) ;
      set &cntlin end = __eof ;
      %unquote ( &vcond ) ;
      outpos = __pos ;
      __revout = reverse ( upcase ( outfmt ) ) ;
      __x1 = index ( __revout , '.' ) ;
      __x2 = indexc ( __revout , __xcl ) ;
      if __x2 > 0 then
         outlen = reverse ( substr(__revout, __x1 + 1 , __x2 - __x1 - 1 ) ) ;
      else
         outlen = reverse(substr(__revout, __x1 + 1 ) ) ;
      output __cntl ;
      __pos + input ( outlen , 3. )
              %if &sep ^= %then + 1 ;
      ;
   run ;

   %goto results ;

   %getcntl: /* ---------------- use contents -------------------- */

   proc contents
       data = &data noprint
       out = __contnt ( keep = name type length label npos
                               format formatl formatd ) ;
   run ;

   %if "&order" = "P" %then
   %do ;
      proc sort data = __contnt ;
         by npos ;
      run ;
   %end ;

   data __cntl (  keep = name outpos outlen outfmt label npos apos ) ;
      retain outpos 1 ;
      length outlen $ 3 outfmt $ 15 ;
      array __lens ( 0:6 ) _temporary_ ( &l2 &l3 &l4 &l5 &l6 &l7 &l8 ) ;
      if __eof then
      call symput ( 'lrecl' , left ( put ( outpos - &adjlen , 5. ) ) ) ;
      set __contnt end = __eof ;

      %unquote ( &vcond ) ;

      apos + 1 ;
      if type = 2 then
      do ;                        /* ------- character format ------- */
         %if &usefmts = N %then
         %do ;                      /* do not use format info*/
           outlen = put ( length , 3. ) ;
           outfmt = '$char' || trim ( left ( outlen ) ) || '.' ;
         %end ;
         %else
         %do ;                              /* try format info  */
            if format ^= ' ' and formatl ^= 0 then
            do ;                       /* enough format info    */
               outlen = put ( formatl , 3. ) ;
               outfmt = trim ( format ) || trim ( left ( outlen ) ) || '.' ;
            end ;
            else
            do ;                      /* not enough format info */
               outlen = put ( length , 3. ) ;
               outfmt = '$char' || trim ( left ( outlen ) ) || '.' ;
            end ;
         %end ;
      end;                        /* ------- character format ------- */
      else
      do ;                        /* -------- numeric format -------- */
         %if &usefmts = N %then
         %do ;                      /* do not use format info */
            outlen = put ( __lens ( length - 2 ) , 3. ) ;
            outfmt ='best' || trim ( left ( outlen ) ) || '.' ;
         %end ;
         %else
         %do ;                           /* try format info  */
            if format ^= ' ' and formatl ^= 0 then
            do ;                 /* enough format info with name */
               outlen = put ( formatl , 3. ) ;
               outfmt = trim(left(format)) || trim(left(outlen)) || '.' ;
               if formatd ^= 0 then
               outfmt =  trim ( outfmt ) || left ( put ( formatd , 2.) ) ;
            end ;
            else
            if formatl ^= 0 and formatd ^= 0 then
            do ;                 /* enough format info with outname */
               outlen = put ( formatl , 3. ) ;
               outfmt = trim ( left ( outlen ) ) || '.' ||
               left ( put ( formatd , 2. ) ) ;
            end ;
            else
            if formatl ^= 0 then
            do ;                 /* enough format info for best. */
               outlen = put ( formatl , 3. ) ;
               outfmt = 'best' || trim ( left ( outlen ) ) || '.' ;
            end ;
            else
            do ;                      /* not enough format info */
               outlen = put ( __lens ( length - 2 ) , 3. ) ;
               outfmt = 'best' || trim ( left ( outlen ) ) || '.' ;
            end ;
         %end ;
      end ;                       /* -------- numeric format -------- */
      output __cntl ;
      outpos + input ( outlen , 3. )
         %if &sep ^= %then + 1 ;
      ;
   run ;

%results:

   /* ----------------------- documentation ---------------------- */

    %if &report = Y %then
    %do ;
       %if ( &tl ^= ) and ( &tl ^= 0 ) %then
       %do ;
          %if &sep = %then %let tlsep = ;
          %else
          %let tlsep = using separator &sep ;
          title&tl "Flat file layout made from data = &data&tlsep" ;
       %end ;

       proc print data = __cntl ;
          var name outpos outlen outfmt label ;
       run ;

       %if (  &tl ^= ) and ( &tl ^= 0 ) %then %str ( title&tl ; ) ;
    %end ;

   /* ----------------------- write program ---------------------- */

   %if %length ( &pgm ) > 0 %then
   %do ;
     data _null_ ;
        file &pgm ;
        if _n_ = 1 then
        do ;
           __now = today ( ) ;
           put
              "/* flatfile program for &data " __now date7. "  */" /
              "/* written by %nrstr(%flatfile)                 */" //
              "data _null_ ;"                                      /
              "  set &data ;"                                      /
              "  %unquote ( &cond ) ;"                             /
              "  file &flatout lrecl = &lrecl ;"                   /
              "  put"                                              /
           ;
        end ;

        if __eof then
           put
              "  ;"               /
              "run ;"
           ;

        set __cntl end = __eof ;

        %if %length ( &sep ) > 0 %then
        %do ;
          if __eof then
             put
               @5 name $char8.   @14 outfmt $char15.
               @34     '/* ' label $char40. ' */' ;
          else
             put
               @5 name $char8.   @14 outfmt $char15.
               + 1 "&sep"   @36  '/* ' label $char40. ' */' ;
        %end ;
        %else
        %do ;
             put
               @5 name $char8.   @14 outfmt $char15.
               @34     '/* ' label $char40. ' */' ;
        %end ;
     run ;
   %end ;

   /* ----------------------- make flat file --------------------- */

   %if %length ( &out ) > 0  %then
   %do ;
      data _null_ ;
         if _n_ = 1 then call execute
            ( "data _null_;set &data;%unquote(&cond);" ||
              "file &flatout lrecl=&lrecl;put "
            ) ;
         if __eof then call execute ( ';run;' ) ;

         set __cntl end = __eof ;

         %if %length ( &sep ) > 0 %then
         %do ;
            if _n_ = 1 then call execute ( name || ' ' || outfmt ) ;
            else
               call execute ( "&sep " || ' ' || name || ' ' || outfmt ) ;
         %end ;
         %else
            %str ( call execute ( name || '  ' || outfmt ) ; ) ;
      run ;
   %end ;

%mend  flatfile ;
                                                                                                                                          
