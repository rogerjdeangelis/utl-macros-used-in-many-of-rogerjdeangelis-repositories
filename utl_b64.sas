%macro utl_b64(dsn) / des="input table zip file des=class.zip amd send b64 code to results";                                            
                                                                                                                                        
    %local zipPth;                                                                                                                      
                                                                                                                                        
    %let wrkpth=%sysfunc(pathname(work));                                                                                               
                                                                                                                                        
    options nodate nonumber ps=32756;                                                                                                   
    title;                                                                                                                              
                                                                                                                                        
    data _null_;                                                                                                                        
                                                                                                                                        
      length b64 $ 76 line $ 57;                                                                                                        
                                                                                                                                        
      retain line "";                                                                                                                   
                                                                                                                                        
      infile "&wrkpth/&dsn..zip" recfm=F lrecl= 1 end=eof;                                                                              
                                                                                                                                        
      input @1 stream $char1.;                                                                                                          
                                                                                                                                        
      substr(line,(_N_-(CEIL(_N_/57)-1)*57),1) = byte(rank(stream));                                                                    
                                                                                                                                        
      if mod(_N_,57)=0 or EOF then do;                                                                                                  
                                                                                                                                        
        if eof then b64=put(trim(line),$base64X76.);                                                                                    
        else b64=put(line, $base64X76.);                                                                                                
        file print;                                                                                                                     
                                                                                                                                        
        put b64;                                                                                                                        
        line="";                                                                                                                        
                                                                                                                                        
      end;                                                                                                                              
    run;quit;                                                                                                                           
                                                                                                                                        
%mend utl_b64;          
