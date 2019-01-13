%macro Utl_MkeAry
   (
    Utl_Title=Create an Array Statement with Freq counts,

    /*--------------------------*\
    |  Inputs                    |
    \*--------------------------*/

    Utl_InLibRef01=Work,
    Utl_InMem01   =TwoxTwo,

    Utl_InRowVar  =Row,
    Utl_InColVar  =Col,

    /*--------------------------*\
    |  Outputs                   |
    \*--------------------------*/

    Utl_MacRetVar=Utl_MkeAry,

    Utl_Flop=101010101

   ) / Des="Create an Array Statement with Freq counts";

   %Let Pgm=&sysmacroname.;


   %If &Utl_InLibRef01 = %Str() or
       &Utl_InMem01    = %Str() or
       &Utl_InRowVar   = %Str() or
       &Utl_InColVar   = %Str()  %Then %Do;

       %Put Eror User Required Parm Missing;

       %put Utl_InLibRef01 =  &Utl_InLibRef01 ;
       %put Utl_InMem01    =  &Utl_InMem01    ;
       %put Utl_InRowVar   =  &Utl_InRowVar   ;
       %put Utl_InColVar   =  &Utl_InColVar   ;

       %goto exit;

   %end;


  /*---------------------------------------------*\
  |                                               |
  |  Put Freq counts into datastep Arrays         |
  |                                               |
  |                                               |
  |  Given                                        |
  |                  Sun Mon Tue                  |
  |         Rover     1   2   3                   |
  |         Fluffy    4   5   6                   |
  |                                               |
  |  You want                                     |
  |                                               |
  |  Macro Variable  Utl_MkeAry                   |
  |                                               |
  |  UtlMkeAry = %Str(                            |
  |      {2,3}                                    |
  |            (                                  |
  |             1   2   3                         |
  |             4   5   6                         |
  |            )                                  |
  |                  );                           |
  |                                               |
  |===============================================|
  |                                               |
  | Example Usage                                 |
  |                                               |
  |                                               |
  |  Data Mat10x8;                                |
  |                                               |
  |    Do Reps=1 To  100;                         |
  |                                               |
  |      Do Row=1 To 10;                          |
  |                                               |
  |        Do Col=1 To 8;                         |
  |                                               |
  |          If Uniform(5731) > .5                |
  |            then output;                       |
  |                                               |
  |        End;                                   |
  |                                               |
  |      End;                                     |
  |                                               |
  |    End;                                       |
  |                                               |
  |  Run;                                         |
  |                                               |
  |                                               |
  | %Utl_MkeAry                                   |
  |   (                                           |
  |    Utl_InLibRef01=Work,                       |
  |    Utl_InMem01   =Mat10x8,                    |
  |                                               |
  |    Utl_InRowVar  =Row,                        |
  |    Utl_InColVar  =Col,                        |
  |                                               |
  |    Utl_MacRetVar=NumLst                       |
  |   );                                          |
  |                                               |
  |                                               |
  | Data RowColSum;                               |
  |                                               |
  |   Array Mat10x8 &NumLst. ;                    |
  |                                               |
  |      Do Row=1 To 10;                          |
  |                                               |
  |       Do Col=1 To 8;                          |
  |                                               |
  |         SumRow+Mat10x8{Row,Col};              |
  |                                               |
  |       End;                                    |
  |                                               |
  |      Put SumRow=;                             |
  |      SumRow=0;                                |
  |                                               |
  |      End;                                     |
  |                                               |
  |   Stop;                                       |
  |                                               |
  | Run;                                          |
  |                                               |
  |                                               |
  \*---------------------------------------------*/

  Ods Exclude All;

  Ods Output Observed=Utl_MkeAry01;

  Proc Corresp Data=&Utl_InLibRef01..&Utl_InMem01
               Observer
               dim=1;

       Table
               &Utl_InRowVar., &Utl_InColVar.;
  Run;

  Ods Select All;

  Proc Print Data=Utl_MkeAry01;
  Run;

  Proc Print Data=Utl_MkeAry01;
  Run;

%Let Cols=%str();
%Let Rows=%Str();

Data _Null_;   /* Get Number of ROws and Columns */

  Set Work.Utl_MkeAry01 Nobs=Mobs;

  Array Cols{*} _Numeric_;

  Call SymPut('Rows',Compress (Put(Mobs-1,9. )));
  Call SymPut('Cols',Compress (Put(Dim(Cols)-1,5.)));

  Stop;

Run;

%Put Rows=&Rows;
%Put Cols=&Cols;

Data _Null_;

  Length MacStr $32700;
  Retain MacStr;

  Set Work.Utl_MkeAry01;

  Array Cols{*} _Numeric_;

  If _n_ =1 Then MacStr ="{&Rows.,&Cols.} ( ";

   Do J= 1 To Dim(Cols)-1;

    MacStr=Trim(MacStr)!!' '!!Compress(Put(Cols{J},9.));

   End;

  If _n_ =&Rows. Then Do;

    MacStr=Trim(MacStr)!!' )';

    Call Symput(%UnQuote(%Bquote('&Utl_MacRetVar.')),Trim(MacStr));

    Stop;

  End;


%Exit:

%Mend Utl_MkeAry;


/*--------------------------*\
|                            |
| Test Example               |
|                            |
|                            |
\*--------------------------*/


/*
Data Mat10x8;

  Do Reps=1 To  100;

    Do Row=1 To 10;

      Do Col=1 To 8;

        If Uniform(5731) > .5
          then output;

      End;

    End;

  End;

Run;

%Utl_MkeAry
  (
   Utl_InLibRef01=Work,
   Utl_InMem01   =Mat10x8,

   Utl_InRowVar  =Row,
   Utl_InColVar  =Col,

   Utl_MacRetVar=NumLst
  );


Data RowColSum;

  Array Mat10x8 &NumLst. ;

     Do Row=1 To 10;

      Do Col=1 To 8;

        SumRow+Mat10x8{Row,Col};

      End;

     Put SumRow=;
     SumRow=0;

     End;

  Stop;

Run;

*/
