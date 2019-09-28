/******************************************************************************************/          
/*                                                                                        */          
/*         Name: utlmemList.sas                                                           */          
/*         Type: Macro function                                                           */          
/*                                                                                        */          
/*   Description: Returns list of tables/views in a library                               */          
/*                                                                                        */          
/*   Dependencies                                                                         */          
/*                                                                                        */          
/*   requires 9.4M5, as it has an open %I                                                 */          
/*                                                                                        */          
/*                                                                                        */          
/*   Parameters:                                                                          */          
/*           Lib           - libname  ie work                                             */          
/*           quotecomma    - double quote table names separated by commas:                */          
/*           prx=          - PRX expression                                               */          
/*                                                                                        */          
/*   Examples:                                                                            */          
/*           proc datasets lib=work kill;run;quit;                                        */          
/*           data one two tre;                                                            */          
/*             set sashelp.stocks(keep=ADJCLOSE CLOSE DATE obs=10);                       */          
/*           run;quit;                                                                    */          
/*                                                                                        */          
/*           %put %utl_memlist(work);                            ONE TRE TWO              */          
/*           %put %utl_memlist(sashelp,prx=/class/i);            CLASS CLASSFIT           */          
/*           %put %utl_memlist(work,quotecomma=Y);               "ONE","TRE","TWO"        */          
/*           %put %utl_memlist(work,prx=/one/i);                 ONE                      */          
/*           %put %utl_memlist(work,quotecomma=Y,prx=/one/i);    "ONE"                    */          
/*           %put %utl_memlist(sashelp,prx=/^VS/i,memtype=view); VSACCES VSCATLG VSLIB    */          
/*                                                                                        */          
/*  Inspired by                                                                           */          
/*                                                                                        */          
/*  Søren Lassen, s.lassen@post.tele.dk                                                   */          
/*                                                                                        */          
/*                                                                                        */          
/******************************************************************************************/          
                                                                                                      
%macro utl_memlist(lib,quotecomma=0,prx=0,memtype=data);                                              
                                                                                                      
   %local lst whr;                                                                                    
                                                                                                      
   %let rc=%sysfunc(dosubl('                                                                          
      proc contents data=&lib.._all_ mt=&memtype directory                                            
           out=__dir(keep=memname varnum where=(varnum=1)) noprint nodetails;                         
      run;quit;                                                                                       
      %let whr=%str(where=(1=1));                                                                     
      %if "&prx" ne "0" %then %do;                                                                    
          %let whr=%str(where=(prxmatch("&prx",memname)>0));                                          
          %put &=whr;                                                                                 
      %end;                                                                                           
      data _null_;                                                                                    
         length lst $4096;                                                                            
         retain lst;                                                                                  
         set __dir(&whr) end=dne;                                                                     
         if "&quotecomma" ne "0" then do;                                                             
            lst=catx(",",lst,quote(strip(memname)));                                                  
         end;                                                                                         
         else do;                                                                                     
            lst=catx(" ",lst,memname);                                                                
         end;                                                                                         
                                                                                                      
         if dne then call symputx("lst",lst);                                                         
      run;quit;                                                                                       
      proc datasets lib=work;                                                                         
         delete __dir;                                                                                
      run;quit;                                                                                       
  '));                                                                                                
   &lst                                                                                               
                                                                                                      
%mend utl_memlist;                                                                                    
                                                                                                      
/*                                                                                                    
proc datasets lib=work kill;run;quit;                                                                 
                                                                                                      
data one two tre;                                                                                     
   set sashelp.stocks(keep=ADJCLOSE CLOSE DATE obs=10);                                               
run;quit;                                                                                             
                                                                                                      
%put %utl_memlist(sashelp,prx=/^VS/i,memtype=view);                                                   
%put %utl_memlist(work);                                                                              
%put %utl_memlist(work,quotecomma=Y);                                                                 
%put %utl_memlist(work,prx=/one/i);                                                                   
%put %utl_memlist(work,quotecomma=Y,prx=/one/i);                                                      
*/                                                                                                    
                                                                                                      
                                              
