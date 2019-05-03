%macro utl_zipit(dsn)/des="zip a single SAS table in work and output table.zip";                                                        
                                                                                                                                        
    %local zipPth;                                                                                                                      
                                                                                                                                        
    %let zipPth=%sysfunc(pathname(work));                                                                                               
                                                                                                                                        
    %utlfkil(&zipPth./test_inp.zip);                                                                                                    
                                                                                                                                        
    filename projzip "&zipPth./&dsn.zip";                                                                                               
                                                                                                                                        
    data _null_;                                                                                                                        
       rc=fdelete("&dsn");                                                                                                              
    run;                                                                                                                                
                                                                                                                                        
    ods output EngineHost=File;                                                                                                         
      proc contents data=work.&dsn;                                                                                                     
    run;                                                                                                                                
                                                                                                                                        
    proc sql noprint;                                                                                                                   
       select cValue1 into: outDsName from work.file where Label1="Filename";                                                           
    quit;                                                                                                                               
                                                                                                                                        
    filename data_fn "&zipPth./&dsn..sas7bdat";                                                                                         
                                                                                                                                        
    filename addfile zip "&zipPth./&dsn..zip" member="data/&dsn..sas7bdat";                                                             
                                                                                                                                        
    data _null_;                                                                                                                        
       infile data_fn recfm=n;                                                                                                          
       file addfile recfm=n;                                                                                                            
       input byte $char1. @;                                                                                                            
       put byte $char1. @;                                                                                                              
    run;                                                                                                                                
                                                                                                                                        
    filename projzip clear;                                                                                                             
                                                                                                                                        
%mend utl_zipit;        
