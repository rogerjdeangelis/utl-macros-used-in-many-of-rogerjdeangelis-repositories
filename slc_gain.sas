%macro slc_gain                                                                 
   (                                                                            
     inp      =   /* input dataset vars=group(decile Deciles) 0 to 9 with 0 having highest score */                                                             
    ,score    =   /* scores 0-1                                                                  */                                                             
    ,out      =   /* output dataset                                                              */                                                             
    ,ptile    =   /* groupings - Deciles                                                         */                                                             
    ,response =   /* response variable 0/1                                                       */                                                             
    ,excel    =   /* c:\tut\xls\utl_ganrpt.xls                                                   */                                                             
    ,line1    =   "Index and Gains Table for Overall Response"                                                                                                  
    ,line2    =   "The Overall Percentage of Zip9s with at least is Bentley(1.4794%)"                                                                           
    ,line3    =   "The index is the Percent Response in the Decile divided by the Overall Response."                                                            
    ,line4    =   "For instance the top decile the Index=11.1482/1.4794 or 7.536"                                                                               
    ,line5    =   "Bentleys in the top Decile are almost 8 times as likely to have a Stroke or Heart Attack "                                                   
    ,line6    =   "The average score times the decile total should roughly equal to the number of Bentleys with a Stroke or Heat Attack"                        
    ,line7    =   "The average score times the decile total should roughly equal to the number of Bentleys with a Stroke or Heat Attack"                        
   )/des="Gains and Index Table";                                                                                                                               
     /*                                                                                                                                                         
     if running without macro                                                                                                                                   
     inp      = tut.tut_fakdat                                                                                                                                  
     score    = score                                                                                                                                           
     out      = tut_gain                                                                                                                                        
     ptile    = deciles                                                                                                                                         
     response = response                                                                                                                                        
     excel    = c:\tut\xls\utl_ganrpt.xls                                                                                                                       
     line1    = 'Index and Gains(lft) Table by Response Deciles'                                                                                                
     line2    = 'The Overall Percentage of Zip9s with at least one Bentley is 1.4794%'                                                                          
     line3    = 'The index is the Percent Response in the Decile divided by the Overall Response.'                                                              
     line4    = 'For instance for the top decile the Index=11.330/1.4794 or 7.66'                                                                               
     line5    = 'Patients in the top Decile are 7.7 times as likely to have a Stroke or Heart Attack '                                                          
     line6    = 'Average score times decile total is roughly equal to the Stroke or Heat Attack count'                                                          
     */                                                                                                                                                         
    * check for blank arguments;                                                                                                                                
    %put %sysfunc(ifc(%sysevalf(%superq(inp     )=,boolean),**** Please Provide Input dataset        ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(score   )=,boolean),**** Please Provide Soce variable        ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(out     )=,boolean),**** Please Provide Output Dataset       ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(ptile   )=,boolean),**** Please Provide an Decile Variable   ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(response)=,boolean),**** Please Provide an Response Variable ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(excel   )=,boolean),**** Please Provide Excel output         ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(line1   )=,boolean),**** Please Provide 1st Tile Line        ****,));                                                   
    %put %sysfunc(ifc(%sysevalf(%superq(line2   )=,boolean),**** Please Provide 2nd Title line       ****,));                                                   
    %let res= %eval                                                                                                                                             
    (                                                                                                                                                           
        %sysfunc(ifc(%sysevalf(%superq(inp      )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(score    )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(out      )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(ptile    )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(response )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(excel    )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(line1    )=,boolean),1,0))                                                                                               
      + %sysfunc(ifc(%sysevalf(%superq(line2    )=,boolean),1,0))                                                                                               
    );                                                                                                                                                          
     %if &res = 0 %then %do;                                                                                                                                    
        * Decile stats;                                                                                                                                         
        proc sql noprint;                                                                                                                                       
          select                                                                                                                                                
              count(*)                                                                                                                                          
             ,sum(&response)                                                                                                                                    
             ,sum(&response=0)                                                                                                                                  
          into                                                                                                                                                  
              :CntTot    separated by ''   /* sep by to strip macro var */                                                                                      
             ,:RspTot    separated by ''                                                                                                                        
             ,:NonRspTot separated by ''                                                                                                                        
          from                                                                                                                                                  
             &inp;                                                                                                                                              
          create                                                                                                                                                
            table utl_rspcnt as                                                                                                                                 
          select                                                                                                                                                
            max(&score)          as ScoMax                                                                                                                      
           ,min(&score)          as ScoMin                                                                                                                      
           ,mean(&score)         as ScoAvg                                                                                                                      
           ,sum(&response=0)     as RspNon                                                                                                                      
           ,sum(&response)       as Rsp                                                                                                                         
           ,count(*)             as RnkCnt                                                                                                                      
           ,100 * (calculated Rsp/calculated RnkCnt)      as RspPctTotRnk                                                                                       
           ,100 * (calculated Rsp/&RspTot)                as RspPctTotRsp                                                                                       
           ,calculated RspPctTotRnk/(100*&RspTot/&CntTot) as Idx                                                                                                
          from                                                                                                                                                  
            &inp                                                                                                                                                
          group                                                                                                                                                 
            by &ptile                                                                                                                                           
          order                                                                                                                                                 
            by &ptile descending                                                                                                                                
        ;quit;                                                                                                                                                  
        /*                                                                                                                                                      
        Up to 40 obs WORK.UTL_RSPCNT total obs=8                                                                                                                
        Obs     SCOMAX     SCOMIN      SCOAVG    RSPNON     RSP    RNKCNT    RSPPCTTOTRNK    RSPPCTTOTRSP      IDX                                              
         1     0.96637    0.020337    0.10523      9859    1237     11096       11.1482         75.6112      7.53578                                            
         2     0.02029    0.007936    0.01185     10882     175     11057        1.5827         10.6968      1.06986                                            
         3     0.00794    0.005341    0.00631     10570      93     10663        0.8722          5.6846      0.58956                                            
         4     0.00534    0.004390    0.00472     14635      89     14724        0.6045          5.4401      0.40859                                            
         5     0.00439    0.004012    0.00427      7545      42      7587        0.5536          2.5672      0.37420                                            
         6     0.00400    0.003047    0.00337     10931       0     10931        0.0000          0.0000      0.00000                                            
         7     0.00304    0.002814    0.00287     12284       0     12284        0.0000          0.0000      0.00000                                            
         8     0.00273    0.002705    0.00272     32246       0     32246        0.0000          0.0000      0.00000                                            
         */                                                                                                                                                     
        * cumulative stats;                                                                                                                                     
        data utl_cum;                                                                                                                                           
         retain Rnk ScoMax ScoAvg ScoMin RnkCnt RnkCntCum RnkCntCumPct                                                                                          
                RspNon RspNonCum Rsp RspCum RspPctTotRsp RspPctTotRspCum RspPctTotRnk                                                                           
                RspPctTotRnkcum Idx Gan;                                                                                                                        
        format                                                                                                                                                  
          SCOMAX  SCOAVG  SCOMIN 6.3 RNKCNTCUMPCT 3. RSPPCTTOTRSP RSPPCTTOTRSPCUM RSPPCTTOTRNK RSPPCTTOTRNKCUM 7.2  IDX   GAN  7.2;                             
        label                                                                                                                                                   
           Rnk               =  "Decile                                           "                                                                             
           ScoMax            =  "Max+Score                                        "                                                                             
           ScoAvg            =  "Average+Score                                    "                                                                             
           ScoMin            =  "Minimum+Score                                    "                                                                             
           RnkCnt            =  "Decile+Count                                     "                                                                             
           RnkCntCum         =  "Cumulative+Decile+Count                          "                                                                             
           RnkCntCumPct      =  "Cumulative+Decile+Percent                        "                                                                             
           RspNon            =  "Non-+Responders                                  "                                                                             
           RspNonCum         =  "Cumulative+Non-+Responders                       "                                                                             
           Rsp               =  "Responders                                       "                                                                             
           RspCum            =  "Cumulative+Decile+Count                          "                                                                             
           RspPctTotRsp      =  "Responder+Percent+of Total+Response              "                                                                             
           RspPctTotRspCum   =  "Cumulative+Responder+Percent+Total+Response      "                                                                             
           RspPctTotRnk      =  "Responder+Responder+Percent+of Decile+Total      "                                                                             
           RspPctTotRnkcum   =  "Cumulative+Responder+Percent+of Decile+Total     "                                                                             
           Idx               =  "Unitless+Index+Decile Response/+Overall+Response "                                                                             
           Gan               =  "Gain+Response-+Overall Response/+Overall Response";                                                                            
           set utl_rspcnt;                                                                                                                                      
           RnkCntCum        + RnkCnt;                                                                                                                           
           RnkCntCumPct     = 100*(RnkCntCum/&CntTot);                                                                                                          
           RspNonCum        + RspNon;                                                                                                                           
           RspCum           + Rsp;                                                                                                                              
           RspPctTotRnkCum  = 100*RspCum/RnkCntCum;                                                                                                             
           RspPctTotRspCum  + RspPctTotRsp;                                                                                                                     
           Gan              = (RspPctTotRnkCum/100) / (&RspTot/&CntTot);                                                                                        
           Rnk=_n_;                                                                                                                                             
           OneVal=1;                                                                                                                                            
           Decile = Rnk;                                                                                                                                        
        run;                                                                                                                                                    
        /*                   RspPctTotRnkcum                                                                                                                    
        Middle Observation(4 ) of Last dataset = WORK.UTL_CUM - Total Obs 8                                                                                     
         -- NUMERIC --                                                                                                                                          
        RNK                  N    8       4                   Decile                                                                                            
        SCOMAX               N    8       0.0053390215        Max+Score                                                                                         
        SCOAVG               N    8       0.0047175046        Average+Score                                                                                     
        SCOMIN               N    8       0.0043901185        Minimum+Score                                                                                     
        RNKCNT               N    8       14724               Decile+Count                                                                                      
        RNKCNTCUM            N    8       47540               Cumulative+Decile+Count                                                                           
        RNKCNTCUMPCT         N    8       42.988389337        Cumulative+Decile+Percent                                                                         
        RSPNON               N    8       14635               Non-+Responders                                                                                   
        RSPNONCUM            N    8       45946               Cumulative+Non-+Responders                                                                        
        RSP                  N    8       89                  Responders                                                                                        
        RSPCUM               N    8       1594                Cumulative+Decile+Count                                                                           
        RSPPCTTOTRSP         N    8       5.4400977995        Responder+Percent+of Total+Response                                                               
        RSPPCTTOTRSPCUM      N    8       97.432762836        Cumulative+Responder+Percent+Total+Response                                                       
        RSPPCTTOTRNK         N    8       0.6044553111        Responder+Responder+Percent+of Decile+Total                                                       
        RSPPCTTOTRNKCUM      N    8       3.3529659234        Cumulative+Responder+Percent+of Decile+Total                                                      
        IDX                  N    8       0.4085910999        Unitless+Index+Decile Response/+Overall+Response                                                  
        GAN                  N    8       2.2664901928        Gain+Response-+Overall Response/+Overall Response                                                 
        ONEVAL               N    8       1                   ONEVAL                                                                                            
        DECILE               N    8       4                   DECILE                                                                                            
        */                                                                                                                                                      
      %utlfkil(&excel);                                                                                                                                         
      ods listing close;                                                                                                                                        
      ods escapechar='^';                                                                                                                                       
      ods excel file="&excel" style=minimal                                                                                                                     
      options                                                                                                                                                   
       (                                                                                                                                                        
      /* start_at                   = "D3"    messes up autofilter? and other stuff */                                                                          
         tab_color                  = "yellow"                                                                                                                  
      /* autofilter                 = 'yes'     */                                                                                                              
         orientation                = 'landscape'                                                                                                               
         zoom                       = "100"                                                                                                                     
         suppress_bylines           = 'no'                                                                                                                      
         embedded_titles            = 'yes'                                                                                                                     
         embedded_footnotes         = 'yes'                                                                                                                     
         embed_titles_once          = 'yes'                                                                                                                     
         gridlines                  = 'on'                                                                                                                      
      /* frozen_headers             = 'Yes'                                                                                                                     
         absolute_column_width      =  "30pct,22pct,22pct,23pct" not needed                                                                                     
         frozen_rowheaders          = 'yes'                                 */                                                                                  
        );                                                                                                                                                      
    ;run;quit;                                                                                                                                                  
    ods excel options(sheet_name="utl_ganrpt" sheet_interval="none");                                                                                           
        title;footnote;                                                                                                                                         
        proc report data=utl_cum nowd missing split='+' headskip headline out=workx.lgs_rptout                                                                                      
            style(header)={font_size=13pt just=left font_face=Times}                                                                                            
            style(column)={font_size=11pt font_face=Times }                                                                                                     
        ;                                                                                                                                                       
        title1 justify=left h=15pt &line1;                                                                                                                      
        title2 " ";                                                                                                                                             
        title3 justify=left h=13pt &line2;                                                                                                                      
        title4 justify=left h=13pt &line3;                                                                                                                      
        title5 justify=left h=13pt &line4;                                                                                                                      
        title6 justify=left h=13pt &line5;                                                                                                                      
        title7 justify=left h=13pt &line6;                                                                                                                      
        title8 justify=left h=13pt &line7;                                                                                                                      
        title9  " ";                                                                                                                                            
        cols                                                                                                                                                    
          (                                                                                                                                                     
           'Index and Gains(lift) Table by Response Deciles+ '                                                                                                  
             Decile                                                                                                                                             
            ( "Probabilities"                                                                                                                                   
             ScoMax                                                                                                                                             
             ScoAvg                                                                                                                                             
             ScoMin                                                                                                                                             
            )                                                                                                                                                   
            ( "Decile Stats"                                                                                                                                    
             RnkCnt                                                                                                                                             
             RnkCntCum                                                                                                                                          
             RnkCntCumPct                                                                                                                                       
            )                                                                                                                                                   
            ( "Response and Non Response Counts"                                                                                                                
             RspNon                                                                                                                                             
             RspNonCum                                                                                                                                          
             Rsp                                                                                                                                                
             RspCum                                                                                                                                             
            )                                                                                                                                                   
            ( "Percents"                                                                                                                                        
             RspPctTotRsp                                                                                                                                       
             RspPctTotRspCum                                                                                                                                    
             RspPctTotRnk                                                                                                                                       
             RspPctTotRnkcum                                                                                                                                    
            )                                                                                                                                                   
            ( "Liklehood and Gain"                                                                                                                              
             Idx                                                                                                                                                
             Gan                                                                                                                                                
            )                                                                                                                                                   
           );                                                                                                                                                   
        define Decile            / display "Decile                  " style={just=right tagattr='format:##0' cellwidth=0.7in};                                  
        define ScoMax            / display "Max+Score               " style={just=right tagattr='format:0.####0' cellwidth=0.7in};                              
        define ScoAvg            / display "Mean+Score              " style={just=right tagattr='format:0.####0' cellwidth=0.7in};                              
        define ScoMin            / display "Min+Score               " style={just=right tagattr='format:0.####0' cellwidth=0.7in};                              
        define RnkCnt            / display "Decile+Count            " style={just=right tagattr='format:###,##0' cellwidth=0.7in};                              
        define RnkCntCum         / display "Cum+Decile+Count        " style={just=right tagattr='format:###,##0' cellwidth=0.7in};                              
        define RnkCntCumPct      / display "Cum+Decile+Percent      " style={just=right tagattr='format:###,##0' cellwidth=0.7in};                              
        define RspNon            / display "Decile+Zip9+No+Bentleys " style={just=right tagattr='format:###,##0' cellwidth=1.1in};                              
        define RspNonCum         / display "Cum+Zip9+No+Bentleys  " style={just=right tagattr='format:###,##0' cellwidth=1.1in};                                
        define Rsp               / display "Zip9s+with+Bentleys      " style={just=right tagattr='format:###,##0' cellwidth=0.9in};                             
        define RspCum            / display "Cum+Zip9s+with+Bentleys " style={just=right tagattr='format:###,##0' cellwidth=0.9in};                              
        define RspPctTotRsp      / display "Zip9s+Bentleys+as %+Total+Zip9s+Decile 2+180/10.45"    style={just=right tagattr='format:##0.#0' cellwidth=0.1.1in};
        define RspPctTotRspCum   / display "Cum+Zip9s+Bentleys+as %+Total+Response"                         style={just=right tagattr='format:##0.#0' cellwidth=1.2in};                                                                         
        define RspPctTotRnk      / display "Zip9s+Bentleys+as %+of Decile+Total+Decile 2+180/7000"            style={just=right tagattr='format:##0.#0' cellwidth=1.2in};                                                                       
        define RspPctTotRnkcum   / display "Cum+Zip9s+Bentleys+as %+of Decile+Totals" style={just=right tagattr='format:##0.#0' cellwidth=1.2in};                                                                                               
        define Idx               / display "Liklehood+vs Entire+Population+Decile 2+(180/7001)/+(1045/70000)"    style={just=center tagattr='format:##0.##0' cellwidth=1.4in};                                                                  
        define Gan               / display "Cum+Liklehood+Decile 2+(637/14000)/+(1045/70000)" style={just=right tagattr='format:##0.##0' cellwidth=1.4in};                                                                                      
        compute idx;                                                                                                                                                                                                                            
           call define(_col_, "Style", "Style = [background = yellow]");                                                                                                                                                                        
        endcomp;                                                                                                                                                                                                                                
        run;quit;                                                                                                                                                                                                                               
        ods excel close;                                                                                                                                                                                                                        
     %end;                                                                                                                                                                                                                                      
%mend slc_gain;                                                                                                                                                                                                                                 
