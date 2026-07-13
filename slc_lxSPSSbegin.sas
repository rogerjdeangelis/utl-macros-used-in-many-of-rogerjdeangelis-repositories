%macro slc_lxSPSSbegin;                                                         
  %utlfkil(\\wsl$\Ubuntu\home\xlr82sas\temp\pspp.ps);                           
  %utlfkil(\\wsl$\Ubuntu\home\xlr82sas\temp\pspp.log);                          
  data _null_;                                                                  
    file  "\\wsl$\Ubuntu\home\xlr82sas\temp\pspp.ps";                           
    input;                                                                      
    put _infile_;                                                               
%mend slc_lxSPSSbegin;                                                          
