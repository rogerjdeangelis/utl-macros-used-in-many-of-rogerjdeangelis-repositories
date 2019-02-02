options cmplib=work.functions;                         
proc fcmp outlib=work.functions.temp;                  
Subroutine utl_pop(string $,word $,action $);          
    outargs word, string;                              
    length word $4096;                                 
    select (upcase(action));                           
      when ("LAST") do;                                
        call scan(string,-1,_action,_length,' ');      
        word=substr(string,_action,_length);           
        string=substr(string,1,_action-1);             
      end;                                             
                                                       
      when ("FIRST") do;                               
        call scan(string,1,_action,_length,' ');       
        word=substr(string,_action,_length);           
        string=substr(string,_action + _length);       
      end;                                             
                                                       
      otherwise put "ERROR: Invalid action";           
                                                       
    end;                                               
endsub;                                                
run;quit;                                              
                                                       
