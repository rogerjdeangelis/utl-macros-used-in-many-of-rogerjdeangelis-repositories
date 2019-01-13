%Macro UtlSumOf
        (
         Utl_Title=Column and Row Sum Reductions for Two Dimensional Arrays,

         /*--------------------------*\
         | Inputs                     |
         \*--------------------------*/

         Utl_Mat,   /* Datastep Matrix */
         Utl_Rows,  /* Range or Single row ie 2:5, 1:10, 4 */
         Utl_Cols   /* Range or Single row ie 2:5, 1:10, 4 */

         /*--------------------------*\
         | Output the Text            |
         | Output Sum of ( Mat(1,1)   |
         |                 Mat(1,2) ) |
         \*--------------------------*/

        ) / Des="Column and Row Sum Reductions for Two Dimensional Arrays";


/*---------------------------------------------*\
|                                               |
|  You have the following Array Statement       |
|                                               |
|  Example :                                    |
|                                               |
|  Array Mat{2,3} ( 1 2 3                       |
|                   4 5 6 );                    |
|                                               |
|  And you want the Row, Column and Grand Totals|
|                                               |
|  Data _Null_;                                 |
|                                               |
|  Array Mat{2,3} ( 1 2 3                       |
|                   2 3 6 );                    |
|                                               |
|  ColSum1= %UtlSumOf ( Mat,1:2,1);             |
|  ColSum2= %UtlSumOf ( Mat,1:2,2);             |
|  ColSum3= %UtlSumOf ( Mat,1:2,3);             |
|                                               |
|  RowSum1= %UtlSumOf ( Mat,1,1:3);             |
|  RowSum2= %UtlSumOf ( Mat,2,1:3);             |
|                                               |
|  Total=%UtlSumOf (Mat,1:2,1:3);               |
|                                               |
|                                               |
|  Put                                          |
|      ColSum1=  /                              |
|      ColSum2=  /                              |
|      ColSum3=  /                              |
|                                               |
|      RowSum1=  /                              |
|      RowSum2=   ;                             |
|                                               |
|  Run;                                         |
|                                               |
|  You could use the macro language  to simplify|
|                                               |
|  Array Colsum{3};                             |
|  %Do Col=1 %To 3;                             |
|    ColSum{&Col}= %UtlSumOf ( Mat,1:2,&Col );  |
|  %End;                                        |
|                                               |
\*---------------------------------------------*/



   %Let Pgm=&sysmacroname.;


   %Local
          i
          j
   ;

   %If &Utl_Mat.  = %Str() or
       &Utl_Rows. = %Str() or
       &Utl_Cols. = %Str()
   %Then %Do;

       %Put Eror User Required Parm Missing;

       %put Utl_Mat  =   &Utl_Mat.  ;
       %put Utl_Rows =   &Utl_Rows. ;
       %put Utl_Cols =   &Utl_Cols. ;

       %goto exit;

   %end;

 %If %index(&Utl_Rows.,%str(:)) Ne 0 %Then %Do;
   %Let Utl_Row1st=%qscan(&Utl_Rows.,1,%str(:));
   %Let Utl_RowLst=%qscan(&Utl_Rows.,2,%str(:));
 %end;
 %Else %Do;
   %Let Utl_Row1st=&Utl_Rows.;
   %Let Utl_RowLst=&Utl_Rows.;
 %End;


 %If %index(&Utl_Cols.,%str(:)) Ne 0 %Then %Do;
   %Let Utl_Col1st=%qscan(&Utl_Cols.,1,%str(:));
   %Let Utl_ColLst=%qscan(&Utl_Cols.,2,%str(:));
 %end;
 %Else %Do;
   %Let Utl_Col1st=&Utl_Cols.;
   %Let Utl_ColLst=&Utl_Cols.;
 %End;

   sum ( of

   %do i = &Utl_Row1st. %to &Utl_RowLst.;

     %do j=&Utl_Col1st. %to &Utl_ColLst.;

       &Utl_Mat.(&i.,&j.)

     %end;

   %end;
        )

%Exit:

%mend UtlSumOf;



Data _Null_;

Array Mat{2,3} ( 1 2 3
                 2 3 6 );

ColSum1= %UtlSumOf ( Mat,1:2,1);
ColSum2= %UtlSumOf ( Mat,1:2,2);
ColSum3= %UtlSumOf ( Mat,1:2,3);

RowSum1= %UtlSumOf ( Mat,1,1:3);
RowSum2= %UtlSumOf ( Mat,2,1:3);

Total=%UtlSumOf (Mat,1:2,1:3);


Put
    ColSum1=  /
    ColSum2=  /
    ColSum3=  //

    RowSum1=  /
    RowSum2=  //

    Total=;

Run;
