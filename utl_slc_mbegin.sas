%macro utl_slc_mbegin;                                                          
%utlfkil(c:/temp/m_pgm.m);                                                      
%utlfkil(c:/temp/m_pgm.log);                                                    
data _null_;                                                                    
 infile cards4 ;                                                                
 file "c:/temp/m_pgm.m";                                                        
 input;                                                                         
 put _infile_;                                                                  
%mend utl_slc_mbegin;                                                           
