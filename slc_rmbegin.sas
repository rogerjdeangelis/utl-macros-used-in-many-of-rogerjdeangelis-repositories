%macro slc_rmbegin;                                                             
  %utlfkil(c:/temp/rm_pgm.xml);                                                 
  %utlfkil(c:/temp/rm_pgm.log);                                                 
  data _null_;                                                                  
    file "c:/temp/rm_pgmx.xml";                                                 
    input;                                                                      
    put _infile_;                                                               
%mend slc_rmbegin;                                                              
