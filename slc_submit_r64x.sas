%macro slc_submit_r64x(                                                         
      pgmx                                                                      
     ,return=N                                                                  
     ,resolve=N                                                                 
     )/des="Semi colon separated set of R commands - drop down to R";           
                                                                                
  /*--- THIS DROP DOWN SUPPORTS THREE QUOTES, SINGLE QUOTE, DOUBLE QUOTE AND BACTIC      ---*/
  /*--- YOU CAN RESOLVE DOUBLE QUOTED MACRO VARIABLES INSIDE SINGLE QUOTES USING BACTIC  ---*/
  /*--- The macro variable inside the r program, area<-'&radius', can be resolved        ---*/
  /*--- THE NOTEPAD CLIPBOARD IS USE TO PASS MACRO CREATE DBY R BACK TO THE DATASTEP     ---*/
                                                                                
  %utlfkil(c:/temp/r_pgm.txt);                                                  
                                                                                
  * clear clipboard;                                                            
  filename _clp clipbrd;                                                        
  data _null_;                                                                  
    file _clp;                                                                  
    put " ";                                                                    
  run;quit;                                                                     
                                                                                
  * WRITE THE PROGRAM TO A TEMPORARY FILE AND LOG;                              
                                                                                
  filename r_pgm "c:/temp/r_pgm.txt" lrecl=32766 recfm=v;                       
                                                                                
  data _null_;                                                                  
    length pgm $32756;                                                          
    file r_pgm;                                                                 
    if substr(upcase("&resolve"),1,1)="Y" then do;                              
        pgm=resolve(&pgmx);                                                     
     end;                                                                       
    else do;                                                                    
        pgm=&pgmx;                                                              
     end;                                                                       
     if index(pgm,"`") then cmd=tranwrd(pgm,"`","27"x);                         
    put pgm;                                                                    
    putlog pgm;                                                                 
  run;                                                                          
                                                                                
  * PIPE FILE THROUGH R;                                                        
                                                                                
  filename rut pipe "C:\Progra~1\R\R-4.5.2\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgm.txt";
  data _null_;                                                                  
    file print;                                                                 
    infile rut recfm=v lrecl=32756;                                             
    input;                                                                      
    put _infile_;                                                               
    putlog _infile_;                                                            
  run;                                                                          
                                                                                
  filename rut clear;                                                           
  filename r_pgm clear;                                                         
                                                                                
  * USE THE CLIPBOARD TO CREATE MACRO VARIABLE;                                 
                                                                                
  %if %upcase(%substr(&return.,1,1)) ne N %then %do;                            
    filename clp clipbrd ;                                                      
    data _null_;                                                                
     infile clp;                                                                
     input;                                                                     
     putlog "macro variable &return = " _infile_;                               
     call symputx("&return.",_infile_,"G");                                     
    run;quit;                                                                   
  %end;                                                                         
                                                                                
%mend slc_submit_r64x;                                                          
