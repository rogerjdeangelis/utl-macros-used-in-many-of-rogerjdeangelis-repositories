%macro debug/cmd;                                                                                                                       
   store;note;notesubmit '%debuga;';                                                                                                    
   run;                                                                                                                                 
%mend debug;                                                                                                                            
                                                                                                                                        
%macro debuga;                                                                                                                          
   %let rc=%sysfunc(filename(myRef,%sysfunc(pathname(work))/mactxt.sas));                                                               
   %let sysrc=%sysfunc(fdelete(&myRef));                                                                                                
   %let rc=%sysfunc(filename(&myref));                                                                                                  
   filename clp clipbrd ;                                                                                                               
   data _null_;                                                                                                                         
     infile clp;                                                                                                                        
     file "%sysfunc(pathname(work))/macraw.sas";                                                                                        
     input;                                                                                                                             
     put _infile_;                                                                                                                      
   run;                                                                                                                                 
   filename mprint  "%sysfunc(pathname(work))/mactxt.sas";                                                                              
   options mfile mprint source2;                                                                                                        
   %inc "%sysfunc(pathname(work))/macraw.sas";                                                                                          
   run;quit;                                                                                                                            
   options nomfile nomprint;                                                                                                            
   filename mprint clear;                                                                                                               
   %inc "%sysfunc(pathname(work))/mactxt.sas";                                                                                          
   run;quit;                                                                                                                            
%mend debuga;                                                                                                                           
                                
