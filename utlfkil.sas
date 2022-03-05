%macro utlfkil                                               
    (                                                        
    utlfkil                                                  
    ) / des="delete an external file";                       
                                                             
                                                             
    /*-------------------------------------------------*\    
    |                                                   |    
    |  Delete an external file                          |    
    |   From SAS macro guide                            |    
    |  Sample invocations                               |    
    |                                                   |    
    |  WIN95                                            |    
    |  %utlfkil(c:\dat\utlfkil.sas);                    |    
    |                                                   |    
    |                                                   |    
    |  Solaris 2.5                                      |    
    |  %utlfkil(/home/deangel/delete.dat);              |    
    |                                                   |    
    |                                                   |    
    |  Roger DeAngelis                                  |    
    |                                                   |    
    \*-------------------------------------------------*/    
                                                             
    %local urc;                                              
                                                             
    /*-------------------------------------------------*\    
    | Open file   -- assign file reference              |    
    \*-------------------------------------------------*/    
                                                             
    %let urc = %sysfunc(filename(fname,%quote(&utlfkil)));   
                                                             
    /*-------------------------------------------------*\    
    | Delete file if it exits                           |    
    \*-------------------------------------------------*/    
                                                             
    %if &urc = 0 and %sysfunc(fexist(&fname)) %then %do;         
        %let urc = %sysfunc(fdelete(&fname));   
        %put xxxxxx &fname deleted xxxxxx;
    %end;
    %else %do;
        %put xxxxxx &fname not found xxxxxx; 
    %end;            
                                                             
    /*-------------------------------------------------*\    
    | Close file  -- deassign file reference            |    
    \*-------------------------------------------------*/    
                                                             
    %let urc = %sysfunc(filename(fname,""));                 
                                                             
  run;                                                       
                                                             
%mend utlfkil;                                               
                                                             
