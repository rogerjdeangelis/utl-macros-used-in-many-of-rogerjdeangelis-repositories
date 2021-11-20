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
                                                               
    %if &urc = 0 and %sysfunc(fexist(&fname)) %then            
        %let urc = %sysfunc(fdelete(&fname));                  
                                                               
    /*-------------------------------------------------*\      
    | Close file  -- deassign file reference            |      
    \*-------------------------------------------------*/      
                                                               
    %let urc = %sysfunc(filename(fname,""));                   
                                                               
    /*-------------------------------------------------*\      
    | Close file  -- deassign file reference            |      
    \*-------------------------------------------------*/      
                                                               
    %utlnopts;                                                 
        %put                                      ;            
    %if &urc = 0 and %sysfunc(fexist(&fname)) %then %do;       
        %put ===================================  ;            
        %put                                      ;            
        %put FILE NOT DELETED - MAY BE READ ONLY  ;            
        %put                                      ;            
        %put ===================================  ;            
        %put                                      ;            
    %end;                                                      
    %utlopts;                                                  
                                                               
  run;                                                         
                                                               
%mend utlfkil;                                                 
                                                               
