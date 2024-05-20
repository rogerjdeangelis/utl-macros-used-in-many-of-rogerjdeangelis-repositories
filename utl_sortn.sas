%macro utl_sortn() / parmbuff ;                                                                                                         
                                                                                                                                        
  %local n rc buff;                                                                                                                     
                                                                                                                                        
  %let n=%sysfunc(countw(&syspbuff,( , )));                                                                                             
                                                                                                                                        
  %dosubl(%sysfunc(dequote("                                                                                                            
     data _null_;                                                                                                                       
       array x [&n] _temporary_ &syspbuff;                                                                                              
       call sortn(of x[*]);                                                                                                             
       call symputx('_sessref_',catx(' ',of x[*]));                                                                                     
     run;                                                                                                                               
     ")))                                                                                                                               
                                                                                                                                        
  &_sessref_                                                                                                                            
                                                                                                                                        
%mend utl_sortn;                                                                                                                        
                                         
