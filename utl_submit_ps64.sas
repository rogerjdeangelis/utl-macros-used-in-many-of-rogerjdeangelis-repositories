%macro utl_submit_ps64(                                                                                                                          
      pgm                                                                                                                                        
     ,return=  /* name for the macro variable from Powershell */                                                                                 
     )/des="Semi colon separated set of python commands - drop down to python";                                                                  
                                                                                                                                                 
  /*                                                                                                                                             
      %let pgm='Get-Content -Path d:/txt/back.txt | Measure-Object -Line | clip;';                                                               
  */                                                                                                                                             
                                                                                                                                                 
  * write the program to a temporary file;                                                                                                       
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.ps1" lrecl=32766 recfm=v;                                                                     
  data _null_;                                                                                                                                   
    length pgm  $32755 cmd $1024;                                                                                                                
    file py_pgm ;                                                                                                                                
    pgm=&pgm;                                                                                                                                    
    semi=countc(pgm,';');                                                                                                                        
      do idx=1 to semi;                                                                                                                          
        cmd=cats(scan(pgm,idx,';'));                                                                                                             
        if cmd=:'. ' then                                                                                                                        
           cmd=trim(substr(cmd,2));                                                                                                              
         put cmd $char384.;                                                                                                                      
         putlog cmd $char384.;                                                                                                                   
      end;                                                                                                                                       
  run;quit;                                                                                                                                      
  %let _loc=%sysfunc(pathname(py_pgm));                                                                                                          
  %put &_loc;                                                                                                                                    
  filename rut pipe  "powershell.exe -executionpolicy bypass -file &_loc > c:/temp/ps_pgm.log ";                                                 
  data _null_;                                                                                                                                   
    file print;                                                                                                                                  
    infile rut;                                                                                                                                  
    input;                                                                                                                                       
    put _infile_;                                                                                                                                
    putlog _infile_;                                                                                                                             
  run;                                                                                                                                           
  filename rut clear;                                                                                                                            
  filename py_pgm clear;                                                                                                                         
                                                                                                                                                 
  * use the clipboard to create macro variable;                                                                                                  
  %if "&return" ^= "" %then %do;                                                                                                                 
    filename clp clipbrd ;                                                                                                                       
    data _null_;                                                                                                                                 
     length txt $200;                                                                                                                            
     infile clp;                                                                                                                                 
     input;                                                                                                                                      
     putlog "*******  " _infile_;                                                                                                                
     call symputx("&return",_infile_,"G");                                                                                                       
    run;quit;                                                                                                                                    
  %end;                                                                                                                                          
                                                                                                                                                 
%mend utl_submit_ps64;                                                                                                                           
                                                   
                                                                                                                                                                                                                                     
                                            
