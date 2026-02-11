%macro slc_mbegin;                                                              
%utlfkil(c:/temp/m_pgm.m);                                                      
%utlfkil(c:/temp/m_pgm.log);                                                    
data _null_;                                                                    
 file "c:/temp/m_pgm.m";                                                        
 input;                                                                         
 put _infile_;                                                                  
%mend slc_mbegin;                                                               
