%macro slc_pvpybegin;                                                           
  %utlfkil(c:/temp/py_pgm.py);                                                  
  %utlfkil(c:/temp/py_pgm.py);                                                  
  %utlfkil(c:/temp/py_pgm.log);                                                 
  data _null_;                                                                  
    file "c:/temp/py_pgmx.py";                                                  
    input;put _infile_;                                                         
%mend slc_pvpybegin;                                                            
