%macro utl_submit_py64_39(                                             
      pgm                                                              
     ,return=  /* name for the macro variable from Python */           
     )/des="Semi colon separated set of python commands - drop down to 
                                                                       
  * delete temporary files;                                            
  %utlfkil(%sysfunc(pathname(work))/py_pgm.py);                        
  %utlfkil(%sysfunc(pathname(work))/stderr.txt);                       
  %utlfkil(%sysfunc(pathname(work))/stdout.txt);                       
                                                                       
  filename py_pgm "%sysfunc(pathname(work))/py_pgm.py" lrecl=32766 recf
  data _null_;                                                         
    length pgm  $32755 cmd $1024;                                      
    file py_pgm ;                                                      
    pgm=&pgm;                                                          
    semi=countc(pgm,";");                                              
      do idx=1 to semi;                                                
        cmd=cats(scan(pgm,idx,";"));                                   
        if cmd=:". " then                                              
           cmd=trim(substr(cmd,2));                                    
         put cmd ;                                                     
         putlog cmd ;                                                  
      end;                                                             
  run;quit;                                                            
  %let _loc=%sysfunc(pathname(py_pgm));                                
  %let _stderr=%sysfunc(pathname(work))/stderr.txt;                    
  %let _stdout=%sysfunc(pathname(work))/stdout.txt;                    
  filename rut pipe  "c:\Python39\python.exe &_loc 2> &_stderr";       
  data _null_;                                                         
    file print;                                                        
    infile rut;                                                        
    input;                                                             
    put _infile_;                                                      
  run;                                                                 
  filename rut clear;                                                  
  filename py_pgm clear;                                               
                                                                       
data _null_;                                                           
    file print;                                                        
    infile "%sysfunc(pathname(work))/stderr.txt";                      
    input;                                                             
    put _infile_;                                                      
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
                                                                       
%mend utl_submit_py64_39;                                              
                                                                       
