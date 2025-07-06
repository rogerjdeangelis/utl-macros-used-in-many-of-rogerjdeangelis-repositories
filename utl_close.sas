%macro utl_close; 

  %utlnopts;   

  /* https://communities.sas.com/t5/user/viewprofilepage/user-id/12151 */
  filename ft15f001 clear;      
  %local i rc;                     
  %do i=1 %to 1000;                
    %let rc=%sysfunc(close(&i));   
  %end;    
  %utlopts;                        
%mend utl_close;                             

 