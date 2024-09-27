%macro utl_chrary(_inp,drop=)                                                                   
   /des="load all character data into a in memory array or drop some vars and then load";       
/*                                                                                              
 %let _inp=sd1.master;                                                                          
 %let drop=;                                                                                    
*/                                                                                              
 %symdel _array rowcol / nowarn;                                                                
 %dosubl(%nrstr(                                                                                
 %symdel _array rowcol/ nowarn;                                                                 
                                                                                                
                                                                                                
 filename clp clipbrd lrecl=64000;                                                              
 data _null_;                                                                                   
 file clp;                                                                                      
 set &_inp(drop=_numeric_ &drop) nobs=rows end=dne;                                             
 array cs[*] _character_;                                                                       
 call symputx('rowcol',catx(',',rows,dim(cs)));                                                 
 length chr $200;                                                                               
 do i=1 to dim(cs,1);                                                                           
    chr=quote(strip(cs[i]));                                                                    
    put  chr @@;                                                                                
    putlog  chr @@;                                                                             
 end;                                                                                           
 run;quit;                                                                                      
 %put &=rowcol;                                                                                 
 data _null_;                                                                                   
 length res $32756;                                                                             
 infile clp;                                                                                    
 input;                                                                                         
 put _infile_;                                                                                  
 putlog _infile_;                                                                               
 res=catx(" ","[&rowcol] $200 (", _infile_,')');                                                
 putlog res;                                                                                    
 call symputx('_array',res);                                                                    
 run;quit;                                                                                      
 ))                                                                                             
 &_array                                                                                        
%mend utl_chrary;                                                                               
                                                                                                
