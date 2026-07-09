%macro slc_submit_py64x(                                                        
      pgmx                                                                      
     ,resolve=N                                                                 
     ,return=N  /* name for the macro variable from Python */                   
     )/des="Semi colon separated set of python commands - drop down to python"; 
  /*---  Unfortunately python forces indented code you need to use a period see below    ---*/                                                                  
  /*---  if x < 2;                                                                       ---*/                                                                  
  /*---  .    print(x);                                                                  ---*/                                                                  
  /*--- To pass macro variable back to sas                                                                                                                      
  /*--- import pyperclip;                                                                                                                                       
  /*--- x=2 ;                                                                                                                                                   
  /*--- pyperclip.copy(str(area));                                                                                                                              
  /*--- THIS DROP DOWN SUPPORTS THREE QUOTES, SINGLE QUOTE, DOUBLE QUOTE AND BACTIC      ---*/                                                                  
  /*--- YOU CAN RESOLVE DOUBLE QUOTED MACRO VARIABLES INSIDE SINGLE QUOTES USING BACTIC  ---*/                                                                  
  /*--- THE MACRO VARIABLE INSIDE THE R PROGRAM, AREA<-'&RADIUS', CAN BE RESOLVED        ---*/                                                                  
  /*--- THE NOTEPAD CLIPBOARD IS USE TO PASS MACRO CREATE DBY R BACK TO THE DATASTEP     ---*/                                                                  
  * delete temporary files;                                                                                                                                     
  %utlfkil(c:/temp/py_pgm.py);                                                                                                                                  
  %utlfkil(c:/temp/stderr.txt);                                                                                                                                 
  /*--- VARIABLE COMMAND REPRESENTS ONE LINE OF PYTHON CODE AND IS WRITTEN IN A LOOP     ---*/                                                                  
  filename py_pgm "c:/temp/py_pgm.py" lrecl=32766 recfm=v;                                                                                                      
  data _null_;                                                                                                                                                  
    length pgm  $32755 cmd $1024;                                                                                                                               
    file py_pgm ;                                                                                                                                               
    %if %upcase(&resolve)=Y %then %do;                                                                                                                          
         pgm=resolve(&pgmx);                                                                                                                                    
    %end;                                                                                                                                                       
    %else %do;                                                                                                                                                  
         pgm=&pgmx;                                                                                                                                             
    %end;                                                                                                                                                       
    semi=countc(pgm,";");                                                                                                                                       
      do idx=1 to semi;                                                                                                                                         
        cmd=cats(scan(pgm,idx,";"));                                                                                                                            
        /*--- PYTHON LINE HAS A BACTIC CONVERT TO SINGLE QUOTE                         ---*/                                                                    
        /*--- THIS ALLOWS NAME='&NAME' TO BE RESOLVED AND OTHE CASES OF MUTIPLE QUOTES ---*/                                                                    
        if index(cmd,"`") then                                                                                                                                  
            cmd=tranwrd(cmd,"`","27"x); /*--- 27 is a single quote ---*/                                                                                        
         if cmd=:"." then                                                                                                                                       
            cmd=substr(cmd,2);                                                                                                                                  
         len=length(cmd);                                                                                                                                       
         put    cmd $varying1024. len ;                                                                                                                         
         putlog cmd $varying1024. len ;                                                                                                                         
      end;                                                                                                                                                      
  run;quit;                                                                                                                                                     
  %let _stderr=c:/temp/stderr.txt;                                                                                                                              
  filename rut pipe  "d:\py314\python.exe c:/temp/py_pgm.py 2> &_stderr";                                                                                       
  data _null_;                                                                                                                                                  
    file print;                                                                                                                                                 
    infile rut;                                                                                                                                                 
    input;                                                                                                                                                      
    put _infile_;                                                                                                                                               
  run;                                                                                                                                                          
  filename rut clear;                                                                                                                                           
data _null_;                                                                                                                                                    
    file print;                                                                                                                                                 
    infile "c:/temp/stderr.txt";                                                                                                                                
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
%mend slc_submit_py64x;                                                                                                                                         
