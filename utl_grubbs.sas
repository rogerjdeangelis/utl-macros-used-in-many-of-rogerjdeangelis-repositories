%macro utl_Grubbs(dsn,var,alpha=.1)                                                                                      
    /des ="Alternating removal of Max and Min Outliers using Grubbs test";                                               
                                                                                                                         
/* output dataset is the input dataset with outlier flag */                                                              
                                                                                                                         
/* for testing without macro                                                                                             
   data shoes;set sashelp.shoes(keep=sales);run;                                                                         
   %let dsn=work.shoes;                                                                                                  
   %let var=sales;                                                                                                       
   %let alpha=.1;                                                                                                        
*/                                                                                                                       
                                                                                                                         
   %local utl_grbnobs;                                                                                                   
                                                                                                                         
   %put %sysfunc(ifc(%sysevalf(%superq(dsn)=,boolean),**** Please Input dataset                   ****,));               
   %put %sysfunc(ifc(%sysevalf(%superq(var)=,boolean),**** Please Input Variable                  ****,));               
                                                                                                                         
   proc means data=&dsn;                                                                                                 
   var &var;                                                                                                             
   output out=__out__ mean=mean std=std max=max min=min n=n;                                                             
   run;                                                                                                                  
   /*------------------------------------------------------------*\                                                      
   |  Add a unique key so that Outliers can be removed            |                                                      
   \*------------------------------------------------------------*/                                                      
    Data  Utl_Grubbs00 / View = Utl_Grubbs00;                                                                            
     Set  &dsn(Keep=&var);                                                                                               
          Utl_GrbKey=_n_;                                                                                                
    Run;                                                                                                                 
   /*------------------------------------------------------------*\                                                      
   |  Sort so that we can trim both ends easily                   |                                                      
   \*------------------------------------------------------------*/                                                      
    Proc Sort Data=Utl_Grubbs00                                                                                          
              Out =Utl_Grubbs01                                                                                          
              Noequals                                                                                                   
              Force;                                                                                                     
    By  &var;                                                                                                            
   run;                                                                                                                  
   /*------------------------------------------------------------*\                                                      
   |  Need to get number of obds and Type and Length for Key      |                                                      
   \*------------------------------------------------------------*/                                                      
   Proc Sql Noprint;                                                                                                     
      Select Put(Nobs,12.)  into :Utl_GrbNobs                                                                            
      From   SASHELP.VTable                                                                                              
      Where  Upcase("WORK")           = Upcase(LibName)   AND                                                            
             Upcase("Utl_Grubbs01")   = Upcase(MemName)   AND                                                            
             Upcase("Data")           = Upcase(MemType);                                                                 
   quit;                                                                                                                 
   run;                                                                                                                  
   /*------------------------------------------------------------*\                                                      
   |  Compute the Grubbs Statistics                               |                                                      
   \*------------------------------------------------------------*/                                                      
   Data                                                                                                                  
         Utl_Grubbs02                                                                                                    
            (                                                                                                            
             Keep=                                                                                                       
                   GrbTest                                                                                               
                   GrbAlpha                                                                                              
                   GrbObs                                                                                                
                   GrbDrop                                                                                               
                   Min_GrbVals                                                                                           
                   Max_GrbVals                                                                                           
                   Mean_GrbVals                                                                                          
                   Std_GrbVals                                                                                           
                   GrbCalc                                                                                               
                   GrbCrit                                                                                               
                   GrbPStat                                                                                              
            );                                                                                                           
                                                                                                                         
     Retain GrbNobs &Utl_GrbNobs GrbAlpha &Alpha;                                                                        
   /*------------------------------------------------------------*\                                                      
   |  Allocate arrays to hold all data                            |                                                      
   \*------------------------------------------------------------*/                                                      
     Array  GrbVals {&Utl_GrbNobs}  _Temporary_;                                                                         
     Array  GrbKeys {&Utl_GrbNobs}  _Temporary_;                                                                         
   /*------------------------------------------------------------*\                                                      
   |  Load all Data into Temp Arrays - Temp Arrays can have       |                                                      
   |  millions of elements?                                       |                                                      
   \*------------------------------------------------------------*/                                                      
     GrbN=0;                                                                                                             
     Do Until ( Done );                                                                                                  
        Set Utl_Grubbs01 End=Done;                                                                                       
        GrbN+1;                                                                                                          
        GrbKeys{GrbN} = Utl_GrbKey;                                                                                      
        GrbVals{GrbN} = &var;                                                                                            
     End;                                                                                                                
     /*------------------------------------------------------------*\                                                    
     | Cannot use more elegant Mean(of Array), Std(Of Array)        |                                                    
     | SAS does not support these funtions on Temporary Arrays      |                                                    
     \*------------------------------------------------------------*/                                                    
     GrbObs=GrbNobs;                                                                                                     
     GrbLo=1;                                                                                                            
     GrbHi=GrbObs;                                                                                                       
     Do  Until ( GrbFlag = 1 )  ;                                                                                        
         GrbFlag=0;                                                                                                      
      Link BasicStats;                                                                                                   
                   *  Pass=GrbLo,GrbHi,Array GrbVals                                                                     
                      Return=Mean,Max,Min,Std;                                                                           
      * Put      "Max Basic Stats ==>  "     /                                                                           
                  GrbObs        =            /                                                                           
                  GrbHi         =            /                                                                           
                  GrbLo         =            /                                                                           
                  Min_GrbVals   =            /                                                                           
                  Max_GrbVals   =            /                                                                           
                  Mean_GrbVals  =            /                                                                           
                  Std_GrbVals   = ;                                                                                      
      /*------------------------------------------------------------*\                                                   
      | Maximum Outlier Case                                         |                                                   
      \*------------------------------------------------------------*/                                                   
      GrbTest='Max';                                                                                                     
      GrbCalc    =( Max_GrbVals - Mean_GrbVals ) / Std_GrbVals ;                                                         
      GrbTStat   =TInv(1-&Alpha/GrbNobs,GrbNobs-2);                                                                      
      Link GrbCompute;                                                                                                   
                       * Pass=GrbCalc,GrbTStat,GrbObs                                                                    
                         Return=GrbCrit GrbStat GrbPStat;                                                                
      * put       // "Max Grubbs Stats ==>  "   /                                                                        
                      GrbCrit=                  /                                                                        
                      GrbStat=                  /                                                                        
                      GrbDenom=                 /                                                                        
                      GrbPStat=;                                                                                         
      If GrbPStat < GrbAlpha Then                                                                                        
          GrbHi = GrbHi - 1;                                                                                             
      Else GrbFlag = GrbFlag + .5;                                                                                       
      * put          //  GrbFlag= //;                                                                                    
      /*------------------------------------------------------------*\                                                   
      | Recompute Basic Stats without Outlier                        |                                                   
      \*------------------------------------------------------------*/                                                   
      Link BasicStats; * (GrbLo,GrbHi);                                                                                  
      *       Put // "Min Basic Stats ==>  " /                                                                           
                  GrbObs        =            /                                                                           
                  GrbObs        =            /                                                                           
                  GrbHi         =            /                                                                           
                  Min_GrbVals   =            /                                                                           
                  Max_GrbVals   =            /                                                                           
                  Mean_GrbVals  =            /                                                                           
                  Std_GrbVals   = ;                                                                                      
      /*------------------------------------------------------------*\                                                   
      | Minimum Outlier Case                                         |                                                   
      \*------------------------------------------------------------*/                                                   
      GrbTest='Min';                                                                                                     
      GrbCalc    =( Mean_GrbVals - Min_GrbVals) / Std_GrbVals ;                                                          
      GrbTStat   =TInv(&alpha/GrbNobs,GrbNobs-2);                                                                        
      Link GrbCompute;                                                                                                   
      * Put       // "Min Grubbs Stats ==>  "  /                                                                         
                        GrbCrit=               /                                                                         
                        GrbStat=               /                                                                         
                        GrbDenom=              /                                                                         
                        GrbPStat=;                                                                                       
      If GrbPStat < GrbAlpha Then                                                                                        
          GrbLo = GrbLo + 1;                                                                                             
      Else GrbFlag = GrbFlag + .5;                                                                                       
      * put          //  GrbFlag= // I=;                                                                                 
  End;                                                                                                                   
  Stop;                                                                                                                  
  ENDIT: Put "Cannot Have missing values for Obsevations";                                                               
  Stop;                                                                                                                  
  /*------------------------------------------------------------*\                                                       
  |  Compute Grubbs Statistics                                   |                                                       
  \*------------------------------------------------------------*/                                                       
  GrbCompute:                                                                                                            
      GrbCrit    =((GrbObs-1)/sqrt(GrbObs))*sqrt(GrbTStat**2/(GrbObs-2+GrbTStat**2));                                    
      GrbDenom   =(GrbCalc**2*GrbObs-(GrbObs-1)**2);                                                                     
        Select;                                                                                                          
          When ( GrbDenom =.   ) GoTo ENDIT;                                                                             
          When ( GrbDenom <  0 ) GrbStat=sqrt(-(GrbCalc**2*GrbObs*(GrbObs-2)/GrbDenom));                                 
          When ( GrbDenom  = 0 ) GrbStat=sqrt(GrbCalc**2*GrbObs*(GrbObs-2)/GrbDenom);                                    
        OtherWise ;                                                                                                      
        End;                                                                                                             
        If  GrbStat =. then GoTo ENDIT;                                                                                  
        GrbPStat=Min(GrbObs*(1-ProbT(GrbStat,GrbObs-2)),1);                                                              
        If GrbPStat < GrbAlpha Then Do;                                                                                  
           If GrbTest='Min' Then GrbDrop=GrbKeys{GrbLo};                                                                 
           Else GrbDrop=GrbKeys{GrbHi};                                                                                  
           Output;                                                                                                       
        End;                                                                                                             
  Return;                                                                                                                
  /*------------------------------------------------------------*\                                                       
  |  Compute MeanStandard Deviation                              |                                                       
  \*------------------------------------------------------------*/                                                       
  BasicStats:                                                                                                            
      GrbObs=( GrbHi - GrbLo + 1 );                                                                                      
      SumSq_GrbVals=0;                                                                                                   
      Sum_GrbVals=0;                                                                                                     
      Do I = GrbLo To GrbHi;                                                                                             
         SumSq_GrbVals +  GrbVals{I}**2;                                                                                 
         Sum_GrbVals   +  GrbVals{I};                                                                                    
      End;                                                                                                               
      Std_GrbVals=Sqrt(                                                                                                  
                       (  GrbHi*SumSq_GrbVals - Sum_GrbVals**2 ) /                                                       
                       (  GrbObs* ( GrbObs- 1 )                )                                                         
                      );                                                                                                 
      Max_GrbVals=GrbVals{GrbHi};                                                                                        
      Min_GrbVals=GrbVals{GrbLo};                                                                                        
      Mean_GrbVals= Sum_GrbVals / GrbObs;                                                                                
  Return;                                                                                                                
  Run;                                                                                                                   
                                                                                                                         
                                                                                                                         
  Proc print Data=utl_Grubbs02  Width=Min;                                                                               
    Format GrbPStat 6.4;                                                                                                 
    Var                                                                                                                  
      GrbTest                                                                                                            
      GrbAlpha                                                                                                           
      GrbObs                                                                                                             
      GrbDrop                                                                                                            
      Min_GrbVals                                                                                                        
      Max_GrbVals                                                                                                        
      Mean_GrbVals                                                                                                       
      Std_GrbVals                                                                                                        
      GrbCalc                                                                                                            
      GrbCrit                                                                                                            
      GrbPStat;                                                                                                          
   Run;                                                                                                                  
  /*------------------------------------------------------------*\                                                       
  | Put in same order as original input                          |                                                       
  \*------------------------------------------------------------*/                                                       
  Proc Sort                                                                                                              
       Data = Utl_Grubbs01                                                                                               
       Out  = Utl_Grubbs01(Index= ( Utl_GrbKey / Unique ));                                                              
  By   Utl_GrbKey;                                                                                                       
  Run;                                                                                                                   
  /*------------------------------------------------------------*\                                                       
  | Tag the Outliers ( Use SQL just to keep skills up )          |                                                       
  \*------------------------------------------------------------*/                                                       
  Proc Sql;                                                                                                              
      Alter  Table  Utl_Grubbs01                                                                                         
      Modify _Outlier_ num;                                                                                              
      Update Utl_Grubbs01                                                                                                
      Set    _Outlier_ =                                                                                                 
        (                                                                                                                
         Select  1                                                                                                       
         From    utl_Grubbs02                                                                                            
         Where   GrbDrop = Utl_GrbKey                                                                                    
         );                                                                                                              
   Quit;                                                                                                                 
   Run;                                                                                                                  
  /*------------------------------------------------------------*\                                                       
  | Concatenate _Outlier_ onto original raw data                 |                                                       
  \*------------------------------------------------------------*/                                                       
  options mergenoby=nowarn;                                                                                              
  Data &dsn;                                                                                                             
     Merge &dsn                                                                                                          
           Utl_Grubbs01(Keep=_Outlier_);                                                                                 
    /*------------------------------------------------------------*\                                                     
    |  No By Statement ( Data in Exactly the same order )          |                                                     
    |  By Variable not on Raw Input Table                          |                                                     
    \*------------------------------------------------------------*/                                                     
      If _Outlier_ = . then _Outlier_ = 0;                                                                               
  Run;                                                                                                                   
  options mergenoby=warn;                                                                                                
  Proc Print                                                                                                             
             Data=&dsn(where=(_Outlier_=1));                                                                             
  run;                                                                                                                   
%mend Utl_Grubbs;                                                                                                        
                                                                                                                         
                                                                                  
                                                                                                                         
                                                                                                                         
                                                                                                                         
                                                                                                                         
