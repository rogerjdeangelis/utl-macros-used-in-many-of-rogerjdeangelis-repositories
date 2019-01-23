%macro bdo_over(array, phrase=%nrstr(%&array(&_I_.)), between=%str( ));    
%local _I_;                                                                
%do _I_ = &&&array.LBOUND %to &&&array.HBOUND;                             
%if &_I_. NE &&&array.LBOUND %then                                         
%do;&between.%end;%unquote(%unquote(&phrase.))                             
%end;                                                                      
%mend bdo_over;                                                            
