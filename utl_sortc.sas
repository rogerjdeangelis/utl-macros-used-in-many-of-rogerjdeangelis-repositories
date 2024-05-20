                                                              
%macro utl_sortc(buff) ;                                      
                                                              
%local n rc buff ;                                            
                                                              
%let n=%sysfunc(countw(&buff));                               
                                                              
%let buff=%sysfunc(dequote("'&buff'"));                       
%let buff=%qsysfunc(tranwrd(&buff,%str( ),%str(' ')));        
                                                              
%dosubl(%sysfunc(dequote("                                    
  data _null_;                                                
    array x [&n] $32 _temporary_ (&buff);                     
    call sortc(of x[*]);                                      
    call symputx('_sessref_',catx(' ',of x[*]));              
  run;quit;                                                   
  ")))                                                        
                                                              
  &_sessref_                                                  
                                                              
%mend utl_sortc;                                                        
                      
