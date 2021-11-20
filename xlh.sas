%macro xlh /cmd ;                                                                      
   store;note;notesubmit '%xlha;';                                                    
   run;                                                                                
%mend xlh;                                                                             
                                                                                       
%macro xlha/cmd;                                                                       
                                                                                       
    filename clp clipbrd ;                                                             
                                                                                       
    data _null_;                                                                       
       length fyl $500;                                                                
       infile clp;                                                                     
       input;                                                                          
                                                                                       
       dsn=_infile_;                                                                   
                                                                                       
       wrk=translate("%sysfunc(getoption(work))",'/','\');                             
                                                                                       
       if index(dsn,".")=0 then do;                                                    
           * get work directory fix slashes \ is R escape char;                        
           fyl=cats(wrk,'/',dsn);                                                      
           put fyl;                                                                    
       end;                                                                            
       else do;                                                                        
          folder=translate(pathname(scan(dsn,1,'.')),'/','\');                         
          fyl=cats(folder,'/',scan(dsn,2,'.'));                                        
          put fyl;                                                                     
       end;                                                                            
       call symputx('fyl',fyl);                                                        
       call symputx('wrk',wrk);                                                        
   run;quit;                                                                           
                                                                                       
    %utlfkil(&wrk/_xls.xlsx);                                                          
                                                                                       
    %utl_submit_r64("                                                                  
       library(haven);                                                                 
       library(XLConnect);                                                             
       have<-read_sas('&fyl..sas7bdat');                                               
       wb <- loadWorkbook('&wrk/_xls.xlsx', create = TRUE);                            
       createSheet(wb, name = 'have');                                                 
       writeWorksheet(wb, have, sheet = 'have');                                       
       saveWorkbook(wb);                                                               
    ");                                                                                
                                                                                       
    options noxwait noxsync;                                                           
    /* Open Excel */                                                                   
    x "'C:\Program Files\Microsoft Office\OFFICE14\excel.exe' &wrk/_xls.xlsx";         
    run;quit;                                                                          
                                                                                       
%mend xlha;                                                                            
