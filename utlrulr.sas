  %macro utlrulr
      (
       utitle=ASCII Flatfile Ruler & Hex,
       uobj  =utlrulr,
       uinflt =c:\dat\delete.dat,
       /*--------------------------------*\
       | Control                          |
       \*--------------------------------*/
       uprnlen =70,  /* Linesize for Dump */
       ulrecl  =32760,  /* maximum record length */
       urecfm   =,
       uobs = 3,        /* number of obs to dump */
       uchrtyp =ascii,  /* ascii or ebcdic */
       /*--------------------------------*\
       | Outputs                          |
       \*--------------------------------*/
       uotflt =c:\dat\delete.hex
      ) / des = "ASCII Flatfile Ruler & Hex Chars";
    /*----------------------------------------------*\
    |  Code by Roger DeAngelis                       |
    |  Compucraft Inc                                |
    |  Email deangel@horizsys.com                    |
    |        xlr82sas@aol.com                        |
    |  Users are free to do whatever they want       |
    |  with any or all of this code.                 |
    |  Compucraft is not responsible for any         |
    |  problems associated with this code.           |
    |  Use at your own risk                          |
    \*----------------------------------------------*/
    /*----------------------------------------------*\
    | Description:                                   |
    |  This code does a hex dump of a flatfile       |
    |  IPO                                           |
    |  ===                                           |
    |   INPUTS    UINFLT                             |
    |   ======                                       |
    |   A flatfile like                              |
    |    A2  NC 199607 JAN96   37   16    43  12     |
    |    A1  SC 199601 JAN91   17   26    45  32     |
    |    A2  ND 199602 JAN92   32   36    46         |
    |    A3  VT 199603 JAN93   47   54    47  35     |
    |    A4  NY 199604 JAN94   35   55    48  62     |
    |    A5  CA 199605 JAN95   57   56    49         |
    |    A6  NC 199606 JAN96   36   57    89  39     |
    |                                                |
    |   PROCESS                                      |
    |   =======                                      |
    |    Create a ruler line for each                |
    |    record. Echo the ASCII text.                |
    |    Print two lines with the hex                |
    |    representation.                             |
    |                                                |
    |   OUTPUT   UOTFLT    hex dump                  |
    |   ======                                       |
    |   Sample output                                |
    |    --- Record Number ---- 1                    |
    |    --- Record Length ---- 50                   |
    |                                                |
    |   A2  NC 199607 JAN96   37                     |
    |   1...5....10...15...20...2                    |
    |   4322442333333244433222332                    |
    |   1200E301996070A1E96000370                    |
    |                                                |
    |     16    43  12        567                    |
    |   5...30...35...40...45...5                    |
    |   2233222233223322222222333                    |
    |   0016000043001200000000567                    |
    |                                                |
    |    --- Record Number ---  2                    |
    |    --- Record Length ---- 39                   |
    |                                                |
    |   A1  SC 199601 JAN91   17                     |
    |   1...5....10...15...20...2                    |
    |   4322542333333244433222332                    |
    |   11003301996010A1E91000170                    |
    |     26    45  32                               |
    |   5...30...35...                               |
    |   22332222332233                               |
    |   00260000450032                               |
    |   Limitations                                  |
    |   1. Only handles records up to 1000 bytes     |
    |   2. Is very slow                              |
    \*----------------------------------------------*/
    /*--------------------------------------------------------------*\
    |  TESTCASE                                                      |
    |   data _null_;                                                 |
    |      file "c:\utl\delete.tst";                                 |
    |      put "A2  NC 199607 JAN96   37   16    43  12        567"; |
    |      put "A1  SC 199601 JAN91   17   26    45  32";            |
    |      put "A2  ND 199602 JAN92   32   36    46  42";            |
    |      put "A3  VT 199603 JAN93   47   54    47  35";            |
    |      put "A4  NY 199604 JAN94   35   55    48  62        789"; |
    |      put "A5  CA 199605 JAN95   57   56    49  72";            |
    |      put "A6  NC 199606 JAN96   36   57    89  39";            |
    |   run;                                                         |
    |   %utlrulr                                                     |
    |      (                                                         |
    |       uprnlen=25,                                              |
    |       uobs=3,                                                  |
    |       uinflt=c:\utl\delete.tst,                                |
    |       uotflt=c:\utl\delete.hex                                 |
    |      );                                                        |
    \*--------------------------------------------------------------*/
     options ls=80 ps=63;run;
     title1 "&utitle.";
     title2 "&uobj.";
     title3 "&uinflt.";
     title4 "&uotflt.";
     data _null_; file "&uotflt" print; put; run;
     title1;
       data _NULL_;
          length col $5. out $1;
          array uchr{1000} $1  u1-u1000;
          array urul{1000} $1  r1-r1000;
          infile "&uinflt" missover end=done length=ln lrecl=&ulrecl ignoredoseof
          %if "&urecfm"  ne  "" %then %str( recfm=&urecfm );
          ;
          file   "&uotflt" mod;
          input (uchr{*}) ( $char1.);
          recnum + 1;
          put #1 @;
          put #2 @;
          put #3 @uk ' --- Record Number ---  ' recnum '  ---  Record Length ---- ' ln  @;
          put #4 @;
          /*--------------------------------*\
          | Build the Ruler                  |
          \*--------------------------------*/
          urul{1}='1';
          urul{2}='.';
          urul{3}='.';
          urul{4}='.';
          do ui = 5 to 995 by 5;
             col  = compress( put ( ui, 4. ) !!'....' );
             do uj = 1 to 5;
                ul = ui + uj -1;
                urul{ul} = substr( col, uj, 1 );
             end;
          end;
          /*--------------------------------*\
          | Build Character & Hex Dump       |
          \*--------------------------------*/
          do ui = 1 to ln;
             uk+1;
             out = prxchange('s/[\x00-\x19]/./', -1, uchr{ui});
             out = prxchange('s/[\x7F-\xFF]/./', -1, out);
             put #5 @uk out @;
             put #6 @uk urul{ui} $1. @;
             nibble1 = substr( put ( uchr{ui}, $hex2. ), 1, 1 );
             put #7 @uk nibble1 @;
             nibble2 = substr( put ( uchr{ui}, $hex2. ), 2, 1 );
             put #8 @uk nibble2 @;
             if mod( ui, &uprnlen ) eq 0 or  ( ln = ui )  then do;
                put ;
                uk=0;
             end;
          end;
          put ///;
          if recnum eq &uobs then stop;
      run;
   %mend utlrulr;
