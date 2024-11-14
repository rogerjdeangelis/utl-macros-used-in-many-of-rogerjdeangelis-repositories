%macro utl_dirx(pth,out);                                               
       data &out(drop=rc did i);                                        
         retain filename number_of_members filename member_number;      
         rc=filename("mydir","&pth");                                   
         did=dopen("mydir");                                            
         if did > 0 then do;                                            
            number_of_members=dnum(did);                                
            do i=1 to number_of_members;                                
              filename=dread(did,i);                                    
              member_number+1;                                          
              output;                                                   
           end;                                                         
        end;                                                            
      run;quit;                                                         
                                                                        
%mend utl_dirx;                                                         
