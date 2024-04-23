%macro utl_psend(returnvar=N);                                                                                
options noxwait noxsync;                                                                                      
filename rut pipe  "powershell.exe -executionpolicy bypass -file c:/temp/ps_pgm.ps1 >  c:/temp/ps_pgm.log";   
run;quit;                                                                                                     
  data _null_;                                                                                                
    file print;                                                                                               
    infile rut recfm=v lrecl=32756;                                                                           
    input;                                                                                                    
    put _infile_;                                                                                             
    putlog _infile_;                                                                                          
  run;                                                                                                        
  filename ft15f001 clear;                                                                                    
  * use the clipboard to create macro variable;                                                               
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;                                                       
    filename clp clipbrd ;                                                                                    
    data _null_;                                                                                              
     length txt $200;                                                                                         
     infile clp;                                                                                              
     input;                                                                                                   
     putlog "macro variable &returnVar = " _infile_;                                                          
     call symputx("&returnVar.",_infile_,"G");                                                                
    run;quit;                                                                                                 
  %end;                                                                                                       
data _null_;                                                                                                  
  file print;                                                                                                 
  infile rut;                                                                                                 
  input;                                                                                                      
  put _infile_;                                                                                               
  putlog _infile_;                                                                                            
run;quit;                                                                                                     
data _null_;                                                                                                  
  infile "c:/temp/ps_pgm.log";                                                                                
  input;                                                                                                      
  putlog _infile_;                                                                                            
run;quit;                                                                                                     
filename ft15f001 clear;                                                                                      
%mend utl_psend;                                                                                              

